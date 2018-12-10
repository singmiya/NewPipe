//
//  AppDelegate.m
//  NewPipe
//
//  Created by Somiya on 2018/10/14.
//  Copyright © 2018 Somiya. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "ZJDrawerController.h"
#import "SettingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 初始化数据库
    [MagicalRecord setupAutoMigratingCoreDataStack];
    MainTabController *mainTab = [[MainTabController alloc] init];
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    self.drawer = [[ZJDrawerController alloc] initWithLeftController:settingVC centerController:mainTab rightController:nil];
    // 背景图片
    self.drawer.backgroundImage = [UIImage imageNamed:@"bg"];
    // 动画类型
    self.drawer.drawerControllerStyle = ZJDrawerControllerStyleScale;
    // 任何界面都能打开抽屉
    self.drawer.canOpenDrawerAtAnyPage = YES;
    self.drawer.maxLeftControllerWidth = 250;
    self.window.rootViewController  = self.drawer;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];

    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 只有打开应用的时候才出现
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            [self.drawer openLeftDrawerAnimated:NO finishHandler:nil];
//        });
        // 应用从后台进入到前台都出现
        [self.drawer openLeftDrawerAnimated:YES finishHandler:nil];
    });
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}


@end
