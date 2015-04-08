//
//  MFSDK.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#ifndef MFSDKBase_MFSDK_h
#define MFSDKBase_MFSDK_h
#define SYNTHESIZE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}
typedef enum {
    MFSDK_PLUGIN_LUA = 0,
    MFSDK_PLUGIN_HTML,
    MFSDK_PLUGIN_CSS,
}MFPlugInType;

typedef enum {
    MFSDK_SCRIPT_LUA = 0,
    MFSDK_SCRIPT_JS,
}MFSDKScriptType;
#endif
