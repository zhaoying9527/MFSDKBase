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
#import "UIView+Sizes.h"
@interface MFScene ()
@property (nonatomic,strong)NSMutableDictionary *doms;
@property (nonatomic,strong)NSMutableDictionary *headers;
@property (nonatomic,strong)NSMutableDictionary *footers;
@property (nonatomic,strong)NSMutableArray *orders;
//
- (void)addDom:(MFDOM *)dom withType:(MFDomType)type;
@end

@implementation MFScene

- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events withStyles:(NSMutableDictionary*)styles withSceneName:(NSString *)sceneName
{
    if (self = [super init]) {
        self.sceneName = sceneName;
        self.doms = [[NSMutableDictionary alloc] init];
        self.headers = [[NSMutableDictionary alloc] init];
        self.footers = [[NSMutableDictionary alloc] init];
        for (HTMLNode *htmlNode in (NSArray*)html) {
            if ([[MFSceneFactory sharedMFSceneFactory] supportHtmlTag:htmlNode.tagName]) {
                MFDOM *header = [self loadHeader:htmlNode withCss:css withDataBinding:dataBinding withEvents:events withStyles:styles];
                if (header && header.uuid) {
                    [self addDom:header withType:MFDomTypeHead];
                }

                MFDOM *dom = [self loadDom:htmlNode withCss:css withDataBinding:dataBinding withEvents:events];
                if (dom && dom.uuid) {
                    [self addDom:dom withType:MFDomTypeBody];
                }

                MFDOM *footer = [self loadFooter:htmlNode withCss:css withDataBinding:dataBinding withEvents:events withStyles:styles];
                if (footer && footer.uuid) {
                    [self addDom:footer withType:MFDomTypeFoot];
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
        if (css[@"order"] ) {
            [self.orders replaceObjectAtIndex:[css[@"order"] intValue] withObject:key];
        }
    }
    //检查
    [self.orders removeObject:[NSNull null] inRange:NSMakeRange(0, self.orders.count)];
}

- (NSArray *)domOrders
{
    return self.orders;
}

- (void)addDom:(MFDOM *)dom withType:(MFDomType)type
{
    if (MFDomTypeHead == type) {
        [self.headers setObject:dom forKey:dom.uuid];
    } else if (MFDomTypeBody == type) {
        [self.doms setObject:dom forKey:dom.uuid];
    } else if (MFDomTypeFoot == type) {
        [self.footers setObject:dom forKey:dom.uuid];
    }
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

- (MFDOM*)loadHeader:(HTMLNode*)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events withStyles:(NSMutableDictionary*)styles
{
    MFDOM *header = nil;
    HTMLNode *htmlNode = (HTMLNode*)html;
    NSString *uid = [htmlNode getAttributeNamed:KEYWORD_ID];
    if (!styles[uid]) {
        return nil;
    }

    //该Dom上有header
    NSString *styleCssKey = styles[uid];
    NSString *headCssKey = css[styleCssKey][@"head"];
    headCssKey = [headCssKey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    if (headCssKey) {
        header = [[MFDOM alloc] initWithDomNode:htmlNode withCss:css[headCssKey] withDataBinding:dataBinding[headCssKey] withEvents:events[headCssKey]];
        header.clsType = @"head";
    }
    return header;
}

- (MFDOM*)loadFooter:(HTMLNode*)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events withStyles:(NSMutableDictionary*)styles
{
    MFDOM *footer = nil;
    HTMLNode *htmlNode = (HTMLNode*)html;
    NSString *uid = [htmlNode getAttributeNamed:KEYWORD_ID];
    if (!styles[uid]) {
        return nil;
    }
    
    //该Dom上有footer
    NSString *styleCssKey = styles[uid];
    NSString *footCssKey = css[styleCssKey][@"foot"];
    footCssKey = [footCssKey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    if (footCssKey) {
        footer = [[MFDOM alloc] initWithDomNode:htmlNode withCss:css[footCssKey] withDataBinding:dataBinding[footCssKey] withEvents:events[footCssKey]];
        footer.clsType = @"foot";
    }
    return footer;
}

- (MFDOM*)domWithId:(NSString*)ID withType:(MFDomType)type
{
    if (MFDomTypeBody == type) {
        return self.doms[ID];
    } else if (MFDomTypeHead == type) {
        return self.headers[ID];
    } else if (MFDomTypeFoot == type) {
        return self.footers[ID];
    }
    return nil;
}

- (void)bind:(UIView *)view withIndex:(NSInteger)index
{
    for (UIView *subView in view.subviews) {
        [MFDataBinding bind:subView withDataSource:self.dataArray[index]];
    }
}

- (void)layout:(UIView*)view withIndex:(NSInteger)index
{
    UIView *headView = nil;
    UIView *bodyView = nil;
    UIView *footView = nil;
    for (UIView *subView in view.subviews) {
        if (1000 == subView.tag) {
            headView = subView;
        } else if (1001 == subView.tag) {
            bodyView = subView;
        } else if (1002 == subView.tag) {
            footView = subView;
        }
    }

    NSString *indexKey = [NSString stringWithFormat:@"%ld",(long)index];
    [[MFLayoutCenter sharedMFLayoutCenter] layout:headView withSizeInfo:self.headerLayoutDict[indexKey]];
    [[MFLayoutCenter sharedMFLayoutCenter] layout:bodyView withSizeInfo:self.bodyLayoutDict[indexKey]];
    bodyView.top += headView.height;
    [[MFLayoutCenter sharedMFLayoutCenter] layout:footView withSizeInfo:self.footerLayoutDict[indexKey]];
    footView.top += (headView.height+bodyView.height);
}

- (UIView*)sceneViewWithDomId:(NSString*)domId
{
    MFDOM *headDom = [self domWithId:domId withType:MFDomTypeHead];
    UIView *headView = [[MFSceneFactory sharedMFSceneFactory] createUIWithDOM:headDom sizeInfo:nil];
    headView.tag = 1000;

    MFDOM *bodyDom = [self domWithId:domId withType:MFDomTypeBody];
    UIView *bodyView = [[MFSceneFactory sharedMFSceneFactory] createUIWithDOM:bodyDom sizeInfo:nil];
    bodyView.tag = 1001;

    MFDOM *footDom = [self domWithId:domId withType:MFDomTypeFoot];
    UIView *footView = [[MFSceneFactory sharedMFSceneFactory] createUIWithDOM:footDom sizeInfo:nil];
    footView.tag = 1002;

    UIView *sceneView = [[UIView alloc] initWithFrame:CGRectZero];
    sceneView.backgroundColor = [UIColor clearColor]; sceneView.alpha = 1; sceneView.opaque = YES;
    [sceneView addSubview:headView];
    [sceneView addSubview:bodyView];
    [sceneView addSubview:footView];

    return sceneView;
}

- (void)autoLayoutOperations:(NSArray*)dataArray callback:(void(^)(NSInteger prepareHeight))callback
{
    NSInteger retHeight = 0;
    NSArray *datas = self.dataArray;
    self.headerLayoutDict = [[NSMutableDictionary alloc] initWithCapacity:self.dataArray.count];
    self.bodyLayoutDict = [[NSMutableDictionary alloc] initWithCapacity:self.dataArray.count];
    self.footerLayoutDict = [[NSMutableDictionary alloc] initWithCapacity:self.dataArray.count];
    for (int accessIndex=0; accessIndex < datas.count; accessIndex++) {
        NSDictionary *dataDict = [datas objectAtIndex:accessIndex];
        NSString *templateId = [dataDict objectForKey:KEYWORD_TEMPLATE_ID];
        MFDOM *matchHeadDom = [self domWithId:templateId withType:MFDomTypeHead];
        MFDOM *matchDom = [self domWithId:templateId withType:MFDomTypeBody];
        MFDOM *matchFootDom = [self domWithId:templateId withType:MFDomTypeFoot];
        NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)accessIndex];

        CGRect superFrame = CGRectMake(0, 0, [MFHelper screenXY].width, 0);
        NSDictionary *indexPathHeadDict = nil;
        NSDictionary *indexPathDict = nil;
        NSDictionary *indexPathFootDict = nil;
        
        if (matchHeadDom) {
            indexPathHeadDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfDom:matchHeadDom superDomFrame:superFrame dataSource:dataDict];
            [self.headerLayoutDict setObject:indexPathHeadDict forKey:indexKey];
        }
        if (matchDom) {
            indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfDom:matchDom superDomFrame:superFrame dataSource:dataDict];
            [self.bodyLayoutDict setObject:indexPathDict forKey:indexKey];
        }
        if (matchFootDom) {
            indexPathFootDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfDom:matchFootDom superDomFrame:superFrame dataSource:dataDict];
            [self.footerLayoutDict setObject:indexPathFootDict forKey:indexKey];
        }

        retHeight += [[indexPathHeadDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
        retHeight += [[indexPathDict objectForKey:KEY_WIDGET_HEIGHT] intValue];        
        retHeight += [[indexPathFootDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
    }
    callback(retHeight);
}
@end
