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
#import "UIView+UUID.h"
#import "MFDefine.h"
#import "MFDOM.h"
#import "MFSceneFactory.h"
#import "MFDataBinding.h"
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
    NSString *uid = [htmlNode getAttributeNamed:KEYWORD_ID];
    dom = [[MFDOM alloc] initWithDomNode:htmlNode withCss:css[uid] withDataBinding:dataBinding[uid] withEvents:events[uid]];
    dom.uuid = uid;
    dom.clsType = htmlNode.tagName;
    
    [[htmlNode children] enumerateObjectsUsingBlock:^(HTMLNode *childNode, NSUInteger idx, BOOL *stop) {
        MFDOM *childDom = nil;
        if (nil != [childNode getAttributeNamed:KEYWORD_ID]) {
            childDom = [self loadDom:childNode withCss:css withDataBinding:dataBinding withEvents:events];
            NSLog(@"Dom tag: %@", childNode.tagName);
            [dom addSubDom:childDom];
        }
    }];

    return dom;
}



- (MFDOM*)findDomWithID:(NSString*)ID
{
    return self.doms[ID];
}

- (void)bind:(UIView*)view withDataSource:(NSDictionary*)dataSource
{
    if (view.subviews.count > 0) {
        UIView *subview = [[view subviews] objectAtIndex:0];
        [MFDataBinding bind:subview withDataSource:dataSource];
    }
}

- (void)layout
{
    
}

- (UIView*)sceneViewWithDomId:(NSString*)domId
{
    MFDOM *matchDom = [self findDomWithID:domId];
    return [[MFSceneFactory sharedMFSceneFactory] createUIWithDOM:matchDom sizeInfo:nil];
}
@end
