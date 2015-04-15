//
//  MFRichLabel.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFRichLabel.h"
#import "MFDefine.h"
#import "MFHelper.h"
#import "NSObject+DOM.h"

#define LABELTEXTCOLOR [MFHelper colorWithHexString:@"0x00aaff"]

@interface MFRichLabel () <UIGestureRecognizerDelegate>
@property (nonatomic, assign)NSTextAlignment rawTextAlignmentType;
@property (nonatomic,strong)UILongPressGestureRecognizer *longPressTap;
@end

@implementation MFRichLabel
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
    id result = [self.DOM triggerEvent:kMFOnKeyLongPressEventKey withParams:@{}];
    NSLog(@"%@",result);
}

- (void)setFormatString:(NSString *)formatString
{
//    _formatString = formatString;
//    
//    if (nil == formatString) {
//        self.text = nil;
//        return;
//    }
//    if ([formatString isKindOfClass:[NSNumber class]]) {
//        formatString = [NSString stringWithFormat:@"%.2f",[formatString floatValue]];
//    }
//    if ([formatString isKindOfClass:[NSString class]]) {
//        _formatString = formatString;
//        if ([self.format isEqualToString:@"money"]) {
//            __weak __typeof(self)weakSelf = self;
//            NSString *outString = [NSString stringWithFormat:@"¥ %@",_formatString];
//            CGFloat size = weakSelf.font.pointSize;
//            int fontSize = size-size/4;
//            [self setText:outString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//                NSRange moneyRange = [[mutableAttributedString string] rangeOfString:@"¥ " options:NSCaseInsensitiveSearch];
//                CTFontRef font  = CTFontCreateWithName((__bridge CFStringRef)weakSelf.font.fontName, fontSize, NULL);
//                [mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)font range:moneyRange];
//                
//                CTFontRef oriFont  = CTFontCreateWithName((__bridge CFStringRef)weakSelf.font.fontName, size, NULL);
//                NSRange textRange = NSMakeRange(2,outString.length-2);
//                [mutableAttributedString addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)oriFont range:textRange];
//                CFRelease(font);
//                CFRelease(oriFont);
//                return mutableAttributedString;
//            }];
//            _formatString = outString;
//            
//        }else if ([self.format isEqualToString:@"setting"]) {
//            NSString *outString = _formatString;//[NSString stringWithFormat:@"%@ 去设置",_formatString];
//            [self setText:outString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//                if (nil != mutableAttributedString) {
//                    NSRange textRange = NSMakeRange(outString.length - 3,3);
//                    [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[LABELTEXTCOLOR CGColor] range:textRange];
//                }
//                return mutableAttributedString;
//            }];
//            _formatString = outString;
//        }
//        else {
//            self.text = _formatString;
//        }
//    }
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    
    self.side = (_alignmentType == MFAlignmentTypeNone) ? NO : YES;
}

- (void)alignHandling
{
    if (MFAlignmentTypeRight == self.alignmentType) {
        if (nil != self.highlightedTextColor) {
            self.textColor = self.highlightedTextColor;
        }
    }
    self.formatString = self.rawString;
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
    if (MFAlignmentTypeLeft == self.alignmentType) {
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
