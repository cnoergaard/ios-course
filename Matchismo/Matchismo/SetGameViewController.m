//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Claus Noergaard on 5/14/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"

@interface SetGameViewController ()
@end

@implementation SetGameViewController

- (Deck *)CreateDeck {
    return [[SetDeck alloc] init];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noOfCardsToMatch = 3;
}


#define COLORS @{@"red":[UIColor redColor],@"green":[UIColor greenColor],@"blue":[UIColor blueColor]}
#define SHADINGS @{@"striped":@"0.4",@"solid":@"1.0",@"open":@"0.0"}

- (NSAttributedString* ) cardAttrString:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]])
    {
        SetCard *setcard = (SetCard *)card;
        NSMutableString *symbols = [[NSMutableString alloc] init];
        NSUInteger number = [setcard.number intValue];
        for (NSUInteger i=0; i<number; i++)
            [symbols appendString:setcard.symbol];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:symbols];
        UIColor *color = [COLORS objectForKey:setcard.color];
        [attr setAttributes:@{NSForegroundColorAttributeName:[color colorWithAlphaComponent:[[SHADINGS objectForKey:setcard.shading] floatValue]],
 NSStrokeColorAttributeName:color,
 NSStrokeWidthAttributeName:@-6.0} range:NSMakeRange(0, number)];
        return attr;
    }
    else
        return nil;
}

- (void) updateButton: (UIButton *)cardButton forCard:(Card *)card
{
    [cardButton setAttributedTitle:[self cardAttrString:card] forState:UIControlStateNormal];
    cardButton.selected = card.isFaceUp;
    cardButton.backgroundColor = card.isFaceUp?[UIColor grayColor]:[UIColor clearColor];
    
    cardButton.enabled = !card.isUnplayable;
    cardButton.alpha = card.isUnplayable? 0.0 : 1.0;
}

@end
