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

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastResultLabel;
@end

@implementation CardGameViewController


- (CardMatchingGame*)game {
    if (!_game) _game = [[CardMatchingGame alloc]
                         initWithCardCount:self.cardButtons.count
                         usingDeck:[self CreateDeck]
                         noOfCardsToMatch:self.noOfCardsToMatch
                         flipCost:1
                         matchBonus:4
                         misMatchPenalty:2];
    return _game;
}

- (Deck *)CreateDeck
{ return nil; }

- (void) updateButton: (UIButton *)Button forCard:(Card *)card
{}

- (NSAttributedString* ) cardAttrString:(Card *)card
{ return nil;}

- (void )setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips :%d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    if (!sender.selected) {
         self.flipCount++;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateUI];
}

- (IBAction)Deal:(id)sender {
   [self Restart];
}

- (void)Restart {
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
}

- (void) updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [self updateButton:cardButton forCard:card];
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
