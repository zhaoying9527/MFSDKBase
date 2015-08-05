//
//  MFSceneCenter.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFSceneCenter.h"
#import "MFCorePlugInService.h"
#import "MFScene+Internal.h"
#import "MFSceneFactory.h"
#import "MFHTMLParser.h"
#import "MFCssParser.h"
#import "MFLuaScript.h"
#import "MFDefine.h"
#import "MFDOM.h"
#import "MFWindowsStyleManager.h"

@interface MFSceneCenter ()
@property (nonatomic, copy) NSString *currentSceneName;
@property (nonatomic, strong)NSMutableDictionary *htmlParsers;
@end

@implementation MFSceneCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFSceneCenter)

- (instancetype)init
{
    if (self = [super init]) {
        self.scenes = [NSMutableDictionary dictionary];
        self.htmlParsers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerScene:(MFScene*)scene withName:(NSString*)sceneName
{
    self.currentSceneName = sceneName;
    if (nil != scene && nil != sceneName) {
        [self.scenes setObject:scene forKey:sceneName];
    }
}

- (BOOL)unRegisterScene:(NSString*)sceneName
{
    MFScene *scence = [self.scenes objectForKey:sceneName];
    if (nil != scence) {
        [self.scenes removeObjectForKey:sceneName];
    }
    
    return (nil != scence);
}

- (MFScene*)sceneWithName:(NSString*)sceneName
{
    return [self.scenes objectForKey:sceneName];
}

- (MFScene*)currentScene
{
    return [self.scenes objectForKey:self.currentSceneName];
}

- (void)releaseSceneWithName:(NSString*)sceneName
{
    [self.htmlParsers removeObjectForKey:sceneName];
    MFScene *scene = [self sceneWithName:sceneName];
    [scene removeAll];
}

- (MFScene*)loadSceneWithName:(NSString*)sceneName
{
    MFWindowsStyleManager *styleMgr = [MFWindowsStyleManager sharedMFWindowsStyleManager];
    MFScene *resultScene = [[MFScene alloc] initWithDomNodes:styleMgr.bodyEntity withCss:styleMgr.css withDataBinding:styleMgr.databinding withEvents:styleMgr.events withStyles:styleMgr.style withSceneName:sceneName];
    return resultScene;
}

@end
