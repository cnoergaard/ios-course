//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by cn on 17/05/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noOfCardsToMatch = 2;
}

- (Deck *)CreateDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void) updateButton: (UIButton *)cardButton forCard:(Card *)card {   
    [cardButton setTitle:card.contents forState:UIControlStateSelected];
    [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
    cardButton.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5);
   [cardButton setImage:(card.isFaceUp?nil:[UIImage imageNamed:@"bag.gif"]) forState:UIControlStateNormal];
        
    cardButton.selected = card.isFaceUp;
    cardButton.enabled = !card.isUnplayable;
    cardButton.alpha = card.isUnplayable? 0.3 : 1.0;
}
@end
