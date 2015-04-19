//
//  MFScene.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFDefine.h"

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

@property (nonatomic,copy)NSString              *sceneName;         /*场景名*/
@property (nonatomic,strong)NSMutableArray      *dataArray;         /*场景数据*/
@property (nonatomic,strong)NSMutableDictionary *headerLayoutDict;  /*cell头部布局信息*/
@property (nonatomic,strong)NSMutableDictionary *bodyLayoutDict;    /*cell正文布局信息*/
@property (nonatomic,strong)NSMutableDictionary *footerLayoutDict;  /*cell尾部布局信息*/

/**
 *  创建MFScene实例
 *  @param html         场景对应Html,描述页面结构
 *  @param css          场景对应Css,描述页面样式
 *  @param dataBinding  场景数据绑定规则
 *  @param events       场景html挂载事件集合
 *  @param styles       场景style，目前cell头部和尾部通过style信息描述
 *  @param sceneName    场景名
 */
- (id)initWithDomNodes:(id)html withCss:(NSDictionary*)css withDataBinding:(NSDictionary*)dataBinding withEvents:(NSDictionary*)events withStyles:(NSDictionary*)styles withSceneName:(NSString *)sceneName;

/**
 *  获取Dom节点
 *  @param ID           DOM对应的domId
 *  @param type         dom类型:头部、正文、尾部
 */
- (MFDOM*)domWithId:(NSString*)ID withType:(MFDomType)type;

/**
 *  创建Dom节点对应View
 *  @param domId        DOM对应的domId
 *  @param type         dom类型
 *  @return             view
 */
- (UIView*)sceneViewWithDomId:(NSString*)domId withType:(MFDomType)type;

/**
 *  数据绑定
 *  @param view         View
 *  @param index        对应数据索引
 */
- (void)bind:(UIView *)view withIndex:(NSInteger)index;

/**
 *  页面局部
 *  @param view         View
 *  @param index        对应数据索引
 *  @param alignType    靠左、居中、靠右显示
 */
- (void)layout:(UIView*)view withIndex:(NSInteger)index withAlignmentType:(MFAlignmentType)alignType;

/**
 *  布局信息批量计算
 *  @param dataArray    数据源
 *  @param callback     回调处理,返回布局信息
 */
- (void)autoLayoutOperations:(NSArray*)dataArray callback:(void(^)(NSInteger prepareHeight))callback;

@end
