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
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@end

@implementation CardGameViewController

- (Deck *)CreateDeck{ return nil; } //abstract
- (void) updateCell: (UICollectionViewCell *)cell
            forCard:(Card *)card
            animate:(BOOL)isAnimated {} //abstract
- (NSString *)reuseId { return nil; } //abstract
- (void) updateResult: (NSString*)ResultString forCard:(Card *)card with:(NSArray*) others{}; //abstract
- (BOOL) doRemoveMatches { return NO; }


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
        if (self.game.lastResult.type==kMatch && self.doRemoveMatches)
        {
            NSMutableArray *matches = [[NSMutableArray alloc] init];
            for (NSUInteger inx=self.game.numberOfCardsInGame-1; ;inx--)
            {
                Card *card = [self.game cardAtIndex:inx];
                if (card.isUnplayable)
                {
                    [matches addObject:[NSIndexPath indexPathForRow:inx inSection:0]];
                    [self.game removeCardAtIndex:inx];
                }
                if (inx==0) break;
            }
            [self.cardCollectionView deleteItemsAtIndexPaths:matches];
        }
        self.flipCount++;
        [self updateUI:index.item];
    }
}

- (IBAction)Deal:(id)sender {
    self.game = nil;
    self.flipCount = 0;
    [self.cardCollectionView reloadData];
    self.moreButton.enabled = YES;
    [self updateResult:nil];
}

- (IBAction)dealMoreCards:(id)sender
{
    for (NSUInteger i=0; i<3; i++)
    {
      NSUInteger inx = [self.game drawCard];
      if (inx==NSUIntegerMax)
      {
          self.moreButton.enabled = NO;
      }
      else
      {
         NSIndexPath *path = [NSIndexPath indexPathForRow:inx inSection:0];
        [self.cardCollectionView insertItemsAtIndexPaths:@[path]];
        [self.cardCollectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
      }
   }
}

- (void) viewDidLoad
{
  [self updateResult:nil];
}

- (void) updateUI:(NSUInteger)animateIndex
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *path = [self.cardCollectionView indexPathForCell:cell];
        Card *card =  [self.game cardAtIndex:path.item];
        [self updateCell:cell forCard:card animate:(path.item==animateIndex)];
    }
    [self updateResult:self.game.lastResult];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.score];
}

- (void) updateResult: (GameResult *)result {
    NSString *ResultString;
    if (result.type == kFlip)
      ResultString = @"flipped";
    else if (result.type == kFlipUp)
      ResultString =  @"turned up";
    else if (result.type == kMatch)
      ResultString =  @"matched with ";
    else if (result.type == kMisMatch)
      ResultString =  @"does not match with";
    else
      ResultString =  @"Select a card";
    [self updateResult:ResultString forCard:result.cardPlayed with:result.otherCards];
}


@end
