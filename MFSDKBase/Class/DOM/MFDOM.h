//
//  MFDOM.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  虚拟场景对象
*/

@interface MFDOM : NSObject
//绑定对象
@property (nonatomic,strong)id objReference;
//绑定类别
@property (nonatomic,strong)NSString *typeString;
//扩展信息节点
@property (nonatomic,strong)NSDictionary *params;
//创建接口
- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding;
//双向数据交换
- (void)updateDate:(BOOL)flag;
@end
