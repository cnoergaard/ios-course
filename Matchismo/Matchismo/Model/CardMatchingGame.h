//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by cn on 06/05/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "GameResult.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck: (Deck *)deck
       noOfCardsToMatch:(NSUInteger) noOfCardsToMatch
               flipCost:(NSUInteger) flipCost
             matchBonus:(NSUInteger) matchBonus
        misMatchPenalty:(NSUInteger) misMatchPenalty;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSUInteger)drawCard;
- (void )removeCardAtIndex:(NSUInteger)index;

@property (nonatomic,readonly) NSUInteger numberOfCardsInGame;
@property (nonatomic,strong,readonly) GameResult *lastResult;
@property (nonatomic,readonly) NSUInteger score;

@end

