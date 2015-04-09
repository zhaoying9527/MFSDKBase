//
//  MFDOM.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFDOM.h"
#import "HTMLNode.h"
#import "MFDefine.h"
#import "MFLabel.h"
#import "MFImageView.h"
#import "MFHelper.h"
#import "MFResourceCenter.h"
#import "UIView+UUID.h"
@interface MFDOM()


@end

@implementation MFDOM
- (id)initWithDomNode:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    if (self = [super init]) {
        self.htmlNodes = html;
        self.cssNodes = css;
        self.bindingField = [dataBinding objectForKey:@"dsKey"];
        self.eventNodes = events;
    }
    return self;
}

- (void)addSubDom:(MFDOM *)subDom
{
    if (nil == self.subDoms) {
        self.subDoms = [NSMutableArray array];
    }

    if (nil != subDom) {
        [self.subDoms addObject:subDom];
    }
}

//双向数据交换
- (void)updateData:(BOOL)flag inDataSource:(NSDictionary*)dataSource;
{
    [self bindingDomToWidget:dataSource];
}

- (void)bindingDomToWidget:(NSDictionary*)dataSource
{
    //绑定数据
    [self bindDataToWidget:self dataSource:dataSource];
    
    for (MFDOM *subDomObj in self.subDoms) {
        if (subDomObj.objReference) {
            [self bindDataToWidget:subDomObj.objReference dataSource:dataSource];
        }
    }
}

- (void)bindDataToWidget:(id)widget dataSource:(NSDictionary*)dataSource
{
    if (nil == dataSource) {
        return;
    }
    NSString *dataValue = dataSource[self.bindingField];
    if ([widget isKindOfClass:[MFLabel class]]) {
         ((MFLabel*)widget).text = dataValue;
    } else if ([widget isKindOfClass:[MFImageView class]]) {
        if ([MFHelper isURLString:dataValue]) {
            //TODO;
        } else {
            UIImage *image = [MFResourceCenter imageNamed:dataValue];
            ((MFImageView*)widget).image = image;
        }
    }
}

- (MFDOM*)findSubDomWithID:(NSString*)ID
{
    if ([[self.htmlNodes getAttributeNamed:KEYWORD_ID] isEqualToString:ID]) {
        return self;
    }
    
    MFDOM *matchDom = nil;
    for (MFDOM *subDom in self.subDoms) {
        matchDom = [subDom findSubDomWithID:ID];
        if (matchDom) {
            return matchDom;
        }
    }
    return matchDom;
}

- (BOOL)isBindingToWidget
{
    
    return YES;
}
@end
