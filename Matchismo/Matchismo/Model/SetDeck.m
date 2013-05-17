//
//  SetDeck.m
//  Matchismo
//
//  Created by Claus Noergaard on 5/14/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "SetDeck.h"
#import "Set.h"

@implementation SetDeck
- (id) init
{
    self = [super init];
    if (self) {
    for (NSString *symbol in [Set validSymbols]) {
     for (NSString *number in [Set validNumbers]){
      for (NSString *shading in [Set validShadings]) {
       for (NSString *color in [Set validColors]){
           Set *setcard = [[Set alloc] init];
           setcard.number = number;
           setcard.symbol = symbol;
           setcard.shading = shading;
           setcard.color = color;
           [self addCard:setcard atTop:YES];
       }}}}}
    return self;
}

@end
