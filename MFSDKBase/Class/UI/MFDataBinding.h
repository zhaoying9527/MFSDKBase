//
//  MFDataBinding.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/9.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MFDataBinding : NSObject
+ (void)bind:(UIView*)view withDataSource:(NSDictionary*)dataSource;
@end
