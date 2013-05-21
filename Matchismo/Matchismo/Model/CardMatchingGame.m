//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by cn on 06/05/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "CardMatchingGame.h"
@interface CardMatchingGame();
@property (strong,nonatomic) NSMutableArray *cards;
@property (nonatomic) int noOfCardsToMatch;
@property (strong,nonatomic) GameResult *lastResult;
@property (nonatomic) NSUInteger score;
@property (nonatomic) NSUInteger numberOfCardsInGame;
@property (nonatomic) NSUInteger flipCost;
@property (nonatomic) NSUInteger matchBonus;
@property (nonatomic) NSUInteger misMatchPenalty;
@end


@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (GameResult *)lastResult {
    if (!_lastResult) _lastResult = [[GameResult alloc] init];
    return _lastResult;
}


- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck: (Deck *)deck
       noOfCardsToMatch: (NSUInteger)noOfCardsToMatch
               flipCost:(NSUInteger) flipCost
             matchBonus:(NSUInteger) matchBonus
        misMatchPenalty:(NSUInteger) misMatchPenalty;

{
    self = [super init];
    if (self) {
        for (int i=0;i<cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
        self.noOfCardsToMatch = noOfCardsToMatch;
        self.numberOfCardsInGame = cardCount;
        self.flipCost = flipCost;
        self.matchBonus = matchBonus;
        self.misMatchPenalty = misMatchPenalty;
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index]:nil;
}

- (void)flipCardAtIndex:(NSUInteger)index {
    NSMutableArray *selectedCards;
    Card *card = [self cardAtIndex:index];
    self.lastResult.cardPlayed = card;
    self.lastResult.score = 0;
    self.lastResult.otherCards = nil;
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
          selectedCards = [[NSMutableArray alloc] init];
          for (Card *otherCard in self.cards) {
              if (otherCard.isFaceUp && !otherCard.isUnplayable ){ 
                  [selectedCards addObject:otherCard];
          }}
               
          if ([selectedCards count]==self.noOfCardsToMatch-1) {
                  self.lastResult.otherCards = selectedCards;
                  int matchScore = [card match:selectedCards];
                  if (matchScore) {
                      for (Card *otherCard in selectedCards) {
                        otherCard.unplayable = YES;
                      }
                      card.unplayable = YES;
                      self.lastResult.score = matchScore * self.matchBonus;
                      self.lastResult.type = kMatch;
                  } else {
                      for (Card *otherCard in selectedCards) {
                        otherCard.faceUp = NO;
                      }
                      self.lastResult.score = -self.misMatchPenalty;
                      self.lastResult.type = kMisMatch;
                  }
              } else {
                  self.lastResult.type = kFlip;
           }
       } else {
          self.lastResult.type = kFlipUp;
       }
       self.score += self.lastResult.score - self.flipCost;
       card.faceUp = !card.isFaceUp;
   }
}

@end
