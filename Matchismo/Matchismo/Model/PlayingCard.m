//
//  PlayingCard.m
//  Matchismo
//
//  Created by cn on 01/05/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];
    return validSuits;
}

- (void )setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *) suit
{
    return _suit ? _suit: @"?";
}

+ (NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"B",@"D",@"K"];
    return rankStrings;
    
}

+ (NSUInteger) maxRank
{
    return [[self rankStrings] count]-1;
}

- (int) match:(NSArray *)otherCards {
    int score=0;
    if (otherCards.count == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1; 
        } else if (otherCard.rank == self.rank) {
            score = 4; 
        }
    } else if (otherCards.count == 2) {
        PlayingCard *firstCard = [otherCards lastObject];
        PlayingCard *secondCard = [otherCards objectAtIndex:0];
        if (([firstCard.suit isEqualToString:self.suit]) && 
            ([secondCard.suit isEqualToString:self.suit])) {
            score = 5;
        } else if ((firstCard.rank == self.rank) &&
            (secondCard.rank == self.rank)) {
            score = 110;
        }
    }
    
    return score;
}


@end
