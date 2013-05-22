//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Claus Noergaard on 5/21/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end