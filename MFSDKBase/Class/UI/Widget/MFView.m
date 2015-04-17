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

@interface MFView ()
@property (nonatomic, strong)NSTimer *longPressTimer;
@property (nonatomic,strong)UIImageView *backgroundImageView;
@end

@implementation MFView
- (instancetype)init{
    if (self = [super init]) {
        self.side = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)dealloc
{
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
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
        [self handleSingleFingerEvent];
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

- (void)handleSingleFingerEvent
{
    if (self.DOM.eventNodes[kMFOnClickEvent]) {
        id result = [self.DOM triggerEvent:kMFOnClickEvent withParams:@{}];
        NSLog(@"%@",result);
    }else {
        NSDictionary *params = @{kMFDispatcherEventType:kMFOnClickEvent, kMFIndexPath:((MFCell*)self.viewCell).indexPath};
        if ([self.viewController respondsToSelector:@selector(dispatchWithTarget:params:)]) {
            [(id)self.viewController dispatchWithTarget:self params:params];
        }
    }
}

- (void)handleLongPressEvent
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

- (void)setBackgroundImage:(NSString*)backgroundImage
{
    _backgroundImage = backgroundImage;

    UIImage *image= nil;

    if ([backgroundImage hasPrefix:@"url(MFLayout://"]) {
        NSRange startRange = [backgroundImage rangeOfString:@"url(MFLayout://"];
        NSRange endRange = [backgroundImage rangeOfString:@")"];
        NSString *subUrlString = [backgroundImage substringWithRange:NSMakeRange(startRange.length, MAX(0,endRange.location-startRange.length))];
        
        NSString *leftImageUrl = nil; NSString *centerImageUrl = nil; NSString *rightImageUrl = nil;
        NSArray *imageUrls = [subUrlString componentsSeparatedByString:@"#"];
        for (NSString * imageUrl in imageUrls) {
            if ([imageUrl hasPrefix:@"left:"]) {
                leftImageUrl = [imageUrl substringWithRange:NSMakeRange(5, imageUrl.length-5)];
            }
            if ([imageUrl hasPrefix:@"center:"]) {
                centerImageUrl = [imageUrl substringWithRange:NSMakeRange(7, imageUrl.length-7)];
            }
            if ([imageUrl hasPrefix:@"right:"]) {
                rightImageUrl = [imageUrl substringWithRange:NSMakeRange(6, imageUrl.length-6)];
            }
        }

        if (MFAlignmentTypeLeft == _alignmentType) {
            image = [MFHelper styleLeftImageWithId:leftImageUrl];
        }
        else if (MFAlignmentTypeCenter == _alignmentType) {
            image = [MFHelper styleCenterImageWithId:centerImageUrl];
        }
        else if (MFAlignmentTypeRight == _alignmentType) {
            image = [MFHelper styleRightImageWithId:rightImageUrl];
        }
    }
    else if ([backgroundImage hasPrefix:@"http://"]) {
        //TODO setImage with URL;
    }
    else {
        image = [MFHelper styleLeftImageWithId:backgroundImage];
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

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _backgroundImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    self.side = (_alignmentType != MFAlignmentTypeNone && self.side) ? YES : NO;
}

- (void)alignHandling
{
    self.backgroundImage = _backgroundImage;
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
