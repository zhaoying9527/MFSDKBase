//
//  UIView+Scene.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "NSObject+DOM.h"
#import <objc/runtime.h>
@implementation NSObject (DOM)
- (void)attachDOM:(MFDOM*)dom
{
    NSMutableDictionary *actionDict = objc_getAssociatedObject(self, DomKey);
    if (!actionDict) {
        actionDict = [NSMutableDictionary dictionary];
        [actionDict setValue:dom forKey:CFBridgingRelease(DomKey)];
        objc_setAssociatedObject(self, DomKey, actionDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (MFDOM*)DOM
{
    NSDictionary *dict = objc_getAssociatedObject(self, DomKey);
    return dict[CFBridgingRelease(DomKey)];
}

- (void)detachDOM
{;}
@end
