//
//  MFSceneCenter.h
//  MFSDK
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFSDK.h"
#import "MFDOM.h"
#import "MFScene.h"

@class HTMLParsers;
@class MFCorePlugInService;
@interface MFSceneCenter : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFSceneCenter)

/**
 *  存活场景集合,K(场景名)－V(场景)
 */
@property (nonatomic,strong)NSMutableDictionary *scenes;

/*返回当前场景堆栈处于栈顶的场景*/
- (MFScene*)currentScene;

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
 *  场景初始化
 */
- (MFScene*)loadSceneWithName:(NSString*)name;

@end
