//
//  Set.m
//  Matchismo
//
//  Created by Claus Noergaard on 5/14/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "Set.h"

@implementation Set
@synthesize symbol = _symbol;

+ (NSArray *)validShadings
{
    static NSArray *validShadings = nil;
    if (!validShadings) validShadings = @[@"striped",@"solid",@"open"];
    return validShadings;
}

- (void )setShading:(NSString *)shading
{
    if ([[Set validShadings] containsObject:shading]) {
        _shading = shading;
    }
}

+ (NSArray *)validSymbols
{
    static NSArray *validSymbols = nil;
    if (!validSymbols) validSymbols = @[@"▲",@"●",@"■"];
    return validSymbols;
}

- (void )setSymbol:(NSString *)symbol
{
    if ([[Set validSymbols] containsObject:symbol]) {
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
    if ([[Set validNumbers] containsObject:number]) {
        _number = number;
    }
}


+ (NSArray *)validColors
{
    static NSArray *validColors = nil;
    if (!validColors) validColors = @[@"red",@"green",@"blue"];
    return validColors;
}

- (void )setColor:(NSString *)color
{
    if ([[Set validColors] containsObject:color]) {
        _color = color;
    }
}

- (NSString *) contents
{
    return [NSString stringWithFormat:@"%@-%lu-%@-%@",self.symbol,(unsigned long)self.number,self.color,self.shading];
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
        if ([firstCard isKindOfClass:[Set class]] && [secondCard isKindOfClass:[Set class]])
        {
            Set *first = (Set *)firstCard;
            Set *second  = (Set *)secondCard;
            if ([Set propMatch:self.symbol  second:first.symbol  third:second.symbol] &&
                [Set propMatch:self.shading second:first.shading third:second.shading] &&
                [Set propMatch:self.number  second:first.number  third:second.number] &&
                [Set propMatch:self.color   second:first.color   third:second.color])
            {
                score = 10;
            }
        }
    }
    return score;
}



@end
