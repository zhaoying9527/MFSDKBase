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

typedef enum {
    MFDomTypeBody = 0,
    MFDomTypeHead = 1,
    MFDomTypeFoot = 2,
} MFDomType;

@class MFDOM;

@interface MFScene : NSObject
@property (nonatomic,strong)NSString *sceneName;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableDictionary *headerLayoutDict;
@property (nonatomic,strong)NSMutableDictionary *bodyLayoutDict;
@property (nonatomic,strong)NSMutableDictionary *footerLayoutDict;

//
- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events withStyles:(NSDictionary*)styles withSceneName:(NSString *)sceneName;
//
- (MFDOM*)domWithId:(NSString*)ID withType:(MFDomType)type;
//
- (NSArray *)domOrders;
//
- (UIView*)sceneViewWithDomId:(NSString*)domId withType:(MFDomType)type;
//
- (void)bind:(UIView *)view withIndex:(NSInteger)index;
//
- (void)layout:(UIView*)view withIndex:(NSInteger)index;
//
- (void)autoLayoutOperations:(NSArray*)dataArray callback:(void(^)(NSInteger prepareHeight))callback;

@end
