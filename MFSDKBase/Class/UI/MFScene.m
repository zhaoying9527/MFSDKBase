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
#import "MFDOM.h"
#import "MFSceneFactory.h"

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
    HTMLNode *htmlNode = (HTMLNode*)html;
    if (!htmlNode) {
        return nil;
    }
    
    __block NSString *key = [htmlNode getAttributeNamed:@"id"];
    MFDOM *dom = [[MFDOM alloc] initWithDomNode:htmlNode withCss:css[key] withDataBinding:dataBinding[key]  withEvents:events[key]];
    dom.clsType = htmlNode.tagName;
    NSLog(@"Dom tag: %@", htmlNode.tagName);

    [[htmlNode children] enumerateObjectsUsingBlock:^(HTMLNode *childNode, NSUInteger idx, BOOL *stop) {
        key = [childNode getAttributeNamed:@"id"];
        MFDOM *childDom = nil;
        if (nil != key) {
            childDom = [self loadDom:childNode withCss:css withDataBinding:dataBinding withEvents:events];
            NSLog(@"Dom tag: %@", childNode.tagName);
            //创建控件
            childDom.objReference = [[MFSceneFactory sharedMFSceneFactory] createUiWithDOM:childDom];
            [dom addSubDom:childDom];
        }
    }];

    return dom;
}

@end

//
//@property (nonatomic,strong)NSString *htmlNodes;
////布局信息节点
//@property (nonatomic,strong)NSDictionary *cssNodes;
////绑定事件节点
//@property (nonatomic,strong)NSDictionary *eventNodes;
////绑定字段节点
//@property (nonatomic,strong)NSString *bindingField;
//
////绑定对象
//@property (nonatomic,strong)id objReference;
////绑定类别
//@property (nonatomic,strong)NSString *typeString;
////扩展信息节点
//@property (nonatomic,strong)NSDictionary *params;
//
////子对象
//@property (nonatomic, strong) NSMutableArray *subDoms;
