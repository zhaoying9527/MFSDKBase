//
//  MFScene.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFScene.h"
#import "HTMLNode.h"
#import "HTMLParser.h"
#import "MFSceneFactory.h"
#import "NSObject+DOM.h"
#import "MFDefine.h"
#import "MFDOM.h"
@implementation MFScene

- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    if (self = [super init]) {
        self.dom = [self loadDom:html withCss:css withDataBinding:dataBinding withEvents:events];
    }
    return self;
}

- (MFDOM*)loadDom:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    HTMLNode *htmlNode2 = (HTMLNode*)html;
    if (!htmlNode2) {
        return nil;
    }
    MFDOM *dom = nil;
    NSArray *htmlList = (NSArray*)html;
    for (HTMLNode *htmlNode in htmlList) {
        __block NSString *key = [htmlNode getAttributeNamed:KEYWORD_ID];
        dom = [[MFDOM alloc] initWithDomNode:htmlNode withCss:css[key] withDataBinding:dataBinding[key] withEvents:events[key]];
        dom.clsType = htmlNode.tagName;
        dom.objReference = [[MFSceneFactory sharedMFSceneFactory] createWidgetWithDOM:dom];

        [[htmlNode children] enumerateObjectsUsingBlock:^(HTMLNode *childNode, NSUInteger idx, BOOL *stop) {
            key = [childNode getAttributeNamed:KEYWORD_ID];
            MFDOM *childDom = nil;
            if (nil != key) {
                childDom = [self loadDom:childNode withCss:css withDataBinding:dataBinding withEvents:events];
                NSLog(@"Dom tag: %@", childNode.tagName);
                //双向绑定
                [childDom setObjReference:[[MFSceneFactory sharedMFSceneFactory] createWidgetWithDOM:childDom]];
                [childDom.objReference attachDOM:childDom];
                [dom addSubDom:childDom];
            }
        }];
        
    }

    
    
    return dom;
}

- (MFDOM*)findDomWithID:(NSString*)ID
{
    return [self.dom findSubDomWithID:ID];
}
@end
