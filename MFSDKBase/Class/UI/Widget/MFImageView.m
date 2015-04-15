//
//  MFImageView.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFImageView.h"
#import "MFHelper.h"
#import "MFResourceCenter.h"
#import "NSObject+DOM.h"

@interface MFImageView()<UIGestureRecognizerDelegate>
@property (nonatomic,strong)UITapGestureRecognizer *singleTap;
@property (nonatomic,strong)UILongPressGestureRecognizer *longPressTap;
@property (nonatomic,strong)UIImageView *maskImageView;
@end

@implementation MFImageView
- (void)dealloc
{
    [self releaseTapGestureRecognizer];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = YES;
        self.corner = NO;
        self.aspectFit = NO;
        self.side = NO;
        self.alignmentType = MFAlignmentTypeLeft;
    }
    
    return self;
}

- (void)setTouchEnabled:(BOOL)touchEnabled
{
    _touchEnabled = touchEnabled;
    if (touchEnabled) {
        [self setupTapGestureRecognizer];
        [self setupLongPressGestureRecognizer];
    }else {
        [self releaseTapGestureRecognizer];
        [self releaseLongPressGestureRecognizer];
    }
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
#pragma mark --
#pragma mark TapGestureRecognizer
- (void)setupTapGestureRecognizer
{
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    self.singleTap.numberOfTouchesRequired = 1; //手指数
    self.singleTap.numberOfTapsRequired = 1; //tap次数
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
    self.longPressTap.numberOfTouchesRequired = 1; //手指数
    self.longPressTap.numberOfTapsRequired = 1; //tap次数
    self.longPressTap.delegate = self;
    [self addGestureRecognizer:self.longPressTap];
}

- (void)releaseLongPressGestureRecognizer
{
    self.multipleTouchEnabled = NO;
    self.userInteractionEnabled = NO;
    self.longPressTap = nil;
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
    
    self.side = (_alignmentType == MFAlignmentTypeNone) ? NO : YES;
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
