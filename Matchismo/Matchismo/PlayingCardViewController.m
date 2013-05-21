//
//  PlayingCardViewController.m
//  Matchismo
//
//  Created by cn on 17/05/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "PlayingCardViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardViewController ()

@end

@implementation PlayingCardViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noOfCardsToMatch = 2;
}

- (Deck *)CreateDeck {
    return [[PlayingCardDeck alloc] init];
}

- (void) updateCell: (UICollectionViewCell *)cell forCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]] &&
        [card isKindOfClass:[PlayingCard class]])
    {
        PlayingCard *playingcard = (PlayingCard *)card;
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        
        playingCardView.suit = playingcard.suit;
        playingCardView.rank = playingcard.rank;
        playingCardView.faceUp = playingcard.isFaceUp;
        playingCardView.alpha = playingcard.isUnplayable?0.3:1.0;
    }
}
 

- (NSAttributedString* ) cardAttrString:(Card *)card {
    if (card==nil)
        return nil;
    return [[NSAttributedString alloc] initWithString:card.contents];
}
@end
