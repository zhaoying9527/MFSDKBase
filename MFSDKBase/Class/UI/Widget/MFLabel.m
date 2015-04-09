//
//  MFLabel.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFLabel.h"
#import "MFDefine.h"
#import "NSObject+DOM.h"

@interface MFLabel () <UIGestureRecognizerDelegate>
@property (nonatomic,strong)UILongPressGestureRecognizer *longPressTap;
@end

@implementation MFLabel
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    return self;
}

- (void)setTouchEnabled:(BOOL)touchEnabled
{
    _touchEnabled = touchEnabled;
    if (touchEnabled) {
        [self setupLongPressGestureRecognizer];
    }else {
        [self releaseLongPressGestureRecognizer];
    }
}

#pragma mark --
#pragma mark TapGestureRecognizer
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

- (void)handleLongPressEvent:(UITapGestureRecognizer *)sender
{
    id result = [self.DOM triggerEvent:kMFOnKeyLongPressEventKey withParams:@{}];
    NSLog(@"%@",result);
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    if (self.side) {
        if (_alignmentType == MFAlignmentTypeLeft) {
            self.textAlignment = NSTextAlignmentLeft;
        } else if (_alignmentType == MFAlignmentTypeCenter) {
            self.textAlignment = NSTextAlignmentCenter;
        } else if (_alignmentType == MFAlignmentTypeRight) {
            self.textAlignment = NSTextAlignmentRight;
        }
    }
}

- (void)specialHandling
{
    if (self.alignmentType == MFAlignmentTypeRight) {
        if (nil != self.highlightedTextColor) {
            self.textColor = self.highlightedTextColor;
        }
    } else {
        self.textColor = self.textColor;
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
