//
//  AppDelegate.m
//  testSoket
//
//  Created by Admin on 2018/5/14.
//  Copyright © 2018年 xiaowei. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDSocketManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:kAppNotInForeGround forKey:kAppCurrentStatus];
    [userDefault synchronize];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:kAppInForeGround forKey:kAppCurrentStatus];
    [userDefault synchronize];
    if ([GCDSocketManager shareSocketManager].userConnected) {
        [GCDSocketManager shareSocketManager].reconnectCount=0;
        [[GCDSocketManager shareSocketManager] connectToServer];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:kAppInForeGround forKey:kAppCurrentStatus];
    [userDefault synchronize];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:kAppNotInForeGround forKey:kAppCurrentStatus];
    [userDefault synchronize];
}

@end
