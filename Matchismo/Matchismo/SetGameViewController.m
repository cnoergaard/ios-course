//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Claus Noergaard on 5/14/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetDeck.h"
#import "SetCard.h"
#import "CardMatchingGame.h"
#import "SetCardCollectionViewCell.h"

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lastResultLabel;
@property (weak, nonatomic) IBOutlet SetCardView *playedCardView;
@property (weak, nonatomic) IBOutlet SetCardView *otherCard2View;
@property (weak, nonatomic) IBOutlet SetCardView *otherCard1View;
@end

@implementation SetGameViewController

- (Deck *)CreateDeck {
    return [[SetDeck alloc] init];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.noOfCardsToMatch = 3;
}

- (NSString *)reuseId { return @"SetCard"; }

- (int )initialNoOfCards { return 12; }

- (BOOL) doRemoveMatches { return YES; }

- (void) updateResult: (NSString*)ResultString forCard:(Card *)card with:(NSArray*) others
{
    SetCard *other1=NULL;
    SetCard *other2=NULL;
    self.lastResultLabel.text = ResultString;
    [self updateView:self.playedCardView forCard:(SetCard *)card faceUp:NO];
    if (others.count>0)
      other1 = [others objectAtIndex:0];
    if (others.count>1)
        other2 = [others objectAtIndex:1];

    [self updateView:self.playedCardView forCard:(SetCard *)card faceUp:NO];
    [self updateView:self.otherCard2View forCard:other2 faceUp:NO];
    [self updateView:self.otherCard1View forCard:other1 faceUp:NO];
};

- (void) updateView: (SetCardView *)setCardView forCard:(SetCard *)setCard faceUp:(BOOL)faceUp
{
    setCardView.number = setCard.number;
    setCardView.symbol = setCard.symbol;
    setCardView.shading = setCard.shading;
    setCardView.color = setCard.color;
    setCardView.faceUp = faceUp;
}

- (void) updateCell: (UICollectionViewCell *)cell
            forCard:(Card *)card
            animate:(BOOL)isAnimated
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]] &&
        [card isKindOfClass:[SetCard class]])
    {
        
        SetCard *setCard = (SetCard *)card;
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if (isAnimated)
        {
            [UIView transitionWithView:setCardView
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{ [self updateView:setCardView forCard:setCard faceUp:setCard.isFaceUp]; }
                            completion:NULL];
        }
        else [self updateView:setCardView forCard:setCard faceUp:setCard.isFaceUp];
    }
}

@end
