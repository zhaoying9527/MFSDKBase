//
//  AppDelegate.m
//  MFSDKBase
//
//  Created by 李春荣 on 15/4/4.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "AppDelegate.h"
#import "MFViewController.h"
#import "MFSDKLauncher.h"
#import "MFWindowsStyleManager.h"
@interface AppDelegate ()
@property (nonatomic, strong) MFScene *scene;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect frame = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:frame];
    [self.window setBackgroundColor:[UIColor blackColor]];
    
    //初始化环境
    [MFSDKLauncher initialize];
    
    self.scene = [[MFSceneCenter sharedMFSceneCenter] loadSceneWithName:@"MFChat"];
    MFViewController *vc = [self.scene sceneViewControllerWithData:nil dataAdapterBlock:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window setRootViewController:navController];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
