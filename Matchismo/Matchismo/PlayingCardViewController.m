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
@property (weak, nonatomic) IBOutlet UILabel *lastResultLabel;
@property (weak, nonatomic) IBOutlet PlayingCardView *playedCardView;
@property (weak, nonatomic) IBOutlet PlayingCardView *otherCardView;
@end

@implementation PlayingCardViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noOfCardsToMatch = 2;
}

- (Deck *)CreateDeck {
    return [[PlayingCardDeck alloc] init];
}

- (NSString *)reuseId { return @"PlayingCard"; }

- (int )initialNoOfCards { return 20; }

- (void) updateResult: (NSString*)ResultString forCard:(Card *)card with:(NSArray*) others
{
    PlayingCard *other=NULL;
    PlayingCard *playingcard = (PlayingCard *)card;
    if (others.count>0)
        other = [others objectAtIndex:0];
    
    self.playedCardView.suit = playingcard.suit;
    self.playedCardView.rank = playingcard.rank;
    self.playedCardView.faceUp = YES;

    self.otherCardView.suit = other.suit;
    self.otherCardView.rank = other.rank;
    self.otherCardView.faceUp = YES;

    self.lastResultLabel.text = ResultString;
};

- (void) updateView: (PlayingCardView *)playingCardView forCard:(PlayingCard *)playingcard
{
    playingCardView.suit = playingcard.suit;
    playingCardView.rank = playingcard.rank;
    playingCardView.faceUp = playingcard.isFaceUp;
    playingCardView.alpha = playingcard.isUnplayable?0.3:1.0;

}

- (void) updateCell: (UICollectionViewCell *)cell
            forCard:(Card *)card
            animate:(BOOL)isAnimated
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]] &&
        [card isKindOfClass:[PlayingCard class]])
    {
        PlayingCard *playingcard = (PlayingCard *)card;
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if (isAnimated)
        {
          [UIView transitionWithView:playingCardView
                          duration:0.5
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                          animations:^{ [self updateView:playingCardView forCard:playingcard]; }                          completion:NULL];
        }
        else [self updateView:playingCardView forCard:playingcard];

    }
}


@end
