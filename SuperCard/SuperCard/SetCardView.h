//
//  SetCardView.h
//  Matchismo
//
//  Created by Claus Noergaard on 5/23/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong,nonatomic) NSString *number;
@property (strong,nonatomic) NSString *symbol;
@property (strong,nonatomic) NSString *shading;
@property (strong,nonatomic) NSString *color;
@property (nonatomic) BOOL faceUp;



@end
