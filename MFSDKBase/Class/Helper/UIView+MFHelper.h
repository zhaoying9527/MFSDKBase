//
//  UIView+MFHelper.h
//  MFSDK
//
//  Created by 李春荣 on 15/3/23.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

static void * MF_UUIDPorpertyKey = (void *)@"UUIDPorpertyKey";
@interface UIView (MFHelper)
- (id)MFUUID;
- (void)setMFUUID:(NSString *)UUID;

- (UIViewController*)MFViewController;
- (UITableViewCell*)MFViewCell;
@end
