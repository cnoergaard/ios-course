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
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeButton;
@end

@implementation CardGameViewController


- (CardMatchingGame*)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[self CreateDeck]
                                                   noOfCardsToMatch:self.noOfCardsToMatch];

    return _game;
}

- (Deck *)CreateDeck
{
    return nil;
}

- (void) updateButton: (UIButton *)Button forCard:(Card *)card
{
    
}

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
    [self.gameModeButton setEnabled:NO];
}

- (IBAction)Deal:(id)sender {
   [self Restart];
}

- (void)Restart {
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
    [self.gameModeButton setEnabled:YES ];
}

- (void) updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [self updateButton:cardButton forCard:card];
    }
    self.lastResultLabel.text = self.game.lastResult;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.score];
}

@end
