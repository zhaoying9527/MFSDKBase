//
//  MFImageView.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFImageView.h"
#import "MFHelper.h"
#import "MFResourceCenter.h"
#import "NSObject+DOM.h"

@interface MFImageView()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)UITapGestureRecognizer *singleTap;
@property (nonatomic,strong)UILongPressGestureRecognizer *longPressTap;
@property (nonatomic,strong)UIImageView *maskImageView;
@property (nonatomic,assign)CGRect rawRect;
@end

@implementation MFImageView
- (void)dealloc
{
    [self releaseTapGestureRecognizer];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.corner = NO;
        self.aspectFit = NO;
        self.side = NO;
        self.align = MFAlignmentTypeLeft;
    }
    
    return self;
}

- (void)setTouchEnabled:(BOOL)touchEnabled
{
    _touchEnabled = touchEnabled;
    if (touchEnabled) {
        [self setupTapGestureRecognizer];
        [self setupLongPressGestureRecognizer];
    }else {
        [self releaseTapGestureRecognizer];
        [self releaseLongPressGestureRecognizer];
    }
}

- (void)setAspectFit:(BOOL)aspectFit
{
    if (aspectFit) {
        self.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.contentMode = UIViewContentModeScaleToFill;
    }
}

- (void)setCorner:(BOOL)corner
{
    _corner = corner;
    if (_corner) {
        if (nil == self.maskImageView) {
            UIImage *maskImage = [MFResourceCenter imageNamed:@"facemask.png"];
            self.maskImageView = [[UIImageView alloc] initWithImage:maskImage];
            [self addSubview:self.maskImageView];
            [self bringSubviewToFront:self.maskImageView];
        }
        self.maskImageView.hidden = YES;
    }
}
#pragma mark --
#pragma mark TapGestureRecognizer
- (void)setupTapGestureRecognizer
{
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired = 1; //tap次数
    self.singleTap.delegate = self;
    [self addGestureRecognizer:self.singleTap];
}

- (void)releaseTapGestureRecognizer
{
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = NO;
    self.singleTap = nil;
}

- (void)setupLongPressGestureRecognizer
{
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;
    self.longPressTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressEvent:)];
    self.longPressTap.numberOfTouchesRequired = 1; //手指数
    self.longPressTap.numberOfTapsRequired = 1; //tap次数
    self.longPressTap.delegate = self;
    [self addGestureRecognizer:self.longPressTap];
}

- (void)releaseLongPressGestureRecognizer
{
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = NO;
    self.longPressTap = nil;
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if (sender.numberOfTapsRequired == 1) {
    id result = [self.DOM triggerEvent:kMFOnClickEventKey withParams:@{}];
        NSLog(@"%@",result);
    }
}

- (void)handleLongPressEvent:(UITapGestureRecognizer *)sender
{
    id result = [self.DOM triggerEvent:kMFOnKeyLongPressEventKey withParams:@{}];
    NSLog(@"%@",result);
}

- (UIImage*)transStyleImageWithName:(NSString*)imageName
{
    return [[MFResourceCenter sharedMFResourceCenter] imageWithId:imageName];
}

- (UIImage *)styleCenterImageWithId:(NSString*)imageId
{
    UIImage *retImage = [[MFResourceCenter sharedMFResourceCenter] cacheImageWithId:imageId];
    if (nil == retImage) {
        UIImage * image = [self transStyleImageWithName:imageId];
        retImage = [MFHelper stretchableCellImage:image];
        [[MFResourceCenter sharedMFResourceCenter] cacheImage:retImage key:imageId];
    }
    return retImage;
}

- (UIImage*)styleLeftImageWithId:(NSString*)imageId
{
    UIImage *retImage = [[MFResourceCenter sharedMFResourceCenter] cacheImageWithId:imageId];
    if (nil == retImage) {
        UIImage * image = [self transStyleImageWithName:imageId];
        retImage = [MFHelper resizeableLeftBgImage:image];
        [[MFResourceCenter sharedMFResourceCenter] cacheImage:retImage key:imageId];
    }
    return retImage;
}

- (UIImage*)styleRightImageWithId:(NSString*)imageId
{
    UIImage *retImage = [[MFResourceCenter sharedMFResourceCenter] cacheImageWithId:imageId];
    if (nil == retImage) {
        UIImage * image = [self transStyleImageWithName:imageId];
        retImage = [MFHelper resizeableRightBgImage:image];
        [[MFResourceCenter sharedMFResourceCenter] cacheImage:retImage key:imageId];
    }
    return retImage;
}

- (void)setStyle:(NSString*)style
{
    
    _style = style;

    NSArray *styleArray = [style componentsSeparatedByString:@","];
    if ([styleArray count]>=2) {
        switch (self.alignmentType) {
            case MFAlignmentTypeLeft:
                self.image = [self styleLeftImageWithId:[styleArray objectAtIndex:0]];
                break;
            case MFAlignmentTypeCenter:
                self.image = [self styleCenterImageWithId:[styleArray objectAtIndex:0]];
                break;
            case MFAlignmentTypeRight:
                self.image = [self styleRightImageWithId:[styleArray objectAtIndex:1]];
                break;
            default:
                break;
        }
    } else {
        self.image = [self styleLeftImageWithId:[styleArray objectAtIndex:0]];
    }
}

- (void)setFrame:(CGRect)frame
{
    if (MFAlignmentTypeLeft == self.alignmentType) {
        self.rawRect = frame;
    }
    
    [super setFrame:frame];
    
    self.maskImageView.hidden = !self.corner;
    self.maskImageView.frame = self.bounds;
}

- (void)setAlign:(NSInteger)align
{
    _align = align;
    self.alignmentType = _align;
}

- (void)setSide:(BOOL)side
{
    _side = side;
}

- (void)centerLayout
{
    CGRect rect = self.rawRect;
    CGSize screenXY = [MFHelper screenXY];
    rect.origin.x = (screenXY.width - rect.size.width)/2;
    [super setFrame:rect];
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    self.style = _style;
    if (self.side) {
        if (MFAlignmentTypeLeft == _alignmentType) {
            self.frame = self.rawRect;
        } else if (MFAlignmentTypeCenter == _alignmentType) {
        } else if (MFAlignmentTypeRight == _alignmentType) {
        }
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}
@end
