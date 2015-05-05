//
//  MFBadgeButton.m
//  ZYQAssetPickerControllerDemo
//
//  Created by 赵嬴 on 15/4/23.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFBadgeButton.h"
#import "MFPhoto.h"
@interface MFBadgeButton ()
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* selectView;
@property (nonatomic, strong) UIImage* uncheckedIcon;
@property (nonatomic, strong) UIImage* checkedIcon;
@end

@implementation MFBadgeButton
+ (CGSize)badgeSize
{
    return CGSizeMake(24, 24);
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    if (nil == self.selectView) {
        
        self.uncheckedIcon = MFSDKImage(@"basePhotoPicker/badge_unselected.png");
        self.checkedIcon = MFSDKImage(@"basePhotoPicker/badge_selected.png");

        self.selectView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.checkedIcon.size.width) / 2,
                                                                 (self.frame.size.height - self.checkedIcon.size.height) / 2,
                                                                 self.checkedIcon.size.width,
                                                                 self.checkedIcon.size.height)];
        self.selectView.opaque = YES;
        self.selectView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.selectView];

        self.titleLabel = [[UILabel alloc] initWithFrame:self.selectView.bounds];
        [self.titleLabel setOpaque:YES];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        [self.selectView bringSubviewToFront:self.titleLabel];
        [self.selectView addSubview:self.titleLabel];
    }
}

- (void)setBadgeNumber:(NSInteger)badgeNumber
{
    _badgeNumber = badgeNumber;
    [self drawView];
}

- (void)drawView
{
    BOOL animated = YES;
    if (self.badgeNumber <= 0) {
        self.selectView.image = nil;
        self.titleLabel.text = nil;
    }
    else {
        self.selectView.image = self.checkedIcon;
        self.titleLabel.text = [NSString stringWithFormat:@"%d", (int)self.badgeNumber];
    }

    if (animated) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.15
                delay:0.0
                options:UIViewAnimationOptionCurveEaseIn
                animations:^{
                    self.selectView.transform = CGAffineTransformMakeScale(0.6, 0.6);
                }
                completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.35
                        delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            self.selectView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        }
                        completion:^(BOOL finished){
                        }];

                }];
        });
    }
}
@end
