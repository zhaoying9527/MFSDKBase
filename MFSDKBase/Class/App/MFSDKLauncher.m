//
//  MFLauncher.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFSDKLauncher.h"
#import "MFSceneCenter.h"
#import "MFDispatchCenter.h"
#import "MFWindowsStyleManager.h"
@implementation MFSDKLauncher
+ (void)initialize
{
    [[MFWindowsStyleManager sharedMFWindowsStyleManager] loadWStyleWithName:@"MFChat"];
    [MFSceneCenter sharedMFSceneCenter];
    [MFDispatchCenter sharedMFDispatchCenter];
}
@end
