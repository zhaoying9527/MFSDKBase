//
//  MFDOM.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFDOM.h"
@interface MFDOM()
@property (nonatomic,strong)NSDictionary *htmlNodes;
//布局信息节点
@property (nonatomic,strong)NSDictionary *cssNodes;
//绑定事件节点
@property (nonatomic,strong)NSDictionary *eventNodes;
//绑定字段节点
@property (nonatomic,strong)NSDictionary *dataNodes;


@end

@implementation MFDOM
- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding
{
    if (self = [super init]) {
        self.dataNodes = dataBinding;
        self.htmlNodes = html;
        self.cssNodes = css;
    }
    return self;
}

//双向数据交换
- (void)updateDate:(BOOL)flag
{
    
}

@end
