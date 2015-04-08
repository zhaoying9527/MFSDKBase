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
- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events
{
    if (self = [super init]) {
        NSString *ID = [(HTMLNode*)html getAttributeNamed:KEYWORD_ID];
        self.htmlNodes = html;
        self.cssNodes = css;
        self.bindingField = dataBinding;
        self.eventNodes = events[ID];
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

@end
