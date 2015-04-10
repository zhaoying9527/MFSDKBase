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
#import "MFHelper.h"
#import "MFLayoutCenter.h"
@interface MFScene ()
@property (nonatomic,strong)NSMutableDictionary *doms;
@property (nonatomic,strong)NSMutableArray *orders;
//
- (void)addDom:(MFDOM *)dom;
//
- (void)bind:(UIView*)view withDataSource:(NSDictionary*)dataSource;
//
- (void)layout:(UIView*)view withSizeInfo:(NSDictionary*)sizeInfo;
@end

@implementation MFScene

- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events withSceneName:(NSString *)sceneName
{
    if (self = [super init]) {
        self.sceneName = sceneName;
        self.doms = [[NSMutableDictionary alloc] init];
        for (HTMLNode *htmlNode in (NSArray*)html) {
            if ([[MFSceneFactory sharedMFSceneFactory] supportHtmlTag:htmlNode.tagName]) {
                MFDOM *dom = [self loadDom:htmlNode withCss:css withDataBinding:dataBinding withEvents:events];
                if (dom && dom.uuid) {
                    [self addDom:dom];
                }
            }
        }
        
        [self createOrders:css];
    }
    return self;
}

- (void)createOrders:(NSDictionary*)cssNodes
{
    self.orders = [[NSMutableArray alloc] initWithCapacity:cssNodes.allKeys.count];
    //占位
    for (int i=0; i<cssNodes.allKeys.count; i++) {
        [self.orders addObject:[NSNull null]];
    }
    //填充
    for (NSString *key in cssNodes.allKeys) {
        NSDictionary *css = cssNodes[key];
        [self.orders replaceObjectAtIndex:[css[@"order"] intValue] withObject:key];
    }
    //检查
    [self.orders removeObject:[NSNull null] inRange:NSMakeRange(0, self.orders.count)];
}

- (void)addDom:(MFDOM *)dom
{
    [self.doms setObject:dom forKey:dom.uuid];
}

- (MFDOM*)loadDom:(HTMLNode*)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    MFDOM *dom = nil;
    HTMLNode *htmlNode = (HTMLNode*)html;
    NSString *uid = [htmlNode getAttributeNamed:KEYWORD_ID];
    dom = [[MFDOM alloc] initWithDomNode:htmlNode withCss:css[uid] withDataBinding:dataBinding[uid] withEvents:events[uid]];
   
    
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

- (MFDOM*)domWithId:(NSString*)ID
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

- (void)bind:(UIView *)view withIndex:(NSInteger)index
{
    [self bind:view withDataSource:self.dataArray[index]];
}

- (void)layout:(UIView*)view withIndex:(NSInteger)index
{
    NSString *indexKey = [NSString stringWithFormat:@"%ld",index];
    [self layout:view withSizeInfo:self.layoutDict[indexKey]];
}

- (void)layout:(UIView*)view withSizeInfo:(NSDictionary*)sizeInfo
{
    if (view.subviews.count > 0) {
        UIView *subview = [[view subviews] objectAtIndex:0];
        [[MFLayoutCenter sharedMFLayoutCenter] layout:subview withSizeInfo:sizeInfo];
    }
}

- (UIView*)sceneViewWithDomId:(NSString*)domId
{
    MFDOM *matchDom = [self domWithId:domId];
    return [[MFSceneFactory sharedMFSceneFactory] createUIWithDOM:matchDom sizeInfo:nil];
}


- (void)autoLayoutOperations:(NSArray*)dataArray callback:(void(^)(NSDictionary*prepareLayoutDict,NSInteger prepareHeight))callback
{
    NSInteger retHeight = 0;
    NSArray *datas = self.dataArray;
    self.layoutDict = [[NSMutableDictionary alloc] initWithCapacity:self.dataArray.count];
    for (int accessIndex=0; accessIndex < datas.count; accessIndex++) {
        NSDictionary *dataDict = [datas objectAtIndex:accessIndex];
        NSString *templateId = [dataDict objectForKey:KEYWORD_TEMPLATE_ID];
        MFDOM *matchDom = [self domWithId:templateId];
        NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)accessIndex];
        
        CGRect superFrame = CGRectMake(0, 0, [MFHelper screenXY].width, 0);
        NSDictionary *indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfDom:matchDom superDomFrame:superFrame dataSource:dataDict];
        [self.layoutDict setObject:indexPathDict forKey:indexKey];
        retHeight += [[indexPathDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
    }
    callback(self.layoutDict, retHeight);
}
@end
