//
//  CardGameViewController.m
//  Matchismo
//
//  Created by cn on 01/05/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastResultLabel;
@end

@implementation CardGameViewController


- (CardMatchingGame*)game {
    if (!_game) _game = [[CardMatchingGame alloc]
                         initWithCardCount:self.initialNoOfCards
                         usingDeck:[self CreateDeck]
                         noOfCardsToMatch:self.noOfCardsToMatch
                         flipCost:1
                         matchBonus:4
                         misMatchPenalty:2];
    return _game;
}

- (Deck *)CreateDeck{ return nil; } //abstract
- (void) updateCell: (UICollectionViewCell *)cell
            forCard:(Card *)card
            animate:(BOOL)isAnimated {} //abstract
- (NSAttributedString* ) cardAttrString:(Card *)card { return nil;} //abstract
- (NSString *)reuseId { return nil; } //abstract

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.game.numberOfCardsInGame;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseId forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell forCard:card animate:NO];
    return cell;
}


- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips :%d", self.flipCount];
}


- (IBAction)flipCard:(UITapGestureRecognizer *) gesture {
    CGPoint tapPoint = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *index = [self.cardCollectionView indexPathForItemAtPoint:tapPoint];
    if (index)
    {
        [self.game flipCardAtIndex:index.item];
        self.flipCount++;
        [self updateUI:index.item];
    }
}

- (IBAction)Deal:(id)sender {
   [self Restart];
}

- (void)Restart {
    self.game = nil;
    self.flipCount = 0;
    [self updateUI:-1];
}

- (void) updateUI:(NSUInteger)animateIndex
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *path = [self.cardCollectionView indexPathForCell:cell];
        Card *card =  [self.game cardAtIndex:path.item];
        [self updateCell:cell forCard:card animate:(path.item==animateIndex)];
    }
    self.lastResultLabel.attributedText = [self getResult:self.game.lastResult];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.score];
}

- (NSAttributedString *) getResult:(GameResult *)result {
    NSMutableAttributedString *attres;
    attres = [[NSMutableAttributedString alloc] initWithAttributedString:[self cardAttrString:result.cardPlayed]];
    if (result.type == kFlip)
        [attres appendAttributedString:
          [[NSAttributedString alloc] initWithString:@" flipped"]];
    else if (result.type == kFlipUp)
        [attres appendAttributedString:
         [[NSAttributedString alloc] initWithString:@" turned up"]];
    else
    {
        NSMutableAttributedString *others = [[NSMutableAttributedString alloc] init];
        for (Card *othercard in result.otherCards)
        {
          [others appendAttributedString:[self cardAttrString:othercard]];
           if (othercard!=result.otherCards.lastObject)
               [others appendAttributedString: [[NSAttributedString alloc] initWithString:@" & "]];
        }
       if (result.type == kMatch)
       {
           [attres appendAttributedString:
             [[NSAttributedString alloc] initWithString:@" matched with "]];
           [attres appendAttributedString:others];
           [attres appendAttributedString:
            [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points", result.score]]];
       }
       else if (result.type == kMisMatch)
       {
        [attres appendAttributedString:
         [[NSAttributedString alloc] initWithString:@" does not match with "]];
        [attres appendAttributedString:others];
        [attres appendAttributedString:
         [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %d points penalty", -result.score]]];
       }
       else attres = nil;
    }
   return attres;
}

@end
