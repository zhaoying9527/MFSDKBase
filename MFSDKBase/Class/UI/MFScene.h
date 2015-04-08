//
//  MFScene.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  虚拟场景
 */

@class MFDOM;

@interface MFScene : NSObject
@property (nonatomic, strong) MFDOM *dom;

- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events;

@end