//
//  MFCheckbox.m
//  ZYQAssetPickerControllerDemo
//
//  Created by 赵嬴 on 15/4/23.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFRadiobox.h"
@interface MFRadiobox ()
@property (nonatomic, strong) UIImageView* selectView;
@property (nonatomic, strong) UIImage* uncheckedIcon;
@property (nonatomic, strong) UIImage* checkedIcon;
@property (nonatomic, strong) UILabel* label;
@property (nonatomic, assign) CGSize labelSize;
@end

@implementation MFRadiobox
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.checked = NO;
    }

    return self;
}

- (void)setupUI
{
    self.uncheckedIcon = MFSDKImage(@"basePhotoPicker/radiobox_unselected.png");
    self.checkedIcon = MFSDKImage(@"basePhotoPicker/radiobox_selected.png");

    self.selectView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - self.checkedIcon.size.width) / 2,
                                                             1 + (self.frame.size.height - self.checkedIcon.size.height) / 2,
                                                             self.checkedIcon.size.width - 2,
                                                             self.checkedIcon.size.height - 2)];
    self.selectView.opaque = YES;
    self.selectView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.selectView];

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(28, 0, 10, self.frame.size.height)];
    self.label.font = [UIFont systemFontOfSize:13];
    self.label.numberOfLines = 1;
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
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
        [self setChecked:YES animated:NO];
    }
    else {
        [self setChecked:NO animated:NO];
    }

    if (_delegate != nil && [_delegate respondsToSelector:@selector(onRadioState:)]) {
        [_delegate onRadioState:self];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    self.label.frame = CGRectMake([self radioBoxSize].width - self.labelSize.width, 0,
        self.labelSize.width,
        self.frame.size.height);
    self.selectView.frame = CGRectMake(0,
        1 + (self.frame.size.height - self.checkedIcon.size.height) / 2,
        self.checkedIcon.size.width - 2,
        self.checkedIcon.size.height - 2);
}
- (void)setText:(NSString*)text
{
    _text = text;
    self.label.text = text;
    self.labelSize = [self.label.text sizeWithFont:self.label.font];
}

- (CGSize)radioBoxSize
{
    return CGSizeMake(26 + self.labelSize.width, self.frame.size.height);
}

- (CGRect)radioBoxRect
{
    return CGRectMake(self.frame.origin.x, self.frame.origin.y, [self radioBoxSize].width, [self radioBoxSize].height);
}
@end
