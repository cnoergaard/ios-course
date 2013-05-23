//
//  Set.h
//  Matchismo
//
//  Created by Claus Noergaard on 5/14/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "Card.h"

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
