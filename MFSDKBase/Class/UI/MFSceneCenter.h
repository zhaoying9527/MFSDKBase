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
@interface MFSceneCenter : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFSceneCenter)
@property (nonatomic,strong)NSMutableDictionary *scenes;
- (MFScene*)addSceneWithName:(NSString*)sceneName;
- (MFScene*)sceneWithName:(NSString*)sceneName;
- (MFScene*)currentScene;
@end
