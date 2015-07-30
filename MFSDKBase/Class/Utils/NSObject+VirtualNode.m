//
//  NSObject+VirtualNode.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "NSObject+VirtualNode.h"
#import <objc/runtime.h>
@implementation NSObject (VirtualNode)

- (void)attachVirtualNode:(MFVirtualNode*)node
{
    NSMutableDictionary *actionDict = objc_getAssociatedObject(self, MFVirtualNodeKey);
    if (!actionDict) {
        actionDict = [NSMutableDictionary dictionary];
        [actionDict setValue:node forKey:CFBridgingRelease(MFVirtualNodeKey)];
        objc_setAssociatedObject(self, MFVirtualNodeKey, actionDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (MFVirtualNode*)virtualNode
{
    NSDictionary *dict = objc_getAssociatedObject(self, MFVirtualNodeKey);
    return dict[CFBridgingRelease(MFVirtualNodeKey)];
}

- (void)detachVirtualNode
{;}
@end
