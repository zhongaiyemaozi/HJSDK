//
//  QiYuSDKManager.h
//  QiYuSDK
//
//  Created by cy on 2019/11/3.
//  Copyright © 2019年 cy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYGameRoleInfo.h"

@interface QiYuSDKManager : NSObject

/**
 * 单例
 */
+ (QiYuSDKManager*)share6lsdk;


/**
 * 初始化泊然sdk
 *
 * @param appId     唯一标示符
 * @param appKey    唯一标示符
 * @param appScheme 应用唯一标示，用于应用间的跳转
 * @param direction 当前游戏的方向, 1 = 竖屏，2 = 横屏;
 */
+ (void)initializeQiYuSDKWithAppId:(NSString *)appId
                             appKey:(NSString *)appKey
                          appScheme:(NSString *)appScheme
                          direction:(int)direction;


/*添加登录界面
 * @param view 需要加登录界面的父视图;
 */
+ (void)addLoginView:(UIViewController *)controller;


/**
 * 支付
 *
 * @param money       商品价格;
 * @param productId   商品ID;
 * @param productName 商品名称;
 * @param productDesc 商品描述;
 * @param roleId      角色ID;
 * @param roleName    角色名称;
 * @param extInfo     扩展参数
 * @param serverId    服务器id;
 * @param serverName  服务器名称;
 */
+ (void)PayWithMoney:(NSString*)money
           ProductId:(NSString*)productId
         ProductName:(NSString*)productName
         ProductDesc:(NSString*)productDesc
              RoleId:(NSString*)roleId
            RoleName:(NSString*)roleName
             ExtInfo:(NSString*)extInfo
            ServerId:(NSString*)serverId
          ServerName:(NSString*)serverName;
           

/**
 * 角色上报
 */
+ (void)sendQYGameRoleInfo:(QYGameRoleInfo*)roleInfo;


/**
 * 添加悬浮窗界面
 *
 * @param view 需要加悬浮窗的父视图;
 */
+ (void)addQYAssistiveView:(UIView *)view;


/**
 * 注销登录
 */
+ (void)logout;


/**
 * 切换账号
 */
+ (void)switchAccount;


/**
 * 实名认证检测，由CP主动调用
 */
+ (void)checkRealNameVerify;


/**
 * 是否登录
 */
+ (BOOL)isLogined;


/**
 * 是否游客登录
 */
+ (BOOL)isGuestLogined;


#pragma mark - 周期函数

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;

- (void)applicationWillResignActive:(UIApplication *)application;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

@end
