//
//  Set.h
//  Matchismo
//
//  Created by Claus Noergaard on 5/14/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "Card.h"

#define SET_SYMBOL1 @"diamond"
#define SET_SYMBOL2 @"oval"
#define SET_SYMBOL3 @"squiggle"
#define SET_SHADING1 @"striped"
#define SET_SHADING2 @"solid"
#define SET_SHADING3 @"open"
#define SET_COLOR1 @"red"
#define SET_COLOR2 @"green"
#define SET_COLOR3 @"blue"



@interface SetCard : Card
@property (strong,nonatomic) NSString *number;
@property (strong,nonatomic) NSString *symbol;
@property (strong,nonatomic) NSString *shading;
@property (strong,nonatomic) NSString *color;

+ (NSArray *) validSymbols;
+ (NSArray *) validShadings;
+ (NSArray *) validColors;
+ (NSArray *) validNumbers;

@end
