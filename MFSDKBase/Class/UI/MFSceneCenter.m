//
//  MFSceneCenter.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFSceneCenter.h"
#import "MFCorePlugInService.h"
#import "MFScene+Internal.h"
#import "MFSceneFactory.h"
#import "MFHTMLParser.h"
#import "MFCssParser.h"
#import "MFLuaScript.h"
#import "MFDefine.h"
#import "MFDOM.h"

@interface MFSceneCenter ()
@property (nonatomic, copy) NSString *currentSceneName;
@property (nonatomic, strong)MFCorePlugInService *pluginService;
@property (nonatomic, strong)NSMutableDictionary *htmlParsers;

- (id)parse:(MFPlugInType)plugInType withPath:(NSString*)path error:(NSError**)error;
@end

@implementation MFSceneCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFSceneCenter)

- (instancetype)init
{
    if (self = [super init]) {
        self.scenes = [NSMutableDictionary dictionary];
        self.htmlParsers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerScene:(MFScene*)scene withName:(NSString*)sceneName
{
    self.currentSceneName = sceneName;
    if (nil != scene && nil != sceneName) {
        [self.scenes setObject:scene forKey:sceneName];
    }
}

- (BOOL)unRegisterScene:(NSString*)sceneName
{
    MFScene *scence = [self.scenes objectForKey:sceneName];
    if (nil != scence) {
        [self.scenes removeObjectForKey:sceneName];
    }
    
    return (nil != scence);
}

- (MFScene*)sceneWithName:(NSString*)sceneName
{
    return [self.scenes objectForKey:sceneName];
}

- (MFScene*)currentScene
{
    return [self.scenes objectForKey:self.currentSceneName];
}

- (void)releaseSceneWithName:(NSString*)sceneName
{
    [self.htmlParsers removeObjectForKey:sceneName];
    MFScene *scene = [self sceneWithName:sceneName];
    [scene removeAll];
}

- (MFScene*)loadSceneWithName:(NSString*)sceneName
{
    if (nil == _pluginService) {
        _pluginService = [[MFCorePlugInService alloc] init];
    }
    
    NSString *bundlePath = [[NSString alloc] initWithFormat:@"%@/%@",[MFHelper getResourcePath],[MFHelper getBundleName]];
    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html", bundlePath, sceneName];
    NSString *cssPath = [NSString stringWithFormat:@"%@/%@.css", bundlePath, sceneName];
    NSString *dataBindingPath = [NSString stringWithFormat:@"%@/%@.dataBinding", bundlePath, sceneName];
    
    MFHtmlParser *result_h5 = nil;
    id result_css = nil;
    id result_databinding = nil;
    id result_events = nil;
    id result_style = nil;
    
    NSError *error;
    result_h5 = [self parse:MFSDK_PLUGIN_HTML withPath:htmlPath error:&error];
    [self.htmlParsers setObject:[result_h5 parser] forKey:sceneName];
    result_css = [self parse:MFSDK_PLUGIN_CSS withPath:cssPath error:&error];
    result_databinding = [self parse:MFSDK_PLUGIN_CSS withPath:dataBindingPath error:&error];
    result_events = [self parseEvent:result_h5];
    result_style = [self parseStyle:result_h5];
    
    //加载场景
    return [[MFScene alloc] initWithDomNodes:[result_h5 bodyEntity] withCss:result_css withDataBinding:result_databinding withEvents:result_events withStyles:result_style withSceneName:sceneName];
}

- (id)parse:(MFPlugInType)plugInType withPath:(NSString*)path error:(NSError**)error
{
    MFParser *parser = (MFParser*)[self.pluginService findPlugInWithType:plugInType];
    if ([parser loadText:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:error]]) {
        return [parser parse];
    }
    return nil;
}

- (id)parseStyle:(MFHtmlParser *)htmlParser
{
    NSArray *bodyEntity = [htmlParser bodyEntity];
    
    NSMutableDictionary *allStyles = [NSMutableDictionary dictionary];
    for (HTMLNode *htmlNode in bodyEntity) {
        NSString *style = [self extractStyle:htmlNode];
        NSString *key = [htmlNode getAttributeNamed:KEYWORD_ID];
        if (key && style) {
            [allStyles setObject:style forKey:key];
        }
    }
    return allStyles;
}

-(NSString *)extractStyle:(HTMLNode *)htmlNode
{
    if (!htmlNode) {
        return NO;
    }
    
    NSString *styleValue = nil;
    NSArray *attributes = [htmlNode getAttributes];
    NSString *styleRegix = @"style=(.*)";
    NSString *realAttribute = @"";
    for (realAttribute in attributes) {
        if ([realAttribute rangeOfString:styleRegix options:NSRegularExpressionSearch].length > 0) {
            NSArray * components = [realAttribute componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
            if (2 == components.count) {
                styleValue = components[1];
                break;
            }
        }
    }
    return styleValue;
}

- (id)parseEvent:(MFHtmlParser *)htmlParser
{
    NSArray *bodyEntity = [htmlParser bodyEntity];
    
    NSMutableDictionary *allEvents = [NSMutableDictionary dictionary];
    for (HTMLNode *htmlNode in bodyEntity) {
        NSDictionary *events = [self extractEvent:htmlNode];
        [allEvents addEntriesFromDictionary:events];
    }
    return allEvents;
}

-(NSDictionary *)extractEvent:(HTMLNode *)htmlNode
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
        NSDictionary *childEvents = [self extractEvent:childNode];
        [rootNodeEvents addEntriesFromDictionary:childEvents];
    }];
    
    return rootNodeEvents;
}

- (MFCorePlugInService*)pluginService
{
    return _pluginService;
}
@end
