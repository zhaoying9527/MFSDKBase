//
//  MFTipsWidget.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFTipsWidget.h"
#import "MFResourceCenter.h"
#import "NSObject+DOM.h"
#import "MFHelper.h"
#import "MFDefine.h"

@interface MFTipsWidget() <UIGestureRecognizerDelegate>
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILongPressGestureRecognizer *longPressTap;
@end

@implementation MFTipsWidget

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    self.exclusiveTouch = YES;
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:cellHeaderFontSize];
    self.titleLabel.opaque = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];

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
    if (self.DOM.eventNodes[kMFOnKeyLongPressEventKey]) {
        id result = [self.DOM triggerEvent:kMFOnKeyLongPressEventKey withParams:@{}];
        NSLog(@"%@",result);
    }else {
        NSDictionary *params = @{kMFDispatcherEventTypeKey:kMFOnKeyLongPressEventKey};
        [[NSNotificationCenter defaultCenter] postNotificationName:kMFDispatcherKey object:self userInfo:params];
    }
}

- (UIImage*)BGImage
{
    UIImage *image = [[MFResourceCenter sharedMFResourceCenter] cacheImageWithId:@"APTimeBackground.png"];
    if (nil == image) {
        image = [MFHelper stretchableCellImage:[UIImage imageNamed:@"MFSDK.bundle/APTimeBackground.png"]];
    }
    return image;
}

- (void)setFrame:(CGRect)frame
{
    CGRect retFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    retFrame.origin.x = (kDeviceWidth - retFrame.size.width)/2;
    [super setFrame:retFrame];

    self.titleLabel.frame = (retFrame.size.width <= 0 || retFrame.size.height <= 0) ? retFrame :
    CGRectMake(1.5*tipsWidthSpace, tipsHeightSpace, retFrame.size.width - 3.0*tipsWidthSpace, retFrame.size.height - 2*tipsHeightSpace);
}

- (void)setText:(NSString *)text
{
    self.titleLabel.text = text;
    if (nil != text && [text length] > 0) {
        self.image = [self BGImage];
    }else {
        self.image = nil;
    }
}

- (NSString*)text
{
    return self.titleLabel.text;
}

- (void)setBackgroundColor:(UIColor*)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.titleLabel.backgroundColor = backgroundColor;
}

- (void)setTextColor:(UIColor*)textColor
{
    self.titleLabel.textColor = textColor;
}

- (void)setFont:(UIFont*)font
{
    self.titleLabel.font = font;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
    self.titleLabel.numberOfLines = numberOfLines;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    self.titleLabel.textAlignment = textAlignment;
}
@end
