//
//  MFScene.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFScene.h"
#import "HTMLNode.h"
#import "HTMLParsers.h"
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
        self.headerLayoutDict = [[NSMutableDictionary alloc] init];
        self.bodyLayoutDict = [[NSMutableDictionary alloc] init];
        self.footerLayoutDict = [[NSMutableDictionary alloc] init];
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
            childDom.superDom = dom;
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

- (void)bind:(UIView *)view withData:(NSDictionary*)data
{
    if (view.subviews.count <= 0) {
        return;
    }
    
    for (UIView *subView in view.subviews) {
        [MFDataBinding bind:subView withDataSource:data];
    }
}

- (void)layout:(UIView*)view withData:(NSDictionary*)data
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
    
    NSString *indexKey = [self privateKeyWithData:data];
    [[MFLayoutCenter sharedMFLayoutCenter] layout:headView withSizeInfo:self.headerLayoutDict[indexKey]];
    [[MFLayoutCenter sharedMFLayoutCenter] layout:bodyView withSizeInfo:self.bodyLayoutDict[indexKey]];
    bodyView.top += headView.height > 0 ? headView.height+[MFHelper cellHeaderHeight] : 0;
    
    [[MFLayoutCenter sharedMFLayoutCenter] layout:footView withSizeInfo:self.footerLayoutDict[indexKey]];
    footView.top += headView.height > 0 ? headView.height+[MFHelper cellHeaderHeight] : 0;
    footView.top += bodyView.height + [MFHelper sectionHeight];
    
    MFAlignmentType alignType = (MFAlignmentType)[[data objectForKey:KEY_WIDGET_ALIGNMENTTYPE] integerValue];
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

- (void)calculateLayoutInfo:(NSArray*)dataArray callback:(void(^)(NSInteger prepareHeight))callback
{
    NSInteger retHeight = 0;
    for (int accessIndex=0; accessIndex < dataArray.count; accessIndex++) {
        NSDictionary *dataDict = [dataArray objectAtIndex:accessIndex];
        NSString *templateId = [self templateIdWithData:dataDict];
        if (![self matchingTemplate:templateId]) {
            templateId = DIALOG_TEMPLATE_UNKNOW;
        }
        MFDOM *matchHeadDom = [self domWithId:templateId withType:MFDomTypeHead];
        MFDOM *matchBodyDom = [self domWithId:templateId withType:MFDomTypeBody];
        MFDOM *matchFootDom = [self domWithId:templateId withType:MFDomTypeFoot];
        NSString *indexKey = [self privateKeyWithData:dataDict];
        
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

- (NSString*)templateIdWithData:(NSDictionary*)data
{
    NSString *Id = data[KEYWORD_ID];
    if (![Id hasPrefix:@"tid-"]) {
        Id = [@"tid-" stringByAppendingString:Id];
    }
    return Id;
}

- (NSString*)privateKeyWithData:(NSDictionary*)data
{
    NSInteger index = [self.dataArray indexOfObject:data];
    NSString *seed = [[data objectForKey:KEYWORD_DS_DATA] objectForKey:KEYWORD_SEED];
    return seed ? seed : [NSString stringWithFormat:@"%ld", (long)index];
}

- (BOOL)matchingTemplate:(NSString*)tId
{
    BOOL retCode = NO;
    if (nil != [self domWithId:tId withType:MFDomTypeBody]) {
        retCode = YES;
    }
    return retCode;
}

+ (UIView*)findViewWithDomClass:(NSString*)domClass withView:(UIView*)view
{
    MFDOM *dom = view.DOM;
    NSString *class = [dom.htmlNodes getAttributeNamed:@"class"];
    if ([class isEqualToString:domClass]) {
        return view;
    }
    
    for (UIView *subView in view.subviews) {
        UIView *retView = [self findViewWithDomClass:domClass withView:subView];
        if (retView) {
            return retView;
        }
    }
    return nil;
}

- (void)removeData:(NSArray*)data
{
    for (NSInteger i=data.count-1 ; i >= 0; i--) {
        NSString *indexKey = [self privateKeyWithData:data[i]];
        
        [self.headerLayoutDict removeObjectForKey:indexKey];
        [self.bodyLayoutDict removeObjectForKey:indexKey];
        [self.footerLayoutDict removeObjectForKey:indexKey];
        
        [self.dataArray removeObject:data[i]];
    }
}

- (void)removeAll
{
    [self.headerLayoutDict removeAllObjects];
    [self.bodyLayoutDict removeAllObjects];
    [self.footerLayoutDict removeAllObjects];
    [self.dataArray removeAllObjects];
}

- (CGSize)sceneViewSizeWithData:(NSDictionary*)data
{
    NSString *indexKey = [self privateKeyWithData:data];
    CGFloat height = [self.headerLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    height += [self.bodyLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    height += [self.footerLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    
    CGFloat width = [self.headerLayoutDict[indexKey][KEY_WIDGET_WIDTH] intValue];
    width = MAX(width, [self.bodyLayoutDict[indexKey][KEY_WIDGET_WIDTH] intValue]);
    width = MAX(width, [self.footerLayoutDict[indexKey][KEY_WIDGET_WIDTH] intValue]);
    
    return CGSizeMake(width, height);
}

- (UIView*)buildSceneViewWithData:(NSDictionary*)data
{
    NSString *tId = [self templateIdWithData:data];
    CGSize size = [self sceneViewSizeWithData:data];
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    UIView *sceneHeadCanvas = [self sceneViewWithDomId:tId withType:MFDomTypeHead];
    UIView *sceneBodyCanvas = [self sceneViewWithDomId:tId withType:MFDomTypeBody];
    UIView *sceneFootCanvas = [self sceneViewWithDomId:tId withType:MFDomTypeFoot];
    if (nil != sceneHeadCanvas) {
        [containerView addSubview:sceneHeadCanvas];
    }
    if (nil != sceneBodyCanvas) {
        [containerView addSubview:sceneBodyCanvas];
    }
    if (nil != sceneFootCanvas) {
        [containerView addSubview:sceneFootCanvas];
    }
    
    [self layout:containerView withData:data];
    [self bind:containerView withData:data];
    
    return containerView;
}

- (void)sceneViewReloadData:(NSDictionary*)data
           dataAdapterBlock:(MFDataAdapterBlock)dataAdapterBlock
            completionBlock:(void(^)(UIView*view))completionBlock
{
    [self removeAll];
    [self setAdapterBlock:dataAdapterBlock];
    [self setDataArray:[NSMutableArray arrayWithObject:data]];
    [self calculateLayoutInfo:@[data] callback:^(NSInteger prepareHeight) {
        UIView *view = [self buildSceneViewWithData:data];
        completionBlock(view);
    }];
}

- (void)sceneViewControllerReloadData:(NSArray*)data
                     dataAdapterBlock:(MFDataAdapterBlock)dataAdapterBlock
                      completionBlock:(void(^)(MFViewController*viewControler))completionBlock
{
    [self removeAll];
    [self setAdapterBlock:dataAdapterBlock];
    [self setDataArray:[NSMutableArray arrayWithArray:data]];
    [self calculateLayoutInfo:data callback:^(NSInteger prepareHeight) {
        MFViewController *vc = [[MFViewController alloc] initWithNibName:nil bundle:nil];
        vc.scene = self;
        vc.sceneName = self.sceneName;
        completionBlock(vc);
    }];
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (self.adapterBlock) {
        _dataArray = self.adapterBlock(dataArray);
    }else {
        _dataArray = dataArray;
    }
}
@end
