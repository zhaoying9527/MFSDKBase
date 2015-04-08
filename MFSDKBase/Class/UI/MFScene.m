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
    HTMLNode *htmlNode = ((HTMLParser*)html).body;
    if (!htmlNode) {
        return nil;
    }
    
    MFDOM *dom = [[MFDOM alloc] initWithDomNodes:htmlNode withCss:css withDataBinding:dataBinding withEvents:events];
    NSLog(@"Dom tag: %@", htmlNode.tagName);
    
    [[htmlNode children] enumerateObjectsUsingBlock:^(HTMLNode *childNode, NSUInteger idx, BOOL *stop) {
        MFDOM *childDom = [[MFDOM alloc] initWithDomNodes:childNode withCss:css withDataBinding:dataBinding withEvents:events];
        NSLog(@"Dom tag: %@", childNode.tagName);
        [dom addSubDom:childDom];
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
