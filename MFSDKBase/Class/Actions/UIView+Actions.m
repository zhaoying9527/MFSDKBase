//
//  UIView+Actions.m
//  MFSDKBase
//
//  Created by 李春荣 on 15/4/3.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+Actions.h"
#import "MFCell.h"
#import "MFViewController.h"
#import "MFBridge.h"
#import "MFDispatchCenter.h"


@implementation UIView (Actions)
- (void)setAction:(NSString *)actionName function:(NSString *)function
{
    NSMutableDictionary *actionDict = objc_getAssociatedObject(self, ActionsKey);
    if (!actionDict) {
        actionDict = [NSMutableDictionary dictionary];
    }
    [actionDict setValue:function forKey:actionName];
    objc_setAssociatedObject(self, ActionsKey, actionDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString*)getFunctionNameWithAction:(NSString *)actionName
{
    NSString *functionName = nil;
    NSMutableDictionary *actionDict = objc_getAssociatedObject(self, ActionsKey);
    if (actionDict) {
        NSString *fullName = [actionDict valueForKey:actionName];
        NSRange range = [fullName rangeOfString:@"("];
        functionName = [fullName substringToIndex:range.location];
    }
    return functionName;
}

- (void)invokeAction:(NSString *)actionName withParams:(NSDictionary *)params
{
    NSString *functionName = [self getFunctionNameWithAction:actionName];
    if (functionName)
    {
        [[MFActionManager sharedMFActionManager] executeScript:@{@"method":functionName, @"params":@"dict"} scriptType:1];
//        [[MFBridge sharedMFBridge] executeScriptWithMethod:functionName params:params];
    }
}

- (MFCell*)backingMFCell
{
    UIView *parentView = (UIView *)self.superview;
    while (parentView) {
        if ([parentView isKindOfClass:[MFCell class]]) {
            return (MFCell *)parentView;
        }
        parentView = parentView.superview;
    }
    return nil;
}

- (MFViewController*)backingMFViewController
{
    UIView *parentView = (UIView *)self.superview;
    while (parentView) {
        if ([parentView isKindOfClass:[MFViewController class]]) {
            return (MFViewController *)parentView;
        }
        parentView = parentView.superview;
    }
    return nil;
}
@end
