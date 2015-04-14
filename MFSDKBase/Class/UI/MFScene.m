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
            if (![[MFSceneFactory sharedMFSceneFactory] supportHtmlTag:htmlNode.tagName]) {
                continue;
            }
            
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
    return self;
}

- (void)addDom:(MFDOM *)dom withType:(MFDomType)type
{
    if (MFDomTypeHead == type) {
        [self.headers setObject:dom forKey:dom.uuid];
    }
    else if (MFDomTypeBody == type) {
        [self.doms setObject:dom forKey:dom.uuid];
    }
    else if (MFDomTypeFoot == type) {
        [self.footers setObject:dom forKey:dom.uuid];
    }
}

- (MFDOM*)loadDom:(HTMLNode*)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    HTMLNode *htmlNode = (HTMLNode*)html;
    NSString *uid = [htmlNode getAttributeNamed:KEYWORD_ID];
    MFDOM *dom = [[MFDOM alloc] initWithDomNode:htmlNode withCss:css[uid] withDataBinding:dataBinding[uid] withEvents:events[uid]];

    [[htmlNode children] enumerateObjectsUsingBlock:^(HTMLNode *childNode, NSUInteger idx, BOOL *stop) {
        if (nil != [childNode getAttributeNamed:KEYWORD_ID]) {
            MFDOM *childDom = [self loadDom:childNode withCss:css withDataBinding:dataBinding withEvents:events];
            [dom addSubDom:childDom];
        }
    }];

    return dom;
}

- (MFDOM*)loadHeader:(HTMLNode*)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events withStyles:(NSMutableDictionary*)styles
{
    HTMLNode *htmlNode = (HTMLNode*)html;
    NSString *uid = [htmlNode getAttributeNamed:KEYWORD_ID];
    if (!styles[uid]) {
        return nil;
    }

    //该Dom上有header
    MFDOM *header = nil;
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
    HTMLNode *htmlNode = (HTMLNode*)html;
    NSString *uid = [htmlNode getAttributeNamed:KEYWORD_ID];
    if (!styles[uid]) {
        return nil;
    }
    
    //该Dom上有footer
    MFDOM *footer = nil;
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
    }
    else if (MFDomTypeHead == type) {
        return self.headers[ID];
    }
    else if (MFDomTypeFoot == type) {
        return self.footers[ID];
    }
    return nil;
}

- (void)bind:(UIView *)view withIndex:(NSInteger)index
{
    if (view.subviews.count <= 0) {
        return;
    }

    for (UIView *subView in view.subviews) {
        [MFDataBinding bind:subView withDataSource:self.dataArray[index]];
    }
}

- (void)layout:(UIView*)view withIndex:(NSInteger)index withAlignmentType:(MFAlignmentType)alignType
{
    if (view.subviews.count <= 0) {
        return;
    }

    UIView *headView = nil; UIView *bodyView = nil; UIView *footView = nil;
    for (UIView *subView in view.subviews) {
        if (1000 == subView.tag) {
            headView = subView;
        }
        else if (1001 == subView.tag) {
            bodyView = subView;
        }
        else if (1002 == subView.tag) {
            footView = subView;
        }
    }

    NSString *indexKey = [NSString stringWithFormat:@"%ld",(long)index];
    [[MFLayoutCenter sharedMFLayoutCenter] layout:headView withSizeInfo:self.headerLayoutDict[indexKey]];
    [[MFLayoutCenter sharedMFLayoutCenter] layout:bodyView withSizeInfo:self.bodyLayoutDict[indexKey]];
    bodyView.top += headView.height;
    [[MFLayoutCenter sharedMFLayoutCenter] layout:footView withSizeInfo:self.footerLayoutDict[indexKey]];
    footView.top += (headView.height+bodyView.height);
    
    [[MFLayoutCenter sharedMFLayoutCenter] sideSubViews:bodyView withSizeInfo:self.bodyLayoutDict[indexKey] withAlignmentType:alignType];
    [[MFLayoutCenter sharedMFLayoutCenter] reverseSubViews:bodyView withSizeInfo:self.bodyLayoutDict[indexKey]];    
}

- (UIView*)sceneViewWithDomId:(NSString*)domId withType:(MFDomType)type
{
    MFDOM *dom =  [self domWithId:domId withType:type];
    UIView *view = [[MFSceneFactory sharedMFSceneFactory] createUIWithDOM:dom sizeInfo:nil];
    view.tag = (MFDomTypeHead == type) ? 1000 : (MFDomTypeBody == type ? 1001 : 1002);
    return view;
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
        MFDOM *matchBodyDom = [self domWithId:templateId withType:MFDomTypeBody];
        MFDOM *matchFootDom = [self domWithId:templateId withType:MFDomTypeFoot];
        NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)accessIndex];

        CGRect superFrame = CGRectMake(0, 0, [MFHelper screenXY].width, 0);
        NSDictionary *indexPathHeadDict = nil;
        NSDictionary *indexPathDict = nil;
        NSDictionary *indexPathFootDict = nil;
        
        if (matchHeadDom) {
            indexPathHeadDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfHeadDom:matchHeadDom superDomFrame:superFrame dataSource:dataDict];
            [self.headerLayoutDict setObject:indexPathHeadDict forKey:indexKey];
        }
        if (matchBodyDom) {
            indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfBodyDom:matchBodyDom superDomFrame:superFrame dataSource:dataDict];
            [self.bodyLayoutDict setObject:indexPathDict forKey:indexKey];
        }
        if (matchFootDom) {
            indexPathFootDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfFootDom:matchFootDom superDomFrame:superFrame dataSource:dataDict];
            [self.footerLayoutDict setObject:indexPathFootDict forKey:indexKey];
        }

        retHeight += [[indexPathHeadDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
        retHeight += [[indexPathDict objectForKey:KEY_WIDGET_HEIGHT] intValue];        
        retHeight += [[indexPathFootDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
    }
    callback(retHeight);
}
@end
