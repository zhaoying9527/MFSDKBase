//
//  MFScene.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFScene.h"
#import <Foundation/Foundation.h>
#import "HTMLNode.h"
#import "HTMLParsers.h"
#import "MFSceneFactory.h"
#import "NSObject+VirtualNode.h"
#import "UIView+UUID.h"
#import "MFDefine.h"
#import "MFDOM.h"
#import "MFVirtualNode.h"
#import "MFSceneFactory.h"
#import "MFDataBinding.h"
#import "MFHelper.h"
#import "MFCell.h"
#import "MFLayoutCenter.h"
#import "UIView+Sizes.h"
@interface MFScene ()
@property (nonatomic,strong)NSMutableDictionary *doms;
@property (nonatomic,strong)NSMutableDictionary *headers;
@property (nonatomic,strong)NSMutableDictionary *footers;

- (void)addDom:(MFDOM *)dom withType:(MFNodeType)type;
@end

@implementation MFScene

- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events withStyles:(NSMutableDictionary*)styles withSceneName:(NSString *)sceneName
{
    if (self = [super init]) {
        self.sceneName = sceneName;
        self.virtualNodes = [[NSMutableArray alloc] init];
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
                [self addDom:header withType:MFNodeTypeHead];
            }
            
            MFDOM *dom = [self loadDom:htmlNode withCss:css withDataBinding:dataBinding withEvents:events];
            if (dom && dom.uuid) {
                [self addDom:dom withType:MFNodeTypeBody];
            }
            
            MFDOM *footer = [self loadFooter:htmlNode withCss:css withDataBinding:dataBinding withEvents:events withStyles:styles];
            if (footer && footer.uuid) {
                [self addDom:footer withType:MFNodeTypeFoot];
            }
        }
    }
    return self;
}

- (void)addDom:(MFDOM *)dom withType:(MFNodeType)type
{
    if (MFNodeTypeHead == type) {
        [self.headers setObject:dom forKey:dom.uuid];
    }
    else if (MFNodeTypeBody == type) {
        [self.doms setObject:dom forKey:dom.uuid];
    }
    else if (MFNodeTypeFoot == type) {
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

- (MFDOM*)domWithId:(NSString*)ID withType:(MFNodeType)type
{
    if (MFNodeTypeBody == type) {
        return self.doms[ID];
    }
    else if (MFNodeTypeHead == type) {
        return self.headers[ID];
    }
    else if (MFNodeTypeFoot == type) {
        return self.footers[ID];
    }
    return nil;
}

- (MFVirtualNode*)virtualNodeWithId:(NSString*)ID
                         dataSource:(NSDictionary*)dataSource
                           withType:(MFNodeType)type
{
    MFDOM *dom = [self domWithId:ID withType:type];
    MFVirtualNode *virtualNode = [[MFVirtualNode alloc] initWithDom:dom dataSource:dataSource];
    return virtualNode;
}

- (CGFloat)cellHeightWithIndex:(NSInteger)index
{
    CGFloat totalHeight = 0.0f;
 
    NSDictionary *virtualNodes = self.virtualNodes[index];
    MFVirtualNode *headVirtualNode = virtualNodes[kMFVirtualHeadNode];
    MFVirtualNode *bodyVirtualNode = virtualNodes[kMFVirtualBodyNode];
    MFVirtualNode *footVirtualNode = virtualNodes[kMFVirtualFootNode];
    
    CGFloat height = headVirtualNode.widgetSize.height;
    totalHeight += height > 0 ? height+[MFHelper cellHeaderHeight] : 0;
    height = bodyVirtualNode.widgetSize.height;
    totalHeight += height + [MFHelper sectionHeight];
    height = footVirtualNode.widgetSize.height;
    totalHeight += height > 0 ? height+[MFHelper cellFooterHeight] : 0;
    return totalHeight;
}

- (MFCell*)buildUIWithTableView:(UITableView*)tableView className:(NSString*)name index:(NSInteger)index
{
    NSDictionary *dataDict = self.dataArray[index];
    NSString *tId = [self templateIdWithData:dataDict];
    NSString *identifier = [NSString stringWithFormat:@"%@",tId];
    
    MFCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(name) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (![cell.tId isEqualToString:tId]) {
        cell.tId = tId;
        if (index < self.virtualNodes.count) {
            [cell.contentView removeAllSubviews];
            
            UIView *sceneHeadCanvas = [(MFVirtualNode*)(self.virtualNodes[index][kMFVirtualHeadNode]) create];
            sceneHeadCanvas.tag = 1000;
            if (nil != sceneHeadCanvas) {
                [cell.contentView addSubview:sceneHeadCanvas];
            }

            UIView *sceneBodyCanvas = [(MFVirtualNode*)(self.virtualNodes[index][kMFVirtualBodyNode]) create];
            sceneBodyCanvas.tag = 1001;
            if (nil != sceneBodyCanvas) {
                [cell.contentView addSubview:sceneBodyCanvas];
            }

            UIView *sceneFootCanvas = [(MFVirtualNode*)(self.virtualNodes[index][kMFVirtualFootNode]) create];
            sceneFootCanvas.tag = 1002;
            if (nil != sceneFootCanvas) {
                [cell.contentView addSubview:sceneFootCanvas];
            }
        }
    }
    cell.dataItem = dataDict;

    return cell;
}

- (void)layout:(MFCell*)cell
{
    UIView *headView = [cell.contentView viewWithTag:1000];
    [headView.virtualNode layout];

    UIView *bodyView = [cell.contentView viewWithTag:1001];
    [bodyView.virtualNode layout];
    bodyView.top += headView.height > 0 ? headView.height+[MFHelper cellHeaderHeight] : 0;

    UIView *footView = [cell.contentView viewWithTag:1003];
    [footView.virtualNode layout];
    footView.top += headView.height > 0 ? headView.height+[MFHelper cellHeaderHeight] : 0;
    footView.top += bodyView.height + [MFHelper sectionHeight];

    MFAlignmentType alignType = (MFAlignmentType)[cell.dataItem[KEY_WIDGET_ALIGNMENTTYPE] integerValue];
    [[MFLayoutCenter sharedMFLayoutCenter] sideSubViews:bodyView.virtualNode withAlignmentType:alignType];
    [[MFLayoutCenter sharedMFLayoutCenter] reverseSubViews:bodyView.virtualNode];
}

- (void)bindData:(MFCell*)cell
{
    for (UIView *subView in cell.contentView.subviews) {
        [subView.virtualNode bindData];
    }
}

- (void)calculateLayoutInfo:(NSArray*)dataArray callback:(void(^)(NSArray *virtualNodes))callback
{
    NSMutableArray *virtualNodes = [NSMutableArray arrayWithCapacity:dataArray.count];
    NSInteger retHeight = 0;
                       
    for (int accessIndex=0; accessIndex < dataArray.count; accessIndex++) {
        NSDictionary *dataDict = [dataArray objectAtIndex:accessIndex];
        NSString *templateId = [self templateIdWithData:dataDict];
        if (![self matchingTemplate:templateId]) {
            templateId = DIALOG_TEMPLATE_UNKNOW;
        }
        
        MFVirtualNode *virtualHeadNode = [self virtualNodeWithId:templateId dataSource:dataDict withType:MFNodeTypeHead];
        MFVirtualNode *virtualBodyNode = [self virtualNodeWithId:templateId dataSource:dataDict withType:MFNodeTypeBody];
        MFVirtualNode *virtualFootNode = [self virtualNodeWithId:templateId dataSource:dataDict withType:MFNodeTypeFoot];
        
        [virtualNodes addObject:@{kMFVirtualHeadNode:virtualHeadNode, kMFVirtualBodyNode:virtualBodyNode,
                                  kMFVirtualFootNode:virtualFootNode}];
        
        CGRect superFrame = CGRectMake(0, 0, [MFHelper screenXY].width, 0);
        NSDictionary *indexPathHeadDict = nil;
        NSDictionary *indexPathDict = nil;
        NSDictionary *indexPathFootDict = nil;
        
        if (virtualHeadNode) {
            indexPathHeadDict = [virtualHeadNode sizeOfHeadWithSuperFrame:superFrame];
        }
        if (virtualBodyNode) {
            indexPathDict = [virtualBodyNode sizeOfBodyWithSuperFrame:superFrame];
        }
        if (virtualFootNode) {
            indexPathFootDict = [virtualFootNode sizeOfFootWithSuperFrame:superFrame];
        }
        
        retHeight += [[indexPathHeadDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
        retHeight += [[indexPathDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
        retHeight += [[indexPathFootDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
    }

    callback(virtualNodes);
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
    //TODO
    NSString *seed = [data[KEYWORD_DS_DATA] objectForKey:KEYWORD_SEED];
    return seed ? seed : data[KEYWORD_SEED];
}

- (BOOL)matchingTemplate:(NSString*)tId
{
    BOOL retCode = NO;
    if (nil != [self domWithId:tId withType:MFNodeTypeBody]) {
        retCode = YES;
    }
    return retCode;
}

+ (UIView*)findViewWithDomClass:(NSString*)domClass withView:(UIView*)view
{
    MFDOM *dom = view.virtualNode.dom;
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
        NSInteger index = [self.dataArray indexOfObject:data[i]];
        [self.dataArray removeObject:data[i]];
        [self.virtualNodes removeObjectAtIndex:index];
    }
}

- (void)removeAll
{
    [self.dataArray removeAllObjects];
    [self.virtualNodes removeAllObjects];
}

- (MFViewController*)sceneViewControllerWithData:(NSArray*)data
                                dataAdapterBlock:(MFDataAdapterBlock)dataAdapterBlock
{
    [self removeAll];
    [self setAdapterBlock:dataAdapterBlock];
    [self setDataArray:[NSMutableArray arrayWithArray:data]];
    __weak typeof (self) wSelf = self;    
    [self calculateLayoutInfo:self.dataArray callback:^(NSArray *virtualNodes) {
        wSelf.virtualNodes = [NSMutableArray arrayWithArray:virtualNodes];
    }];
    MFViewController *vc = [[MFViewController alloc] initWithNibName:nil bundle:nil];
    vc.scene = self; vc.sceneName = self.sceneName;
    return vc;
}

- (void)sceneViewController:(MFViewController*)viewcontroller ReloadData:(NSArray*)data
{
    [self removeAll];
    [self setDataArray:[NSMutableArray arrayWithArray:data]];
    [self calculateLayoutInfo:self.dataArray callback:^(NSArray *virtualNodes) {}];
    [viewcontroller.tableView reloadData];
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
