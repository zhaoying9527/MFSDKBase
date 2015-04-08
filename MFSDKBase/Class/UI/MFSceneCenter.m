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

@interface MFSceneCenter ()

@property (nonatomic, strong)MFCorePlugInService *pluginService;
@property (nonatomic, copy) NSString *sceneName;
@property (nonatomic, strong) HTMLNode *html;
@property (nonatomic, strong) NSDictionary *css;
@property (nonatomic, strong) NSDictionary *dataBindings;
@end

@implementation MFSceneCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFSceneCenter)

- (void)initSceneWithName:(NSString*)sceneName
{
    self.sceneName = sceneName;
    self.pluginService = [[MFCorePlugInService alloc] init];
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html", bundlePath, sceneName];
    NSString *cssPath = [NSString stringWithFormat:@"%@/%@.css", bundlePath, sceneName];
    NSString *dataBindingPath = [NSString stringWithFormat:@"%@/%@.dataBinding", bundlePath, sceneName];
    NSString *luaPath = [NSString stringWithFormat:@"%@/%@.lua", bundlePath, sceneName];

    NSError *error = nil;
    BOOL success = NO;
    MFHtmlParser *htmlParser = (MFHtmlParser *)[self.pluginService findPlugInWithType:MFSDK_PLUGIN_HTML];
    success = [htmlParser loadText:[NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error]];
    self.html = [htmlParser html];

    MFCssParser *cssParser = (MFCssParser *)[self.pluginService findPlugInWithType:MFSDK_PLUGIN_CSS];
    success = [cssParser loadText:[NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:&error]];
    self.css = [cssParser parse];

    [cssParser loadText:[NSString stringWithContentsOfFile:dataBindingPath encoding:NSUTF8StringEncoding error:&error]];
    self.dataBindings = [cssParser parse];

    MFLuaScript *luaScript = (MFLuaScript *)[self.pluginService findPlugInWithType:MFSDK_PLUGIN_LUA];
    [luaScript loadText:[NSString stringWithContentsOfFile:luaPath encoding:NSUTF8StringEncoding error:&error]];
}

@end
