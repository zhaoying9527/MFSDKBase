//
//  MFButton.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFButton.h"
#import "MFDefine.h"
#import "MFHelper.h"
#import "NSObject+DOM.h"

@implementation MFButton
- (id)init
{
    self = [super init];
    if (self) {
        self.side = YES;
        self.exclusiveTouch = YES;
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        [self setupTapTarget];
    }
    return self;
}

- (void)setupTapTarget
{
    [self addTarget:self action:@selector(handleSingleFingerEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    if (self.DOM.eventNodes[kMFOnClickEvent]) {
        id result = [self.DOM triggerEvent:kMFOnClickEvent withParams:@{}];
        NSLog(@"%@",result);
    }else {
        NSDictionary *params = @{kMFDispatcherEventType:kMFOnClickEvent};
        if ([self.viewController respondsToSelector:@selector(dispatchWithTarget:params:)]) {
            [(id)self.viewController dispatchWithTarget:self params:params];
        }
    }
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (void)setTextColor:(UIColor *)textColor
{
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)setText:(NSString *)text
{
    [self setTitle:text forState:UIControlStateNormal];
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    self.side = (_alignmentType != MFAlignmentTypeNone && self.side) ? YES : NO;
}

- (void)alignHandling
{
    if (MFAlignmentTypeRight == self.alignmentType) {
        if (nil != self.highlightedTextColor) {
            [self setTitleColor:self.highlightedTextColor forState:UIControlStateNormal];
        }
    }
}

- (void)reverseHandling
{
    CGRect rawRect = self.frame;
    UIView *superView = self.superview;
    
    CGRect rect = rawRect;
    rect.origin.x = superView.frame.size.width - rect.origin.x - rect.size.width;
    if (![MFHelper sameRect:rawRect withRect:rect]) {
        self.frame = rect;
    }
}

@end
