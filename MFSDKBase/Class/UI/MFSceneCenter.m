//
//  MFSceneCenter.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFSceneCenter.h"
#import "MFCorePlugInService.h"
#import "MFSceneFactory.h"
#import "HTMLParser.h"
#import "MFHtmlParser.h"
#import "MFCssParser.h"
#import "MFLuaScript.h"
#import "MFDefine.h"
#import "MFDOM.h"

@interface MFSceneCenter ()

@property (nonatomic, strong)MFCorePlugInService *pluginService;
@property (nonatomic, copy) NSString *sceneName;
//- (MFDOM*)loadDOM;
- (MFScene*)loadScene;
- (id)parse:(MFPlugInType)plugInType withPath:(NSString*)path error:(NSError**)error;
@end

@implementation MFSceneCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFSceneCenter)

- (void)initSceneWithName:(NSString*)sceneName
{
    self.sceneName = sceneName;
    self.scene = [self loadScene];
//    self.dom = [self loadDOM];
}

- (MFScene*)loadScene
{
    self.pluginService = [[MFCorePlugInService alloc] init];
    
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html", bundlePath, self.sceneName];
    NSString *cssPath = [NSString stringWithFormat:@"%@/%@.css", bundlePath, self.sceneName];
    NSString *dataBindingPath = [NSString stringWithFormat:@"%@/%@.dataBinding", bundlePath, self.sceneName];
    NSString *luaPath = [NSString stringWithFormat:@"%@/%@.lua", bundlePath, self.sceneName];
    
    HTMLParser *result_h5 = nil;
    id result_css = nil;
    id result_databinding = nil;
    id result_events = nil;
    
    
    NSError *error;
    result_h5 = [self parse:MFSDK_PLUGIN_HTML withPath:htmlPath error:&error];
    result_css = [self parse:MFSDK_PLUGIN_CSS withPath:cssPath error:&error];
    result_databinding = [self parse:MFSDK_PLUGIN_CSS withPath:dataBindingPath error:&error];
    result_events = [self parseEvent:result_h5];
    
    
    MFLuaScript *luaScript = (MFLuaScript *)[self.pluginService findPlugInWithType:MFSDK_PLUGIN_LUA];
    [luaScript loadText:[NSString stringWithContentsOfFile:luaPath encoding:NSUTF8StringEncoding error:&error]];
    
    //parse
    //dom list
    return [[MFScene alloc] initWithDomNodes:result_h5 withCss:result_css withDataBinding:result_databinding withEvents:result_events];
//    return [[MFDOM alloc] initWithDomNodes:result_h5 withCss:result_css withDataBinding:result_databinding];
    
}

//- (MFDOM*)loadDOM
//{
//    self.pluginService = [[MFCorePlugInService alloc] init];
//    
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html", bundlePath, self.sceneName];
//    NSString *cssPath = [NSString stringWithFormat:@"%@/%@.css", bundlePath, self.sceneName];
//    NSString *dataBindingPath = [NSString stringWithFormat:@"%@/%@.dataBinding", bundlePath, self.sceneName];
//    NSString *luaPath = [NSString stringWithFormat:@"%@/%@.lua", bundlePath, self.sceneName];
//    
//    HTMLParser *result_h5 = nil;
//    id result_css = nil;
//    id result_databinding = nil;
//    
//    
//    NSError *error;
//    result_h5 = [self parse:MFSDK_PLUGIN_HTML withPath:htmlPath error:&error];
//    result_css = [self parse:MFSDK_PLUGIN_CSS withPath:cssPath error:&error];
//    result_databinding = [self parse:MFSDK_PLUGIN_CSS withPath:dataBindingPath error:&error];
//
//    MFLuaScript *luaScript = (MFLuaScript *)[self.pluginService findPlugInWithType:MFSDK_PLUGIN_LUA];
//    [luaScript loadText:[NSString stringWithContentsOfFile:luaPath encoding:NSUTF8StringEncoding error:&error]];
//
//    //parse
//    //dom list
//    return [[MFDOM alloc] initWithDomNodes:result_h5 withCss:result_css withDataBinding:result_databinding];
//
//}

- (id)parse:(MFPlugInType)plugInType withPath:(NSString*)path error:(NSError**)error
{
    MFParser *parser = (MFParser*)[self.pluginService findPlugInWithType:plugInType];
    if ([parser loadText:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:error]]) {
        return [parser parse];
    }
    return nil;
}

- (id)parseEvent:(HTMLParser *)html
{
    HTMLNode *body = [html body];
    return [self extractEventNode:body];
    
}

-(NSDictionary *)extractEventNode:(HTMLNode *)htmlNode
{
    if (!htmlNode) {
        return NO;
    }

    NSMutableDictionary *events = [NSMutableDictionary dictionary];
    NSArray *attributes = [htmlNode getAttributes];
    NSString *actionRegix = @"on.*=(.*)\\((.*)\\)";
    NSString *realAttribute = @"";
    NSString *ID = [htmlNode getAttributeNamed:KEYWORD_ID];
    for (realAttribute in attributes) {
        if ([realAttribute rangeOfString:actionRegix options:NSRegularExpressionSearch].length > 0) {
            NSArray * components = [realAttribute componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
            if (2 == components.count) {
                NSString *eventName = components[0];
                NSString *functionName = components[1];
                [events setObject:functionName forKey:eventName];
            }
        }
    }
    NSMutableDictionary *rootNodeEvents = [NSMutableDictionary dictionary];
    if (ID && events.count) {
        rootNodeEvents = [NSMutableDictionary dictionaryWithDictionary:@{ID:events}];
    }

    [[htmlNode children] enumerateObjectsUsingBlock:^(HTMLNode *childNode, NSUInteger idx, BOOL *stop) {
        NSDictionary *childEvents = [self extractEventNode:childNode];
        [rootNodeEvents addEntriesFromDictionary:childEvents];
    }];

    return rootNodeEvents;
}
@end
