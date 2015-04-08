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
@interface MFDOM()


@end

@implementation MFDOM
- (id)initWithDomNode:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    if (self = [super init]) {
        self.htmlNodes = html;
        self.cssNodes = css;
        self.bindingField = dataBinding;
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
- (void)updateDate:(BOOL)flag
{
    
}

- (MFDOM*)findSubDomWithID:(NSString*)ID
{
    if ([[self.htmlNodes getAttributeNamed:KEYWORD_ID] isEqualToString:ID]) {
        return self;
    }
    
    MFDOM *matchDom = nil;
    for (MFDOM *subDom in self.subDoms) {
        matchDom = [self findSubDomWithID:ID];
        if (matchDom) {
            return matchDom;
        }
    }
    return matchDom;
}

@end
