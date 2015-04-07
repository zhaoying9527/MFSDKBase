//
//  MFDataBinding.h
//
//  Created by 李春荣 on 15/3/23.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MFDataBinding : NSObject
+ (void)bindingWidget:(UIView *)widget withDataSource:(NSDictionary *)data dataBinding:(NSDictionary *)dataBinding;
@end
