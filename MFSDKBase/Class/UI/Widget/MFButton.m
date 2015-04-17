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

@interface MFButton ()
@property (nonatomic, strong)NSTimer *longPressTimer;
@end

@implementation MFButton
- (void)dealloc
{
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
}

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
    if ((self.DOM.eventNodes[kMFOnClickEvent])) {
        [self.longPressTimer invalidate];
        self.longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kLongPressTimeInterval target:self selector:@selector(handleSinglePressEvent) userInfo:nil repeats:NO];
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

- (void)handleSinglePressEvent
{
    if (self.DOM.eventNodes[kMFOnKeyLongPressEvent]) {
        id result = [self.DOM triggerEvent:kMFOnKeyLongPressEvent withParams:@{}];
        NSLog(@"%@",result);
    }else {
        NSDictionary *params = @{kMFDispatcherEventType:kMFOnKeyLongPressEvent, kMFIndexPath:((MFCell*)self.viewCell).indexPath};
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
