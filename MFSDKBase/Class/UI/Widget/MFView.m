//
//  MFView.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFView.h"
#import "MFDefine.h"
#import "NSObject+VirtualNode.h"
#import "MFHelper.h"
#import "MFScript.h"
#import "MFResourceCenter.h"
//TODO
//#import <APWebImage/SDWebImage.h>

@interface MFView ()
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
    if (self.virtualNode.dom.eventNodes[kMFOnClickEvent] || self.virtualNode.dom.eventNodes[kMFOnDbClickEvent]
        || self.virtualNode.dom.eventNodes[kMFOnLongPressEvent]) {
        if ((self.virtualNode.dom.eventNodes[kMFOnLongPressEvent])) {
            [self performSelector:@selector(handleLongPressEvent) withObject:nil afterDelay:kMFLongPressTimeInterval];
        }
    }else {
        [super touchesBegan:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.virtualNode.dom.eventNodes[kMFOnClickEvent] || self.virtualNode.dom.eventNodes[kMFOnDbClickEvent]
        || self.virtualNode.dom.eventNodes[kMFOnLongPressEvent]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }else {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.virtualNode.dom.eventNodes[kMFOnClickEvent] || self.virtualNode.dom.eventNodes[kMFOnDbClickEvent]
        || self.virtualNode.dom.eventNodes[kMFOnLongPressEvent]) {
        UITouch *touch = [touches anyObject];
        NSUInteger taps = [touch tapCount];
        if(taps == 1 && self.virtualNode.dom.eventNodes[kMFOnClickEvent]) {
            [self performSelector:@selector(handleSingleFingerEvent) withObject:nil afterDelay:kMFDoubleClickTimeInterval];
        }else if(taps == 2 && self.virtualNode.dom.eventNodes[kMFOnClickEvent]) {
            [self handleDoubleClickEvent];
        }
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleLongPressEvent) object:nil];
    }else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.virtualNode.dom.eventNodes[kMFOnClickEvent] || self.virtualNode.dom.eventNodes[kMFOnDbClickEvent]
        || self.virtualNode.dom.eventNodes[kMFOnLongPressEvent]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }else {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)handleSingleFingerEvent
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    id result = [self.virtualNode triggerEvent:kMFOnClickEvent withParams:@{kMFParamsKey:@{kMFTargetKey:self}}];
    NSLog(@"%@",result);
}

- (void)handleDoubleClickEvent
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    id result = [self.virtualNode triggerEvent:kMFOnDbClickEvent withParams:@{kMFParamsKey:@{kMFTargetKey:self}}];
    NSLog(@"%@",result);
}

- (void)handleLongPressEvent
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    id result = [self.virtualNode triggerEvent:kMFOnLongPressEvent withParams:@{kMFParamsKey:@{kMFTargetKey:self}}];
    NSLog(@"%@",result);
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
//TODO
//        UIImage *bannerImage = [[MFResourceCenter sharedMFResourceCenter] bannerImage];
//        [_backgroundImageView setImageWithURL:[NSURL URLWithString:backgroundImage]
//                             placeholderImage:bannerImage
//                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                    }];
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
