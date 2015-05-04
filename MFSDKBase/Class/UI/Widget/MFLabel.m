//
//  MFLabel.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFLabel.h"
#import "MFDefine.h"
#import "MFHelper.h"
#import "MFScript.h"
#import "NSObject+DOM.h"

@interface MFLabel ()
@property (nonatomic, assign)NSTextAlignment rawTextAlignmentType;
@end

@implementation MFLabel
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.side = YES;
    self.exclusiveTouch = YES;
    return self;
}

- (void)setTouchEnabled:(BOOL)touchEnabled
{
    _touchEnabled = touchEnabled;
    self.userInteractionEnabled = touchEnabled;
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    self.side = (_alignmentType != MFAlignmentTypeNone && self.side) ? YES : NO;
}

- (void)alignHandling
{
    if (MFAlignmentTypeRight == self.alignmentType) {
        if (nil != self.highlightedTextColor) {
            self.textColor = self.highlightedTextColor;
        }
    }
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
    
    if (NSTextAlignmentLeft == self.rawTextAlignmentType) {
        self.textAlignment = NSTextAlignmentRight;
    }
    else if(NSTextAlignmentRight == self.rawTextAlignmentType) {
        self.textAlignment = NSTextAlignmentLeft;
    }
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    if (MFAlignmentTypeLeft == self.alignmentType || MFAlignmentTypeNone == self.alignmentType) {
        self.rawTextAlignmentType = textAlignment;
    }
    [super setTextAlignment:textAlignment];
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
@end
