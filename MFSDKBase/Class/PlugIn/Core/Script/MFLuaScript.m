//
//  MFLuaCore.m
//  MFuickSDK
//
//  Created by 赵嬴 on 15/4/2.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFLuaScript.h"
#import <wax/wax.h>
#import <wax/wax_helpers.h>
#import <wax/wax_http.h>
#import <wax/wax_json.h>
#import <wax/wax_filesystem.h>
#import "MFCorePlugInService.h"

#define luaL_dostring(L, s) \
(luaL_loadstring(L, s) || lua_pcall(L, 0, LUA_MULTRET, 0))
LUALIB_API int (luaL_loadstring) (lua_State *L, const char *s);

@interface MFLuaScript ()
@property(nonatomic, strong) NSMutableDictionary *scriptFiles;
@property(nonatomic)lua_State* curState;
@end

@implementation MFLuaScript

- (void)reset
{
    wax_end();
}

- (instancetype)init
{
    if (self = [super init]) {
        static NSMutableDictionary *scriptFiles;
        if (!scriptFiles) scriptFiles = [NSMutableDictionary dictionary];
        wax_start(nil, luaopen_wax_http, luaopen_wax_json, luaopen_wax_filesystem, nil);
        self.curState = wax_currentLuaState();
    }
    return self;
}

- (NSDictionary*)executeScript:(NSDictionary *)scriptNode
{
    NSString *method = [scriptNode objectForKey:kMFMethodKey];
    NSDictionary *params = [scriptNode objectForKey:kMFParamsKey];
    NSString *fileName = [scriptNode objectForKey:kMFScriptFileNameKey];
    NSString *contents = [scriptNode objectForKey:kMFScriptFileContentKey];

    if (!self.scriptFiles[fileName]) {
        luaL_dostring(_curState, [contents UTF8String]);
    }

    lua_getglobal(_curState, [method UTF8String]);
    wax_fromInstance(_curState, params);

    if (0 != wax_pcall(_curState, 1, 1)) {
        const char *msg = lua_tostring(_curState, -1);
        NSString* value = [NSString stringWithUTF8String:msg];
        NSLog(@"%@", value);
    }

    const char * retStr =lua_tostring(_curState,-1);//返回的是lua返回的字符串
    if (retStr) {
        NSString * resultStr = [NSString stringWithUTF8String:retStr];
        lua_pop(_curState, 1);
        NSData* data = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (error != nil) return nil;
        return result;
    }
    lua_pop(_curState, 1);
    return nil;
}
@end
