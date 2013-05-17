//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by cn on 06/05/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck: (Deck *)deck noOfCardsToMatch:(int) noOfCardsToMatch;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic,strong,readonly) NSString *lastResult;
@property (nonatomic,readonly)int score;

@end

