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

    
    NSString *bundlePath = [[NSString alloc] initWithFormat:@"%@/%@",[MFHelper getResourcePath],[MFHelper getBundleName]];
    NSString *dataSourcePath = [NSString stringWithFormat:@"%@/%@.plist", bundlePath, @"MFChat"];
    NSDictionary *dataSource = [[NSDictionary alloc] initWithContentsOfFile:dataSourcePath];
    NSArray *dataArray = [dataSource objectForKey:@"data"];    
    
    //初始化环境
    [MFSDKLauncher initialize];
    
    self.scene = [[MFSceneCenter sharedMFSceneCenter] loadSceneWithName:@"MFChat"];
    [self.scene sceneViewControllerReloadData:dataArray dataAdapterBlock:nil completionBlock:^(MFViewController *viewControler) {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewControler];
        [self.window setRootViewController:navController];
        [self.window makeKeyAndVisible];
        [viewControler.tableView reloadData];
    }];
    

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
