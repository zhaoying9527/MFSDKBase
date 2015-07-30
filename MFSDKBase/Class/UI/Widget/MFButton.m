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
#import "MFScript.h"
#import "NSObject+VirtualNode.h"

@implementation MFButton
- (id)init
{
    self = [super init];
    if (self) {
        self.side = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)setTouchEnabled:(BOOL)touchEnabled
{
    _touchEnabled = touchEnabled;
    self.userInteractionEnabled = touchEnabled;
}

#pragma mark --
#pragma mark touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((self.virtualNode.dom.eventNodes[kMFOnClickEvent])) {
        UITouch *touch = [touches anyObject];
        NSUInteger taps = [touch tapCount];
        if (taps == 1) {
            [super touchesCancelled:touches withEvent:event];
            [self handleSingleFingerEvent];
            return;
        }
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)handleSingleFingerEvent
{
    id result = [self.virtualNode triggerEvent:kMFOnClickEvent withParams:@{kMFParamsKey:@{@"target":self}}];
    NSLog(@"%@",result);
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

- (void)setFont:(UIFont *)font
{
    [self.titleLabel setFont:font];
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
