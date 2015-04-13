//
//  MFTipsWidget.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFTipsWidget.h"
#import "MFResourceCenter.h"
#import "MFHelper.h"
#import "MFDefine.h"

@interface MFTipsWidget()
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
    self.titleLabel.font = [UIFont systemFontOfSize:cellHeaderFontSize];
    self.titleLabel.opaque = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    return self;
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
    if (MFAlignmentTypeLeft == self.alignmentType) {
        retFrame = retFrame;
    } else if (MFAlignmentTypeCenter == self.alignmentType) {
        retFrame.origin.x = (kDeviceWidth - retFrame.size.width)/2;
    } else if (MFAlignmentTypeRight == self.alignmentType) {
        retFrame.origin.x = (self.superview.frame.size.width - retFrame.size.width - retFrame.origin.x);
    }
    [super setFrame:retFrame];

    self.titleLabel.frame = (retFrame.size.width <= 0 || retFrame.size.height <= 0) ? retFrame :
    CGRectMake(1.5*tipsLeftSpace, tipsTopSpace, retFrame.size.width - 3.0*tipsLeftSpace, retFrame.size.height - 2*tipsTopSpace);
    
    NSLog(@"");
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

- (void)setAlign:(NSInteger)align
{
    _align = align;
    self.alignmentType = _align;
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
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
