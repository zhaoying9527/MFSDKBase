//
//  UIView+ event.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/7.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "UIView+Events.h"
#import <objc/runtime.h>
#import "MFSDK.h"
#import "MFDispatchCenter.h"

@implementation UIView (Event)
- (void)attachEvent:(NSString*)eventName handlerName:(NSString*)handlerName
{
    NSMutableDictionary *actionDict = objc_getAssociatedObject(self, EventKey);
    if (!actionDict) {
        actionDict = [NSMutableDictionary dictionary];
    }
    [actionDict setValue:handlerName forKey:eventName];
    objc_setAssociatedObject(self, EventKey, actionDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)removeEvent:(NSString*)eventName
{
    //???????
}

- (NSString*)getHandlerStringWithEventName:(NSString *)eventName
{
    NSString *functionName = nil;
    NSMutableDictionary *actionDict = objc_getAssociatedObject(self, EventKey);
    if (actionDict) {
        NSString *fullName = [actionDict valueForKey:eventName];
        NSRange range = [fullName rangeOfString:@"("];
        functionName = [fullName substringToIndex:range.location];
    }
    return functionName;
}

- (void)invokeHandler:(NSString *)eventName withParams:(NSDictionary *)params
{
    NSString *functionName = [self getHandlerStringWithEventName:eventName];
    if (functionName) {
        [[MFDispatchCenter sharedMFDispatchCenter] executeScript:params scriptType:MFSDK_SCRIPT_LUA];
    }
}

@end

