//
//  NSObject+VirtualNode.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFVirtualNode.h"
static void * MFVirtualNodeKey = (void *)@"MFVirtualNodeKey";

@interface NSObject (VirtualNode)

- (void)attachVirtualNode:(MFVirtualNode*)node;
- (MFVirtualNode*)virtualNode;
- (void)detachVirtualNode;
@end
