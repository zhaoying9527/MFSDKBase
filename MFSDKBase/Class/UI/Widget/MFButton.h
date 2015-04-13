//
//  MFButton.h
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFButton : UIButton
@property (nonatomic, assign) BOOL side;
@property (nonatomic, assign)NSInteger alignmentType;
@property (nonatomic, assign)BOOL reverse;
@property (nonatomic, strong)NSString *text;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)UIImage *backgroundImage;
@property (nonatomic, strong)UIColor *textColor;
@end
