//
//  MFImageView.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFImageView.h"
//TODO
//#import <APWebImage/SDWebImage.h>
#import "MFHelper.h"
#import "MFResourceCenter.h"
#import "NSObject+VirtualNode.h"
#import "MFScript.h"

@interface MFImageView()
@property (nonatomic,strong)UIImageView *maskImageView;
@end

@implementation MFImageView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.corner = NO;
        self.aspectFit = NO;
        self.side = YES;
        self.exclusiveTouch = YES;
        self.alignmentType = MFAlignmentTypeLeft;
    }
    
    return self;
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
    id result = [self.virtualNode triggerEvent:kMFOnClickEvent withParams:@{kMFParamsKey:@{kMFTargetKey:self}}];
    NSLog(@"%@",result);
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
        
        if (MFAlignmentTypeLeft == _alignmentType || MFAlignmentTypeNone == _alignmentType) {
            image = [MFHelper styleLeftImageWithId:leftImageUrl];
        }else if (MFAlignmentTypeCenter == _alignmentType) {
            image = [MFHelper styleCenterImageWithId:centerImageUrl];
        }else if (MFAlignmentTypeRight == _alignmentType) {
            image = [MFHelper styleRightImageWithId:rightImageUrl];
        }
    }else if ([backgroundImage hasPrefix:@"http://"]) {
//TODO
//        UIImage *bannerImage = [[MFResourceCenter sharedMFResourceCenter] bannerImage];
//        [self setImageWithURL:[NSURL URLWithString:backgroundImage]
//             placeholderImage:bannerImage
//                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                    }];
    }else {
        image = [MFHelper styleLeftImageWithId:backgroundImage];
    }
    
    self.image = image;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.maskImageView.hidden = !self.corner;
    self.maskImageView.frame = self.bounds;
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    self.side = (_alignmentType != MFAlignmentTypeNone && self.side) ? YES : NO;
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
