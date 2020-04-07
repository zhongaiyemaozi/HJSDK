//
//  SMSDK.h
//  SMSDK
//
//  Created by zunshanli on 16/1/28.
//  Copyright © 2016年 Shangminet. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SMPayInfo.h"
#import "SMConstant.h"
@interface SMSDK : NSObject
/**
 初始化数据, 检查更新, 设置appKey( 只能调用一次)
 初始化完成, 发送SMSDKInitDidFinishNotification通知
 @param appKey 游戏开发商,在开放平台添加游戏后获得的appKey
 */
+ (void)smInitWithAppKey:(NSString *)appKey;
/**
 登录
 登录完成后, 发送SMSDKLoginNotification通知
 */
+ (void)smLogin;
/**
 注销, 接入的游戏中可选含有注销/登出的按钮, 用于调用注销方法
 注销完成后, 发送SMSDKLogoutNotification通知
 */
+ (void)smLogout;
/**
 支付
 @param payInfo 支付参数
 */
+ (void)smPayWithNewPayInfo:(SMPayInfo *)payInfo;
/**
 处理支付宝回调数据, 在AppDelegate里
 -(BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation 中调用
 */
+ (BOOL)handleApplication:(UIApplication *)application
                  openURL:(NSURL *)url
        sourceApplication:(NSString *)sourceApplication
               annotation:(id)annotation;
/**
 隐藏银联支付
 @param hide  默认为(NO)显示
 */
+ (void)setHideUnionpay:(BOOL)hide;
@end
