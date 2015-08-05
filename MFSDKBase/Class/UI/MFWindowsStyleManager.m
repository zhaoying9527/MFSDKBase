//
//  MFWindowsStyleManager.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/7/30.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFWindowsStyleManager.h"
#import "MFCorePlugInService.h"
#import "MFHTMLParser.h"
#import "MFCssParser.h"
#import "MFLuaScript.h"
#import "MFDefine.h"
#import "MFDOM.h"
@interface MFWindowsStyleManager()
@property (nonatomic, strong)MFCorePlugInService *pluginService;
@property (nonatomic, strong)NSMutableDictionary *htmlParsers;
@property (nonatomic, strong)NSArray *bodyEntity;
@property (nonatomic, strong)id style;
@property (nonatomic, strong)id css;
@property (nonatomic, strong)id databinding;
@property (nonatomic, strong)id events;
- (id)parse:(MFPlugInType)plugInType withPath:(NSString*)path error:(NSError**)error;
@end

@implementation MFWindowsStyleManager
SYNTHESIZE_SINGLETON_FOR_CLASS(MFWindowsStyleManager)
- (BOOL)loadWStyleWithName:(NSString*)styleName
{
    BOOL retCode = NO;
    NSString *bundlePath = [[NSString alloc] initWithFormat:@"%@/%@",[MFHelper getResourcePath],[MFHelper getBundleName]];
    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html", bundlePath, styleName];
    NSString *cssPath = [NSString stringWithFormat:@"%@/%@.css", bundlePath, styleName];
    NSString *dataBindingPath = [NSString stringWithFormat:@"%@/%@.dataBinding", bundlePath, styleName];
    
    NSError *error = nil;
    
    MFHtmlParser *result_h5 = [self parse:MFSDK_PLUGIN_HTML withPath:htmlPath error:&error];
    if (nil != result_h5) {
        [self.htmlParsers setObject:[result_h5 parser] forKey:styleName];
        self.css = [self parse:MFSDK_PLUGIN_CSS withPath:cssPath error:&error];
        self.databinding = [self parse:MFSDK_PLUGIN_CSS withPath:dataBindingPath error:&error];
        self.events = [self parseEvent:result_h5];
        self.style = [self parseStyle:result_h5];
        self.bodyEntity = [result_h5 bodyEntity];
        retCode = YES;
    }
    return retCode;
}

- (id)parse:(MFPlugInType)plugInType withPath:(NSString*)path error:(NSError**)error
{
    if (nil == _pluginService) {
        _pluginService = [[MFCorePlugInService alloc] init];
    }
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
        NSString *key = [htmlNode getAttributeNamed:MF_KEYWORD_ID];
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
    NSString *ID = [htmlNode getAttributeNamed:MF_KEYWORD_ID];
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
