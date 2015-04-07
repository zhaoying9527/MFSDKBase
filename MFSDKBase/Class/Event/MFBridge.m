//  MFBridge.m
//  MFSDKBase
//
//  Created by 李春荣 on 15/3/24.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFBridge.h"
#import "MFLuaScript.h"
#import "MFCorePlugInService.h"

@implementation MFBridge
- (void)executeScript:(NSDictionary*)scriptNode scriptType:(NSInteger)scriptType
{
    //lua
    if (scriptType == 1) {
        MFLuaScript *plugin = (MFLuaScript *)[[[MFCorePlugInService alloc] init] findPlugInWithType:MFSDK_PLUGIN_LUA];
        NSDictionary *result = [plugin executeScript:scriptNode];
        NSLog(@"Lua result:%@", result);
    }

    //js
}
@end
