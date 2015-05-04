//
//  MFScene+Internal.h
//  MFSDK
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFScene.h"

@interface MFScene ()
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
 *  @return             创建的view
 */
- (UIView*)sceneViewWithDomId:(NSString*)domId withType:(MFDomType)type;

/**
 *  数据绑定
 *  @param view         View
 *  @param data         数据源
 */
- (void)bind:(UIView *)view withData:(NSDictionary*)data;

/**
 *  页面布局
 *  @param view         View
 *  @param data         数据源
 */
- (void)layout:(UIView*)view withData:(NSDictionary*)data;

@end
