//
//  MFLabel.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFLabel.h"
#import "MFDefine.h"
#import "MFHelper.h"
#import "NSObject+DOM.h"

@interface MFLabel ()
@property (nonatomic, strong)NSTimer *longPressTimer;
@property (nonatomic, assign)NSTextAlignment rawTextAlignmentType;
@end

@implementation MFLabel
- (void)dealloc
{
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.side = YES;
    self.exclusiveTouch = YES;
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
    if ((self.DOM.eventNodes[kMFOnClickEvent])) {
        [self.longPressTimer invalidate];
        self.longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kLongPressTimeInterval target:self selector:@selector(handleLongPressEvent) userInfo:nil repeats:NO];
    }else {
        [super touchesBegan:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((self.DOM.eventNodes[kMFOnClickEvent])) {
        [self.longPressTimer invalidate];
        self.longPressTimer = nil;
    }else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((self.DOM.eventNodes[kMFOnClickEvent])) {
        [self.longPressTimer invalidate];
        self.longPressTimer = nil;
    }else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((self.DOM.eventNodes[kMFOnClickEvent])) {
        [self.longPressTimer invalidate];
        self.longPressTimer = nil;
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)handleLongPressEvent
{
    if (self.DOM.eventNodes[kMFOnKeyLongPressEvent]) {
        id result = [self.DOM triggerEvent:kMFOnKeyLongPressEvent withParams:@{}];
        NSLog(@"%@",result);
    }
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
            self.textColor = self.highlightedTextColor;
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

    if (NSTextAlignmentLeft == self.rawTextAlignmentType) {
        self.textAlignment = NSTextAlignmentRight;
    }
    else if(NSTextAlignmentRight == self.rawTextAlignmentType) {
        self.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    if (MFAlignmentTypeLeft == self.alignmentType || MFAlignmentTypeNone == self.alignmentType) {
        self.rawTextAlignmentType = textAlignment;
    }
    [super setTextAlignment:textAlignment];
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
