//
//  SetDeck.m
//  Matchismo
//
//  Created by Claus Noergaard on 5/14/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck
- (id) init
{
    self = [super init];
    if (self) {
    for (NSString *symbol in [SetCard validSymbols]) {
     for (NSString *number in [SetCard validNumbers]){
      for (NSString *shading in [SetCard validShadings]) {
       for (NSString *color in [SetCard validColors]){
           SetCard *setcard = [[SetCard alloc] init];
           setcard.number = number;
           setcard.symbol = symbol;
           setcard.shading = shading;
           setcard.color = color;
           [self addCard:setcard atTop:YES];
       }}}}}
    return self;
}

@end
