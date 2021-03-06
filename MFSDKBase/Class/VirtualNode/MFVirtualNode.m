//
//  MFVirtualNode.m
//  MFSDKBase
//
//  Created by 李春荣 on 15/7/30.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFVirtualNode.h"
#import "MFLayoutCenter.h"
#import "MFDataBinding.h"
#import "MFSceneFactory.h"
#import "NSObject+VirtualNode.h"

@implementation MFVirtualNode

- (instancetype)initWithDom:(MFDOM*)dom dataSource:(NSDictionary*)dataSource
{
    if (self = [super init]) {
        [self setupWithDom:dom dataSource:dataSource];
    }
    return self;
}

- (MFVirtualNode*)setupWithDom:(MFDOM*)dom dataSource:(NSDictionary*)dataSource
{
    id data = dataSource[dom.bindingField];
    self.data = data;
    self.dom = dom;
    self.fullData = dataSource;
    self.subNodes = [NSMutableArray array];

    for (MFDOM *subDom in dom.subDoms) {
        MFVirtualNode *subNode = [[MFVirtualNode alloc] initWithDom:subDom dataSource:dataSource];
        if (subNode) {
            subNode.superNode = self;
            [self.subNodes addObject:subNode];
        }
    }

    return self;
}

- (NSDictionary*)sizeOfHeadWithSuperFrame:(CGRect)superFrame
{
    NSDictionary *indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfHeadNode:self superFrame:superFrame dataSource:self.fullData];
    return indexPathDict;
}

- (NSDictionary*)sizeOfBodyWithSuperFrame:(CGRect)superFrame
{
    NSDictionary *indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfBodyNode:self superFrame:superFrame dataSource:self.fullData];
    return indexPathDict;
}

- (NSDictionary*)sizeOfFootWithSuperFrame:(CGRect)superFrame
{
    NSDictionary *indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfFootNode:self superFrame:superFrame dataSource:self.fullData];
    return indexPathDict;
}

- (UIView*)create
{
    UIView *widget = [[MFSceneFactory sharedMFSceneFactory] createWidgetWithNode:self];
    [widget attachVirtualNode:self];
    self.objRef = widget;
    
    for (MFVirtualNode *subNode in self.subNodes) {
        UIView *subWidget = [subNode create];
        if (subWidget) {
            [widget addSubview:subWidget];
        }
    }
    
    return widget;
}

- (void)layout
{
    [[MFLayoutCenter sharedMFLayoutCenter] layout:self];
}

- (void)bindData
{
    [MFDataBinding bind:self];
}

- (void)update
{
    [[MFLayoutCenter sharedMFLayoutCenter] layout:self];
    [MFDataBinding bind:self];    
}

- (id)triggerEvent:(NSString*)event withParams:(NSDictionary*)params
{
    return [self.dom triggerEvent:event withParams:params];
}
@end
