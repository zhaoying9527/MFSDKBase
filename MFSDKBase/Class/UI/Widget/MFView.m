//
//  MFView.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFView.h"
#import "MFDefine.h"
#import "NSObject+DOM.h"
#import "MFHelper.h"
#import "MFResourceCenter.h"

@interface MFView () <UIGestureRecognizerDelegate>
@property (nonatomic,strong)UITapGestureRecognizer *singleTap;
@property (nonatomic,strong)UILongPressGestureRecognizer *longPressTap;
@property (nonatomic,strong)UISwipeGestureRecognizer *swipeTap;
@property (nonatomic,strong)UIImageView *backgroundImageView;

@end

@implementation MFView
- (void)dealloc
{
    [self releaseTapGestureRecognizer];
}

- (void)setTouchEnabled:(BOOL)touchEnabled
{
    _touchEnabled = touchEnabled;
    if (touchEnabled) {
        [self setupTapGestureRecognizer];
        [self setupLongPressGestureRecognizer];
        [self setupSwipeGestureRecognizer];
    }else {
        [self releaseTapGestureRecognizer];
        [self releaseLongPressGestureRecognizer];
        [self releaseSwipeGestureRecognizer];
    }
}

#pragma mark --
#pragma mark TapGestureRecognizer
- (void)setupTapGestureRecognizer
{
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    self.singleTap.numberOfTouchesRequired = 1;
    self.singleTap.numberOfTapsRequired = 1;
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
    self.longPressTap.numberOfTouchesRequired = 1;
    self.longPressTap.numberOfTapsRequired = 1;
    self.longPressTap.delegate = self;
    [self addGestureRecognizer:self.longPressTap];
}

- (void)releaseLongPressGestureRecognizer
{
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = NO;
    self.longPressTap = nil;
}

- (void)setupSwipeGestureRecognizer
{
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;
    self.swipeTap = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeEvent:)];
    self.swipeTap.numberOfTouchesRequired = 1;
    self.swipeTap.delegate = self;
    [self addGestureRecognizer:self.swipeTap];
}

- (void)releaseSwipeGestureRecognizer
{
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = NO;
    self.swipeTap = nil;
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

- (void)handleSwipeEvent:(UITapGestureRecognizer *)sender
{
    id result = [self.DOM triggerEvent:kMFOnSwipeEventKey withParams:@{}];
    NSLog(@"%@",result);
}

- (void)specialHandling
{
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
    
    UIImage *image= nil;
    NSArray *styleArray = [style componentsSeparatedByString:@","];
    if ([styleArray count]>=2) {
        switch (self.alignmentType) {
            case MFAlignmentTypeLeft:
                image = [self styleLeftImageWithId:[styleArray objectAtIndex:0]];
                break;
            case MFAlignmentTypeCenter:
                image = [self styleCenterImageWithId:[styleArray objectAtIndex:0]];
                break;
            case MFAlignmentTypeRight:
                image = [self styleRightImageWithId:[styleArray objectAtIndex:1]];
                break;
            default:
                break;
        }
    } else {
        image = [self styleLeftImageWithId:[styleArray objectAtIndex:0]];
    }
    
    if (nil == _backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        _backgroundImageView.opaque = 0;
        _backgroundImageView.alpha = 1;
        [self addSubview:_backgroundImageView];
    }
    _backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _backgroundImageView.image = image;
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    self.style = _style;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _backgroundImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}
@end
