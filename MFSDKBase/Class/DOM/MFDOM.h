//
//  MFDOM.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  虚拟对象
*/
@class HTMLNode;
@class MFVirtualNode;
@interface MFDOM : NSObject
@property (nonatomic,strong)HTMLNode *htmlNodes;
//布局信息节点
@property (nonatomic,strong)NSDictionary *cssNodes;
//绑定事件节点
@property (nonatomic,strong)NSDictionary *eventNodes;
//绑定字段节点
@property (nonatomic,copy)NSString *bindingField;
//绑定类别
@property (nonatomic,copy)NSString *clsType;
//唯一标示
@property (nonatomic,copy)NSString *uuid;
//扩展信息节点
@property (nonatomic,strong)NSDictionary *params;
//父对象
@property (nonatomic,weak)MFDOM *superDom;
//子对象
@property (nonatomic,strong)NSMutableArray *subDoms;

//创建接口
- (id)initWithDomNode:(HTMLNode*)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events;
- (void)addSubDom:(MFDOM *)subDom;

//查询接口
- (MFDOM*)findSubDomWithID:(NSString*)ID;
//事件触发
- (id)triggerEvent:(NSString*)event withParams:(NSDictionary*)params;
@end
