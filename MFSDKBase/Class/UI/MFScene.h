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
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableDictionary *layoutDict;
//
- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events withSceneName:(NSString *)sceneName;
//
- (MFDOM*)domWithId:(NSString*)ID;
//
- (NSArray *)domOrders;
//
- (UIView*)sceneViewWithDomId:(NSString*)domId;
//
- (void)bind:(UIView *)view withIndex:(NSInteger)index;
//
- (void)layout:(UIView*)view withIndex:(NSInteger)index;
//
- (void)autoLayoutOperations:(NSArray*)dataArray callback:(void(^)(NSDictionary*prepareLayoutDict,NSInteger prepareHeight))callback;

@end
