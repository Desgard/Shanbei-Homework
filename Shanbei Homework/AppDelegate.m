//
//  AppDelegate.m
//  Shanbei Homework
//
//  Created by 段昊宇 on 16/4/1.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MenuViewController.h"
#import "LessonFormViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
    MenuViewController *leftVC = [[MenuViewController alloc] init];
    ViewController *plainVC = [[ViewController alloc] init];
    ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithLeftViewController: leftVC centerViewController: plainVC];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: drawer];
    
    [self.window setRootViewController: nav];
    drawer.title = @"扇贝作业";
    nav.navigationBarHidden = YES;
    */
    LessonFormViewController *lfvc = [[LessonFormViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: lfvc];
    [self.window setRootViewController: nav];
    lfvc.title = @"扇贝作业";
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
