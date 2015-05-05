//
//  CTLableDefine.h
//  CTLable
//
//  Created by chicp on 15-3-27.
//  Copyright (c) 2015年 长炮 池. All rights reserved.
//

#ifndef CTLable_CTLableDefine_h
#define CTLable_CTLableDefine_h

#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

typedef enum{
    CTImageAlignmentTop,
    CTImageAlignmentCenter,
    CTImageAlignmentBottom
} CTImageAlignment;

@class CTLabel;

@protocol CTAttributedLabelDelegate <NSObject>

- (void)ctAttributedLabel:(CTLabel *)label
            clickedOnLink:(id)linkData;

@end

typedef NSArray *(^CTCustomDetectLinkBlock)(NSString *text);

//检测复杂度超过长度超过限制后走异步判断个字的时候
#define CTMinAsyncDetectLinkLength 5

#define CTIOS7 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)

#endif
