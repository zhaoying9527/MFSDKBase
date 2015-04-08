//
//  MFSceneCenter.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFSceneCenter.h"
#import "MFCorePlugInService.h"
#import "HTMLParser.h"
#import "MFHtmlParser.h"
#import "MFCssParser.h"
#import "MFLuaScript.h"
#import "MFDOM.h"
@interface MFSceneCenter ()

@property (nonatomic, strong)MFCorePlugInService *pluginService;
@property (nonatomic, copy) NSString *sceneName;
- (MFDOM*)loadDOM;
- (id)parse:(MFPlugInType)plugInType withPath:(NSString*)path error:(NSError**)error;
@end

@implementation MFSceneCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFSceneCenter)

- (void)initSceneWithName:(NSString*)sceneName
{
    self.sceneName = sceneName;
    self.dom = [self loadDOM];
}

- (MFDOM*)loadDOM
{
    self.pluginService = [[MFCorePlugInService alloc] init];
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html", bundlePath, self.sceneName];
    NSString *cssPath = [NSString stringWithFormat:@"%@/%@.css", bundlePath, self.sceneName];
    NSString *dataBindingPath = [NSString stringWithFormat:@"%@/%@.dataBinding", bundlePath, self.sceneName];
    
    HTMLNode *result_h5 = nil;
    id result_css = nil;
    id result_databinding = nil;
    
    result_h5 = [self parse:MFSDK_PLUGIN_HTML withPath:htmlPath error:nil];
    result_css = [self parse:MFSDK_PLUGIN_CSS withPath:cssPath error:nil];
    result_databinding = [self parse:MFSDK_PLUGIN_CSS withPath:dataBindingPath error:nil];
    
    return [[MFDOM alloc] initWithDomNodes:result_h5 withCss:result_css withDataBinding:result_databinding];
    //    MFLuaScript *luaScript = (MFLuaScript *)[self.pluginService findPlugInWithType:MFSDK_PLUGIN_LUA];
    //    [luaScript loadText:[NSString stringWithContentsOfFile:luaPath encoding:NSUTF8StringEncoding error:&error]];
}

- (id)parse:(MFPlugInType)plugInType withPath:(NSString*)path error:(NSError**)error
{
    MFParser *parser = (MFParser*)[self.pluginService findPlugInWithType:plugInType];
    if ([parser loadText:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:error]]) {
        return [parser parse];
    }
    return nil;
}
@end
