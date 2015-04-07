//
//  UIView+Actions.h
//  MFSDKBase
//
//  Created by 李春荣 on 15/4/3.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFCell;
@class MFViewController;
static void * ActionsKey = (void *)@"ActionsKey";
@interface UIView (Actions)
- (void)setAction:(NSString *)actionName function:(NSString *)function;
- (void)invokeAction:(NSString *)actionName withParams:(NSDictionary *)params;

- (MFCell*)backingMFCell;
- (MFViewController*)backingMFViewController;
@end