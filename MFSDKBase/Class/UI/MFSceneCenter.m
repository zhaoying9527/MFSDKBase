//
//  MFSceneCenter.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFSceneCenter.h"
#import "MFCorePlugInService.h"
@implementation MFSceneCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFSceneCenter)
- (void)initSceneWithName:(NSString*)sceneName
{
    /*
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html", bundlePath, scriptName];
    NSString *cssPath = [NSString stringWithFormat:@"%@/%@.css", bundlePath, scriptName];
    NSString *dataBindingPath = [NSString stringWithFormat:@"%@/%@.dataBinding", bundlePath, scriptName];
    

    NSError *error = nil;
    self.scriptName = scriptName;
    self.html = [[HTMLParser alloc] initWithString:[NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error] error:&error];
    self.css = [[[ESCssParser alloc] init] parseText:[NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:&error]];
    self.dataBindings = [[[ESCssParser alloc] init] parseText:[NSString stringWithContentsOfFile:dataBindingPath encoding:NSUTF8StringEncoding error:&error]];
    //        [[MFBridge sharedMFBridge] configWithScriptName:[NSString stringWithFormat:@"%@.lua", scriptName]];*/
}
@end
