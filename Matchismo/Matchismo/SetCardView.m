//
//  SetCardView.m
//  Matchismo
//
//  Created by Claus Noergaard on 5/23/13.
//  Copyright (c) 2013 cn. All rights reserved.
//

#import "SetCardView.h"
#import "SetCard.h"

@implementation SetCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        return self;
    }
    return self;
}

#pragma mark - Properties


#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (void)setNumber:(NSString *)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_RADIUS 1.0

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    UIColor *background = self.faceUp?[UIColor grayColor]:[UIColor whiteColor];
    
    [background setFill];
    UIRectFill(self.bounds);
    
    
    UIBezierPath *symbolPath = [self pathForSymbol];
    
#define SYMBOL_HEIGHT 0.22
#define SYMBOL_WIDTH 0.8
#define SYMBOL_OFFSET_Y 0.125
#define SYMBOL_OFFSET_X 0
    
#define SYMBOLSTART @{@"1":@[@0.375], @"2":@[@0.2,@0.55], @"3":@[@0.05,@0.375,@0.70]}
#define COLORTABLE  @{SET_COLOR1:[UIColor redColor], SET_COLOR2:[UIColor greenColor], SET_COLOR3:[UIColor blueColor]}
#define SHADINGTABLE  @{SET_SHADING1:@0.3, SET_SHADING2:@1.0, SET_SHADING3:@0.0}
    
    
    UIColor *color =COLORTABLE[self.color];
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 5.0);
    
    NSArray *symbolstart = SYMBOLSTART[self.number];
    for (NSNumber *offset in symbolstart) {
        
        [symbolPath applyTransform: CGAffineTransformMakeTranslation(0, [offset floatValue] * self.bounds.size.height)];
        [symbolPath fillWithBlendMode: kCGBlendModeNormal alpha:[SHADINGTABLE[self.shading] floatValue]];
        [symbolPath stroke];
        [symbolPath applyTransform: CGAffineTransformMakeTranslation(0, -[offset floatValue] * self.bounds.size.height)];
    }
    
    /*
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
     */
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}



- (UIBezierPath *)pathForSymbol{
    if ([self.symbol isEqualToString:SET_SYMBOL1])
        return [self pathForDiamond];
    else if ([self.symbol isEqualToString:SET_SYMBOL2])
        return [self pathForOval];
    else if ([self.symbol isEqualToString:SET_SYMBOL3])
        return [self pathForSquiggle];
    else return nil;
}

- (CGRect) symbolRect
{
    CGRect symbolBounds;
    
    symbolBounds.size = CGSizeMake(self.bounds.size.width * SYMBOL_WIDTH, self.bounds.size.height * SYMBOL_HEIGHT);
    symbolBounds.origin = CGPointMake((self.bounds.size.width-symbolBounds.size.width)/2,0);
    
    return symbolBounds;
}

- (UIBezierPath *)pathForDiamond {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = [self symbolRect];
    [path moveToPoint:CGPointMake(rect.origin.x + rect.size.width/2,rect.origin.y)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,rect.origin.y+rect.size.height/2)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2,rect.origin.y+rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x ,rect.origin.y+rect.size.height/2)];
    [path closePath];
    
    return path;
}


- (UIBezierPath *)pathForOval
{
    return [UIBezierPath bezierPathWithOvalInRect:[self symbolRect]];
}

#define SIZE_OF_OVAL_CURVE 10

- (UIBezierPath*) pathForSquiggle
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect rect = [self symbolRect];
    CGPoint tl = rect.origin;
    CGPoint middle = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y+rect.size.height/2);
    CGPoint br = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y+rect.size.height);
    
    [path moveToPoint:CGPointMake(br.x,tl.y)];
    [path addQuadCurveToPoint:br controlPoint:CGPointMake(br.x+SIZE_OF_OVAL_CURVE, middle.y)];
    [path addCurveToPoint:CGPointMake(tl.x,br.y)
            controlPoint1:CGPointMake(middle.x, br.y+rect.size.height/2)
            controlPoint2:middle];
    [path addQuadCurveToPoint:tl controlPoint:CGPointMake(tl.x-SIZE_OF_OVAL_CURVE, middle.y)];
    [path addCurveToPoint:CGPointMake(br.x,tl.y)
            controlPoint1:CGPointMake(middle.x, tl.y-rect.size.height/2)
            controlPoint2:middle];
    
    return path;
}

#pragma mark - Initialization

- (void)setup
{
    // do initialization here
}

- (void)awakeFromNib
{
    [self setup];
}
@end
