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
- (id)executeScript:(NSDictionary*)scriptNode scriptType:(NSInteger)scriptType
{
    //lua
    if (MFSDK_SCRIPT_LUA == scriptType) {
        MFLuaScript *plugin = (MFLuaScript *)[[[MFCorePlugInService alloc] init] findPlugInWithType:MFSDK_PLUGIN_LUA];
        id result = [plugin executeScript:scriptNode];
        NSLog(@"Lua result:%@", result);
        return result;
    }
    return nil;

    
    //js
}
@end
