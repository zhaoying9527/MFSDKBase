//
//  MFLabel.h
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFLabel : UILabel
@property (nonatomic, copy)NSString * format;
@property (nonatomic, copy)NSString * formatString;
@property (nonatomic, copy)NSString * formatSize;
@property (nonatomic, assign)BOOL touchEnabled;
@property (nonatomic, assign)BOOL side;
@property (nonatomic, assign)NSInteger alignmentType;
@property (nonatomic, assign)BOOL reverse;
@property (nonatomic, assign)CGFloat cornerRadius;
@property (nonatomic, assign)CGFloat borderWidth;
@property (nonatomic, strong)UIColor *borderColor;
- (void)specialHandling;
@end
