//
//  MFScene.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  虚拟场景
 */

@class MFDOM;

@interface MFScene : NSObject
@property (nonatomic,strong)NSString *sceneName;
@property (nonatomic,strong)NSMutableDictionary *doms;
//
- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events;
//
- (MFDOM*)findDomWithID:(NSString*)ID;
//
- (UIView*)sceneViewWithDomId:(NSString*)domId;
//
- (void)bind:(UIView*)view withDataSource:(NSDictionary*)dataSource;
//
- (void)layout;

@end