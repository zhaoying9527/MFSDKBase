//
//  UIView+UUID.h
//  MFSDK
//
//  Created by 李春荣 on 15/3/23.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

static void * UUIDPorpertyKey = (void *)@"UUIDPorpertyKey";
@interface UIView (UUID)
- (id)UUID;
- (void)setUUID:(NSString *)UUID;
@end
