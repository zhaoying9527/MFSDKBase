//
//  MFTipsWidget.h
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFTipsWidget : UIImageView
@property (nonatomic, strong)NSString *text;
@property (nonatomic, assign)NSInteger align;
@property (nonatomic, assign)NSInteger alignmentType;
@property (nonatomic, assign)BOOL reverse;
@end
