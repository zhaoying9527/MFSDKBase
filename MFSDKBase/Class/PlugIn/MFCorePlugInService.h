//
//  MFEventCenter.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 alipay. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MFPlugIn.h"
#import "MFDefine.h"
@interface MFCorePlugInService : NSObject
- (MFPlugIn*)findPlugInWithType:(MFPlugInType)plugInType;
@end
