//
//  SuperCardViewController.m
//  SuperCard
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "SuperCardViewController.h"
#import "SetCardView.h"
#import "SetDeck.h"
#import "SetCard.h"

@interface SuperCardViewController ()
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@property (strong, nonatomic) Deck *deck;
@end

@implementation SuperCardViewController

- (Deck *)deck
{
    if (!_deck) _deck = [[SetDeck alloc] init];
    return _deck;
}

- (void)setSetCardView:(SetCardView *)setCardView
{
    _setCardView = setCardView;
    [self drawRandomPlayingCard];
    [setCardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:setCardView
                                                                                    action:@selector(pinch:)]];
}

- (void)drawRandomPlayingCard
{
    Card *card = [self.deck drawRandomCard];
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        self.setCardView.number = setCard.number;
        self.setCardView.symbol = setCard.symbol;
        self.setCardView.shading = setCard.shading;
        self.setCardView.color = setCard.color;
    }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender
{
    [UIView transitionWithView:self.setCardView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        if (!self.setCardView.faceUp) [self drawRandomPlayingCard];
                        self.setCardView.faceUp = !self.setCardView.faceUp;
                    }
                    completion:NULL];
    
}
@end
