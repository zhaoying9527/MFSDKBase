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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    CGRect frame = [UIScreen mainScreen].bounds;
    self.window = [[UIWindow alloc] initWithFrame:frame];
    [self.window setBackgroundColor:[UIColor orangeColor]];
    //初始化环境
    [MFSDKLauncher initialize];
    
    UIViewController *viewController = [[MFViewController alloc] initWithSceneName:@"Master"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
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
