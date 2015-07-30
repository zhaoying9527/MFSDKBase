//
//  MFDOM.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFDOM.h"
#import "HTMLNode.h"
#import "MFDefine.h"
#import "MFLabel.h"
#import "MFImageView.h"
#import "MFHelper.h"
#import "MFScript.h"
#import "MFDispatchCenter.h"
#import "MFResourceCenter.h"
#import "UIView+UUID.h"
#import "NSObject+VirtualNode.h"
#import "MFScene.h"
#import "MFSceneCenter.h"

@interface MFDOM()

@end

@implementation MFDOM
- (id)initWithDomNode:(HTMLNode*)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    if (self = [super init]) {
        
        self.uuid = [html getAttributeNamed:KEYWORD_ID];
        self.clsType = html.tagName;
        self.htmlNodes = html;
        self.cssNodes = css;
        self.bindingField = [dataBinding objectForKey:@"dsKey"];
        self.eventNodes = events;
        self.superDom = nil;
    }
    return self;
}

- (void)addSubDom:(MFDOM *)subDom
{
    if (nil == self.subDoms) {
        self.subDoms = [NSMutableArray array];
    }

    if (nil != subDom) {
        [self.subDoms addObject:subDom];
        subDom.superDom = self;
    }
}

- (MFDOM*)findSubDomWithID:(NSString*)ID
{
    if ([[self.htmlNodes getAttributeNamed:KEYWORD_ID] isEqualToString:ID]) {
        return self;
    }
    
    MFDOM *matchDom = nil;
    for (MFDOM *subDom in self.subDoms) {
        matchDom = [subDom findSubDomWithID:ID];
        if (matchDom) {
            return matchDom;
        }
    }
    return matchDom;
}

- (BOOL)isBindingToWidget
{
    
    return YES;
}

- (id)triggerEvent:(NSString*)event withParams:(NSDictionary*)params
{
    NSString *sceneName = [[[MFSceneCenter sharedMFSceneCenter] currentScene] sceneName];
    
    NSString *function = self.eventNodes[event];
    NSRange range = [function rangeOfString:@"("];
    NSString *method = [function substringToIndex:range.location];
    if (method) {
        NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithDictionary:params];
        [allParams setObject:method forKey:kMFMethodKey];
        [allParams setObject:sceneName forKey:kMFScriptFileNameKey];
        return [[MFDispatchCenter sharedMFDispatchCenter] executeScript:allParams scriptType:MFSDK_SCRIPT_LUA];
    }
    return nil;
}
@end
