//
//  MFPlugInFactory.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/5.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFPlugIn.h"
#import "MFDefine.h"
@interface MFCorePlugInFactory : NSObject
+ (MFPlugIn*)createPlugIn:(MFPlugInType)plugInType;
@end
