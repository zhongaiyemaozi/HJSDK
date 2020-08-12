//
//  AppDelegate.m
//  HJSDKDemo
//
//  Created by bx_zhen on 2019/11/12.
//  Copyright © 2019 CL. All rights reserved.
//

#import "AppDelegate.h"
#import <YouCiFangSDK/XiFaSDKManager.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    //初始化聚合接口
    [[HJAggregationSDK sharedJHAggregation] initAggregationapplication:application didFinishLaunchingWithOptions:launchOptions];
    
        return [[XiFaSDKManager share6lsdk] application:application didFinishLaunchingWithOptions:launchOptions];
    }


    #pragma mark - 支付回调，必接，三选一，推荐使用options。

    #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
    {
        return [[XiFaSDKManager share6lsdk] application:application openURL:url options:options];
    }

    #else

    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    {
        return [[XiFaSDKManager share6lsdk] application:application openURL:url  sourceApplication:sourceApplication annotation:annotation];
    }


    - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
    {
        return [[XiFaSDKManager share6lsdk] application:application handleOpenURL:url];
    }

    #endif

    - (void)applicationWillResignActive:(UIApplication *)application {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        [[XiFaSDKManager share6lsdk] applicationWillResignActive:application];
    }


    - (void)applicationDidEnterBackground:(UIApplication *)application {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        [[XiFaSDKManager share6lsdk] applicationDidEnterBackground:application];
    }


    - (void)applicationWillEnterForeground:(UIApplication *)application {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        [[XiFaSDKManager share6lsdk] applicationWillEnterForeground:application];
    }


    - (void)applicationDidBecomeActive:(UIApplication *)application {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        [[XiFaSDKManager share6lsdk] applicationDidBecomeActive:application];
    }


    - (void)applicationWillTerminate:(UIApplication *)application {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        [[XiFaSDKManager share6lsdk] applicationWillTerminate:application];
    }


@end
