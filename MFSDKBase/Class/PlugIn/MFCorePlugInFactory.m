//
//  MFPlugInFactory.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/5.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFCorePlugInFactory.h"
#import "MFCssParser.h"
#import "MFHtmlParser.h"
#import "MFLuaScript.h"
@implementation MFCorePlugInFactory
+ (MFPlugIn*)createPlugIn:(MFPlugInType)plugInType
{
    MFPlugIn * retPlugIn = nil;
    switch (plugInType) {
        case MFSDK_PLUGIN_HTML:
            retPlugIn = [[MFHtmlParser alloc] init];
            break;
        case MFSDK_PLUGIN_CSS:
            retPlugIn = [[MFCssParser alloc] init];
            break;
        case MFSDK_PLUGIN_LUA:
            retPlugIn = [[MFLuaScript alloc] init];
            break;
        default:
            break;
    }
    
    return retPlugIn;
}

@end
