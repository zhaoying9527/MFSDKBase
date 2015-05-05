//
//  MFCheckbox.m
//  ZYQAssetPickerControllerDemo
//
//  Created by 赵嬴 on 15/4/23.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFCheckbox.h"
@interface MFCheckbox ()
@property (nonatomic, strong) UIImageView* selectView;
@property (nonatomic, strong) UIImage* uncheckedIcon;
@property (nonatomic, strong) UIImage* checkedIcon;
@end

@implementation MFCheckbox
+ (CGSize)checkSize
{
    return CGSizeMake(24, 24);
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.opaque = YES;
        self.checked = NO;
    }

    return self;
}

- (void)setupUI
{
    self.uncheckedIcon = MFSDKImage(@"basePhotoPicker/unselected.png");
    self.checkedIcon = MFSDKImage(@"basePhotoPicker/selected.png");

    self.selectView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.checkedIcon.size.width) / 2,
                                                             (self.frame.size.height - self.checkedIcon.size.height) / 2,
                                                             self.checkedIcon.size.width,
                                                             self.checkedIcon.size.height)];
    self.selectView.opaque = YES;
    self.selectView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.selectView];
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    [self drawView:NO];
}

- (void)setChecked:(BOOL)checked animated:(BOOL)amiated
{
    self.checked = checked;
    [self drawView:amiated];
}

- (void)drawView:(BOOL)animated
{
    if (self.checked) {
        self.selectView.image = self.checkedIcon;
    }
    else {
        self.selectView.image = self.uncheckedIcon;
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
                    [UIView animateWithDuration:0.25
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

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    self.checked = !self.checked;
    if (self.checked) {
        [self setChecked:YES animated:YES];
    }
    else {
        [self setChecked:NO animated:NO];
    }

    if (_delegate != nil && [_delegate respondsToSelector:@selector(onCheckState:)]) {
        [_delegate onCheckState:self];
    }
}
@end
