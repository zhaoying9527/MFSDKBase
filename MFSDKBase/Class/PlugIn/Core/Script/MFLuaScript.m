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
#import "MFHelper.h"

#define luaL_dostring(L, s) \
(luaL_loadstring(L, s) || lua_pcall(L, 0, LUA_MULTRET, 0))
LUALIB_API int (luaL_loadstring) (lua_State *L, const char *s);

@interface MFLuaScript ()
@property(nonatomic, strong) NSMutableDictionary *scriptFiles;
@property(nonatomic, copy) NSString *luaText;
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
        if (!self.scriptFiles) self.scriptFiles = [NSMutableDictionary dictionary];
        wax_start(nil, luaopen_wax_http, luaopen_wax_json, luaopen_wax_filesystem, nil);
        self.curState = wax_currentLuaState();
    }
    return self;
}

- (id)executeScript:(NSDictionary *)scriptNode
{
    NSString *method = [scriptNode objectForKey:kMFMethodKey];
    NSDictionary *params = [scriptNode objectForKey:kMFParamsKey];
    NSString *fileName = [scriptNode objectForKey:kMFScriptFileNameKey];
    NSString *contents = [scriptNode objectForKey:kMFScriptFileContentKey];
    
    if (fileName && !self.scriptFiles[fileName]) {
        [self loadFile:fileName];
    }else if (contents && ![contents isEqualToString:self.luaText]) {
        [self loadText:contents];
    }

    lua_getglobal(_curState, [method UTF8String]);
    wax_fromInstance(_curState, params);

    if (0 != wax_pcall(_curState, 1, 1)) {
        const char *msg = lua_tostring(_curState, -1);
        NSString* value = [NSString stringWithUTF8String:msg];
        NSLog(@"%@", value);
        lua_pop(_curState, 1);
        return nil;
    }

    id retObj = nil;
    if (!lua_isnil(_curState, -1)) {
        id resultObj = *(__unsafe_unretained id*)wax_copyToObjc(_curState, "@", -1, nil);
        retObj = resultObj;
    }
    lua_pop(_curState, 1);
    return retObj;
}

- (BOOL)loadFile:(NSString*)file
{
    if (nil != file) {
        NSString *bundlePath = [[NSString alloc] initWithFormat:@"%@/%@",[MFHelper getResourcePath],[MFHelper getBundleName]];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.lua", bundlePath, file];
        NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        self.scriptFiles[file] = file;
        [self loadText:content];
    }
    return NO;
}

- (BOOL)loadText:(NSString*)text
{
    if (nil != text) {
        self.luaText = text;
        luaL_dostring(_curState, [text UTF8String]);
        return YES;
    }
    return NO;
}
@end
