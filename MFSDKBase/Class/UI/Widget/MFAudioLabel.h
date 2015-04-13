//
//  MFAudioLabel.h
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFView.h"

@interface MFAudioLabel : UIView
@property (nonatomic, assign)BOOL side;
@property (nonatomic, assign)NSInteger alignmentType;
@property (nonatomic, assign)BOOL reverse;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highlightedTextColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, copy) NSString * layout;
@property (nonatomic, assign) BOOL canStretch;

@property (nonatomic, assign) BOOL showBadge;
@property (nonatomic, copy) NSString *timeLine;
@property (nonatomic, copy) NSString *voiceUrl;
@property (nonatomic, strong) NSMutableDictionary * mediaState;
@property (nonatomic, copy) NSString * clientMsgID;
- (CGFloat)voiceFactor;
@end
