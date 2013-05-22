//
//  CardGameViewController.h
//  Matchismo
//
//  Created by cn on 01/05/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (nonatomic) int noOfCardsToMatch;
@property (nonatomic,readonly) NSString *reuseId;
- (Deck *)CreateDeck;   //abstract
- (void) updateCell: (UICollectionViewCell *)cell forCard:(Card *)card; //abstract
- (NSAttributedString* ) cardAttrString:(Card *)card;  //abstract


@end
