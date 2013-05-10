//
//  CardGameViewController.m
//  Matchismo
//
//  Created by cn on 01/05/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (nonatomic) int gameMode;

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastResultLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeButton;
@end

@implementation CardGameViewController


- (CardMatchingGame*)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    _game.noOfCardsToMatch = self.gameMode;
    return _game;
}


- (void )setCardButtons:(NSArray *)cardButtons {
    UIImage *cardBackImage = [UIImage imageNamed:@"bag.gif"];
    _cardButtons = cardButtons;
    
    for (UIButton *cardButton in cardButtons) {
        [cardButton setImage:nil forState:UIControlStateSelected];
        [cardButton setImage:nil forState:UIControlStateSelected|UIControlStateDisabled];

    }
    self.gameMode = 2;
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
    UIImage *cardBackImage = [UIImage imageNamed:@"bag.gif"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.imageEdgeInsets = UIEdgeInsetsMake(4,4,4,4);
        [cardButton setImage:(card.isFaceUp?nil:cardBackImage)forState:UIControlStateNormal];

        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable? 0.3 : 1.0;
    }
    self.lastResultLabel.text = self.game.lastResult;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.score];
}
- (IBAction)GameModeChanged:(UISegmentedControl *)sender {
    self.gameMode = 2 + sender.selectedSegmentIndex;
    [self Restart];
}

@end
