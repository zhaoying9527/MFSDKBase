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
@property (nonatomic,strong)NSMutableDictionary *scenes;
- (MFScene*)currentScene;
- (MFScene*)sceneWithName:(NSString*)sceneName;
- (MFScene*)loadSceneWithName:(NSString*)sceneName;
- (void)releaseHtmlParserWithName:(NSString*)sceneName;

- (void)registerScene:(MFScene*)scene withName:(NSString*)sceneName;
- (BOOL)unRegisterScene:(NSString*)sceneName;

- (MFCorePlugInService*)pluginService;
@end
