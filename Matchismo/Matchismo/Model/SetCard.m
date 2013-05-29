//
//  Set.m
//  Matchismo
//
//  Created by Claus Noergaard on 5/14/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

@synthesize symbol = _symbol;

+ (NSArray *)validShadings
{
    static NSArray *validShadings = nil;
    if (!validShadings) validShadings = @[SET_SHADING1,SET_SHADING2,SET_SHADING3];
    return validShadings;
}

- (void )setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

+ (NSArray *)validSymbols
{
    static NSArray *validSymbols = nil;
    if (!validSymbols) validSymbols = @[SET_SYMBOL1,SET_SYMBOL2,SET_SYMBOL3];
    return validSymbols;
}

- (void )setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (NSString *)symbol
{
    return _symbol ? _symbol: @"?";
}


+ (NSArray *)validNumbers
{
    static NSArray *validNumbers = nil;
    if (!validNumbers) validNumbers =@[@"1",@"2",@"3"];
    return validNumbers;
    
}

- (void )setNumber:(NSString *)number
{
    if ([[SetCard validNumbers] containsObject:number]) {
        _number = number;
    }
}


+ (NSArray *)validColors
{
    static NSArray *validColors = nil;
    if (!validColors) validColors = @[SET_COLOR1,SET_COLOR2,SET_COLOR3];
    return validColors;
}

- (void )setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *) contents
{
    return [NSString stringWithFormat:@"%@-%@-%@-%@",self.symbol,self.number,self.color,self.shading];
}

/*- (BOOL)selMatch:(SEL)sel first:(Set*)first second:(Set*) second {
 NSString *f = [self performSelector:sel];
 NSString *s = [first performSelector:sel];
 NSString *t = [second performSelector:sel];
 return (([f isEqualToString:s] &&
 [s isEqualToString:t] &&
 [f isEqualToString:t]) ||
 (![f isEqualToString:s] &&
 ![s isEqualToString:t] &&
 ![f isEqualToString:t]));
 
 }
 */

+ (BOOL)propMatch:(NSString *)first second:(NSString *)second third:(NSString*)third
{
    return (([first isEqualToString:second] &&
             [second isEqualToString:third] &&
             [first isEqualToString:third]) ||
            (![first isEqualToString:second] &&
             ![second isEqualToString:third] &&
             ![first isEqualToString:third]));
}

- (int) match:(NSArray *)otherCards {
    int score=0;
    if (otherCards.count == 2) {
        Card *firstCard = [otherCards lastObject];
        Card *secondCard = [otherCards objectAtIndex:0];
        if ([firstCard isKindOfClass:[SetCard class]] && [secondCard isKindOfClass:[SetCard class]])
        {
            SetCard *first = (SetCard *)firstCard;
            SetCard *second  = (SetCard *)secondCard;
            if ([SetCard propMatch:self.symbol  second:first.symbol  third:second.symbol] &&
                [SetCard propMatch:self.shading second:first.shading third:second.shading] &&
                [SetCard propMatch:self.number  second:first.number  third:second.number] &&
                [SetCard propMatch:self.color   second:first.color   third:second.color])
            {
                score = 10;
            }
        }
    }
    return score;
}



@end
