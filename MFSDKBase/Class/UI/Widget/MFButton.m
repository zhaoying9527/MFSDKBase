//
//  MFButton.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFButton.h"
#import "MFDefine.h"
#import "NSObject+DOM.h"

@implementation MFButton
- (id)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        [self setupTapTarget];
    }
    return self;
}

- (void)setupTapTarget
{
    [self addTarget:self action:@selector(handleSingleFingerEvent:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    id result = [self.DOM triggerEvent:kMFOnClickEventKey withParams:@{}];
    NSLog(@"%@",result);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}
@end
