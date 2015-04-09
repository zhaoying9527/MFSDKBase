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
#import "MFSceneFactory.h"

@implementation MFScene

- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    if (self = [super init]) {
        self.doms = [NSMutableDictionary dictionary];
        for (HTMLNode *htmlNode in (NSArray*)html) {
            if ([[MFSceneFactory sharedMFSceneFactory] supportHtmlTag:htmlNode.tagName]) {
                MFDOM *dom = [self loadDom:htmlNode withCss:css withDataBinding:dataBinding withEvents:events];
                if (dom && dom.uuid) {
                    [self.doms setObject:dom forKey:dom.uuid];
                }
            }
        }
    }
    return self;
}

- (MFDOM*)loadDom:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    MFDOM *dom = nil;
    HTMLNode *htmlNode = (HTMLNode*)html;
    dom = [[MFDOM alloc] initWithDomNode:htmlNode withCss:css[dom.uuid] withDataBinding:dataBinding[dom.uuid] withEvents:events[dom.uuid]];
    dom.uuid = [htmlNode getAttributeNamed:KEYWORD_ID];    
    dom.clsType = htmlNode.tagName;

    dom.objReference = [[MFSceneFactory sharedMFSceneFactory] createWidgetWithDOM:dom];

    [[htmlNode children] enumerateObjectsUsingBlock:^(HTMLNode *childNode, NSUInteger idx, BOOL *stop) {
        MFDOM *childDom = nil;
        if (nil != [childNode getAttributeNamed:KEYWORD_ID]) {
            childDom = [self loadDom:childNode withCss:css withDataBinding:dataBinding withEvents:events];
            NSLog(@"Dom tag: %@", childNode.tagName);
            //双向绑定
            [childDom setObjReference:[[MFSceneFactory sharedMFSceneFactory] createWidgetWithDOM:childDom]];
            [childDom.objReference attachDOM:childDom];
            [dom addSubDom:childDom];
        }
    }];

    return dom;
}

//- (MFDOM*)loadDom:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
//{
//    MFDOM *dom = nil;
//    NSArray *bodyEntity = (NSArray*)html;
//    for (HTMLNode *htmlNode in bodyEntity) {
//        __block NSString *key = [htmlNode getAttributeNamed:KEYWORD_ID];
//        dom = [[MFDOM alloc] initWithDomNode:htmlNode withCss:css[key] withDataBinding:dataBinding[key] withEvents:events[key]];
//        dom.clsType = htmlNode.tagName;
//        dom.objReference = [[MFSceneFactory sharedMFSceneFactory] createWidgetWithDOM:dom];
//        
//        [[htmlNode children] enumerateObjectsUsingBlock:^(HTMLNode *childNode, NSUInteger idx, BOOL *stop) {
//            key = [childNode getAttributeNamed:KEYWORD_ID];
//            MFDOM *childDom = nil;
//            if (nil != key) {
//                childDom = [self loadDom:childNode withCss:css withDataBinding:dataBinding withEvents:events];
//                NSLog(@"Dom tag: %@", childNode.tagName);
//                //双向绑定
//                [childDom setObjReference:[[MFSceneFactory sharedMFSceneFactory] createWidgetWithDOM:childDom]];
//                [childDom.objReference attachDOM:childDom];
//                [dom addSubDom:childDom];
//            }
//        }];
//        
//    }
//    
//    return dom;
//}

- (MFDOM*)findDomWithID:(NSString*)ID
{
    return self.doms[ID];
}
@end
