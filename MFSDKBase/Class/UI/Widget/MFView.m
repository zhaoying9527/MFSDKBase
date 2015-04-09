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

@interface MFView () <UIGestureRecognizerDelegate>
@property (nonatomic,strong)UITapGestureRecognizer *singleTap;
@property (nonatomic,strong)UILongPressGestureRecognizer *longPressTap;
@property (nonatomic,strong)UISwipeGestureRecognizer *swipeTap;
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
@end
