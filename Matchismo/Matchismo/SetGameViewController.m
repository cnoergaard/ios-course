//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Claus Noergaard on 5/14/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"
#import "Set.h"
#import "Deck.h"
#import "CardMatchingGame.h"

@interface SetGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (nonatomic) int flipCount;
@property (nonatomic) int gameMode;

@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation SetGameViewController


- (CardMatchingGame*) game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[SetDeck alloc] init]];
    _game.noOfCardsToMatch = 3;
    return _game;
}


- (void )setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    //self.flipsLabel.text = [NSString stringWithFormat:@"Flips :%d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    if (!sender.selected) {
        self.flipCount++;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateUI];
   // [self.gameModeButton setEnabled:NO];
}

- (IBAction)Deal:(id)sender {
    [self Restart];
}

- (void)Restart {
    self.game = nil;
    self.flipCount = 0;
    [self updateUI];
 //   [self.gameModeButton setEnabled:YES ];
}

#define COLORS @{@"red":[UIColor redColor],@"green":[UIColor greenColor],@"blue":[UIColor blueColor]}
#define SHADINGS @{@"striped":@"0.4",@"solid":@"1.0",@"open":@"0.0"}


- (void) updateUI {
        for (UIButton *cardButton in self.cardButtons) {
    
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if ([card isKindOfClass:[Set class]])
        {
            Set *setcard = (Set *)card;
            NSMutableString *symbols = [[NSMutableString alloc] init];
            NSUInteger number = [setcard.number intValue];
            for (NSUInteger i=0; i<number; i++)
                [symbols appendString:setcard.symbol];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:symbols];
            UIColor *color = [COLORS objectForKey:setcard.color];
            [attr setAttributes:@{NSForegroundColorAttributeName:[color colorWithAlphaComponent:[[SHADINGS objectForKey:setcard.shading] floatValue]],
                                  NSStrokeColorAttributeName:color,
                                  NSStrokeWidthAttributeName:@-6.0} range:NSMakeRange(0, number)];
            [cardButton setAttributedTitle:attr forState:UIControlStateNormal];
         }
        
        cardButton.selected = card.isFaceUp;
        cardButton.backgroundColor = card.isFaceUp?[UIColor grayColor]:[UIColor clearColor];

        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable? 0.3 : 1.0;
    }
//    self.lastResultLabel.text = self.game.lastResult;
 //   self.scoreLabel.text = [NSString stringWithFormat:@"Score :%d", self.game.score];
}

- (IBAction)GameModeChanged:(UISegmentedControl *)sender {
    self.gameMode = 2 + sender.selectedSegmentIndex;
    [self Restart];
}
@end
