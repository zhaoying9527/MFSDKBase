//
//  UIView+ event.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/7.
//  Copyright (c) 2015年 alipay. All rights reserved.
//
#import <UIKit/UIKit.h>

static void * EventKey = (void *)@"EventKey";

@interface UIView (Event)
- (void)attachEvent:(NSString*)eventName handlerName:(NSString*)handlerName;
- (void)removeEvent:(NSString*)eventName;
- (void)invokeHandler:(NSString *)eventName withParams:(NSDictionary *)params;
@end
