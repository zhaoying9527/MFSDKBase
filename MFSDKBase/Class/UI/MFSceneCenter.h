//
//  MFSceneCenter.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFSDK.h"
#import "MFDOM.h"
#import "MFScene.h"
@class HTMLParser;
@class MFCorePlugInService;
@interface MFSceneCenter : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFSceneCenter)

/**
 *  存活场景集合K,(场景名)－V(场景)
 */
@property (nonatomic,strong)NSMutableDictionary *scenes;

/**
 *  当前栈顶活跃场景
 */
- (MFScene*)currentScene;

/**
 *  查找特定场景
 *  @param sceneName     场景名
 *  @param return        场景
 */
- (MFScene*)sceneWithName:(NSString*)sceneName;

/**
 *  场景创建
 *  @param sceneName     场景名
 *  @param return        场景
 */
- (MFScene*)loadSceneWithName:(NSString*)sceneName;

/**
 *  场景释放,当页面释放时,需要释放对应场景
 *  @param sceneName     场景名
 */
- (void)releaseSceneWithName:(NSString*)sceneName;

/**
 *  场景注册, 页面显示后需要在场景堆栈中注册对应场景
 *  @param scene         场景
 *  @param sceneName     场景名
 */
- (void)registerScene:(MFScene*)scene withName:(NSString*)sceneName;

/**
 *  场景注销, 页面隐藏后需要在场景堆栈中需要注销对应场景
 *  @param scene         场景
 *  @param sceneName     场景名
 */
- (BOOL)unRegisterScene:(NSString*)sceneName;

/**
 *  获取插件服务
 */
- (MFCorePlugInService*)pluginService;
@end
