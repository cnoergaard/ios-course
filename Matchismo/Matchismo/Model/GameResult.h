//
//  GameResult.h
//  Matchismo
//
//  Created by Claus Noergaard on 5/18/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

typedef NS_ENUM(NSUInteger, ResultType) {
    kNone,
    kFlip,
    kFlipUp,
    kMatch,
    kMisMatch
};

@interface GameResult : NSObject
@property (nonatomic) ResultType type;
@property (strong,nonatomic) Card *cardPlayed; 
@property (strong,nonatomic) NSArray *otherCards; // of cards
@property (nonatomic) NSUInteger score;
@end
