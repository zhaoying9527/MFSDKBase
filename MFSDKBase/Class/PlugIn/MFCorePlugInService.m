//
//  MFEventCenter.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFCorePlugInService.h"
#import "MFCorePlugInFactory.h"
@interface MFCorePlugInService()
@property (nonatomic,strong)NSMutableDictionary *pluginDict;
- (void)registerCorePlugIn;
- (void)releaseAllCorePlugIn;
@end
@implementation MFCorePlugInService
- (id)init
{
    self.pluginDict = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)registerCorePlugIn
{
    //可配置文件化
    [self releaseAllCorePlugIn];
    
    [self.pluginDict setObject:[MFCorePlugInFactory createPlugIn:MFSDK_PLUGIN_HTML] forKey:[NSNumber numberWithInt:MFSDK_PLUGIN_HTML]];
    [self.pluginDict setObject:[MFCorePlugInFactory createPlugIn:MFSDK_PLUGIN_CSS] forKey:[NSNumber numberWithInt:MFSDK_PLUGIN_CSS]];
    [self.pluginDict setObject:[MFCorePlugInFactory createPlugIn:MFSDK_PLUGIN_LUA] forKey:[NSNumber numberWithInt:MFSDK_PLUGIN_LUA]];
}

- (void)releaseAllCorePlugIn
{
    [self.pluginDict removeAllObjects];
}

- (MFPlugIn*)findPlugInWithType:(MFPlugInType)plugInType
{
    return [self.pluginDict objectForKey:[NSNumber numberWithInt:plugInType]];
}
@end
