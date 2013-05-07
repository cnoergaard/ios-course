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
@property (strong,nonatomic) NSString *lastResult;
@property (nonatomic) int score;

@end


@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
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
        
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index]:nil;
}

#define FLIP_COST 1
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            self.lastResult = [NSString stringWithFormat:@"%@ flipped", card.contents];
          for (Card *otherCard in self.cards) {
              if (otherCard.isFaceUp && !otherCard.isUnplayable ) {
                  int matchScore = [card match:@[otherCard]];
                  if (matchScore) {
                      otherCard.unplayable = YES;
                      card.unplayable = YES;
                      self.score += matchScore * MATCH_BONUS;
                      self.lastResult = [NSString stringWithFormat:@"Matched %@ & %@ for %d points",card.contents,otherCard.contents, matchScore * MATCH_BONUS];
                  } else {
                      otherCard.FaceUp = NO;
                      self.score -= MISMATCH_PENALTY;
                      self.lastResult = [NSString stringWithFormat:@"%@ and %@ does not match. %d points penalty",card.contents,otherCard.contents, MISMATCH_PENALTY];

                  }
                  break;
              } 
          }
       } else {
          self.lastResult = [NSString stringWithFormat:@"%@ turned up", card.contents];
       }
       self.score -= FLIP_COST;
       card.faceUp = !card.isFaceUp;
   }
}

@end
