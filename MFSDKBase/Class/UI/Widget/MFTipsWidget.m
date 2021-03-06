//
//  MFTipsWidget.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFTipsWidget.h"
#import "MFResourceCenter.h"
#import "NSObject+VirtualNode.h"
#import "MFHelper.h"
#import "MFDefine.h"

@interface MFTipsWidget() <UIGestureRecognizerDelegate>
@property (nonatomic,strong)UILabel *titleLabel;
@end

@implementation MFTipsWidget

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:frame];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:MFCellHeaderFontSize];
    self.titleLabel.opaque = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    return self;
}

- (UIImage*)BGImage
{
    UIImage *image = [[MFResourceCenter sharedMFResourceCenter] cacheImageWithId:@"APTimeBackground.png"];
    if (nil == image) {
        image = [MFHelper stretchableCellImage:[MFResourceCenter imageNamed:@"APTimeBackground.png"]];
    }
    return image;
}

- (void)setFrame:(CGRect)frame
{
    CGRect retFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    retFrame.origin.x = (kMFDeviceWidth - retFrame.size.width)/2;
    [super setFrame:retFrame];
    
    self.titleLabel.frame = (retFrame.size.width <= 0 || retFrame.size.height <= 0) ? retFrame :
    CGRectMake(1.5*MFTipsWidthSpace, MFTipsHeightSpace, retFrame.size.width - 3.0*MFTipsWidthSpace, retFrame.size.height - 2*MFTipsHeightSpace);
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
