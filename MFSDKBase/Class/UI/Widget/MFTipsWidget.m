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
    [super setFrame:frame];
    
    CGRect rect = self.bounds;
    rect.size.width = self.bounds.size.width - 2.0*tipsspace;
    rect.size.height = self.bounds.size.height - 1.5*tipsspace;
    rect.origin.x = tipsspace;
    rect.origin.y = (self.bounds.size.height - rect.size.height)/2;
    self.titleLabel.frame = rect;
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
@end
