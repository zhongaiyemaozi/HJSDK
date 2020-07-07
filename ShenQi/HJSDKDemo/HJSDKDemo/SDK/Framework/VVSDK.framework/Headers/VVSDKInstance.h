//
//  VVSDKInstance.h
//  WYSDK
//
//  Created by Weep Yan on 16/5/10.
//  Copyright © 2016年 Weep Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VVCallBack.h"
#import "VVDefines.h"

@class VVPay;
@class VVError;

@protocol VVSDKDelegate <NSObject>

@required
/*!
 初始化 成功回调【必接】
 @param params 返回  @{@"zoneId":xxx}
 @param error 如果成功则为nil
 */
- (void)vvSDKInited:(NSDictionary *)params error:(VVError *) error;

/**
 登录结果回调【必接】

 @param params @[@"userToken":<登录凭证>, @"specialSign":<CP游戏标识>]
 @param error 如果成功则为nil
 */
- (void)vvLoginWithParams:(NSDictionary *)params error:(VVError *)error;


/*!
 登出结果回调【必接】

 */
- (void)vvLogout;

@optional
/*!
 支付结果回调, 【必接】

 @param params 参数请参考VVHappy.h文件
 @param error 如果成功则为nil
 */
- (void)vvPayOrder:(NSDictionary *)params error:(VVError *)error;

@end

@interface VVSDKInstance : NSObject

/*!
 回调代理，【必接】
 */
@property (nonatomic, assign) id<VVSDKDelegate> delegate;

/*!
 登录凭证
 */
@property(readonly, strong, nonatomic) NSString *token;


/*!
 * @brief 用户选择的大区,该属性在【登录结果回调 -vvLoginWithParams:error:】之后才生效
 *
 */
@property(readonly, strong, nonatomic) NSString *zoneId;

/*!
 是否是苹果支付，
 YES    :苹果支付
 NO     :第三方支付
 回调vvSDKInited，并返回成功后生效，
 默认NO
 */
@property(readonly, assign, nonatomic) BOOL AP;


+ (VVSDKInstance *)sharedInstance;

/*!
 * @method 初始化【必接】
 * @brief 【AppDelegate application:didFinishLaunchingWithOptions:】中调用
 * @param appID         应用ID/游戏ID
 * @param appkey        应用Key
*/
- (void)vvSDKInitWithAppID:(NSString *)appID appKey:(NSString *)appkey;


/*!
 * @method 登录【必接】
 * @brief 初始化成功后，调用的登录入口
 
 @return 是否成功（0成功；非0为异常）
 */
- (int) vvLogin;

/*!
 * @method 同步游戏数据【必接】
 * @brief 如果需要验证，则需要在【Token验证 成功回调】之后调用，否则需要在【注册/登录 成功回调】之后调用。其中，可选参数，不填则传nil
 * 
 * @param actionType 操作类型 1:进入游戏;2:等级提升;3:退出游戏; (必填)
 * @param zoneId 区服ID (必填)
 * @param zoneName 区服名称  (必填)
 * @param roleId 角色ID (必填)
 * @param roleName 角色昵称  (必填)
 * @param roleLevel 角色等级 (可选)
 * @param gameCoin 当前游戏币 (可选)
 * @param callback 结果回调函数
 */
- (void)vvSyncDataWithActionType:(VVActionType)actionType
                          zoneId:(NSString *)zoneId
                        zoneName:(NSString *)zoneName
                          roleId:(NSString *)roleId
                        roleName:(NSString *)roleName
                       roleLevel:(NSString *)roleLevel
                        gameCoin:(NSNumber *)gameCoin
                        callback:(VVCallback)callback;


/*!
 * @method 订单支付【可选】
 * @brief 需要在【进入游戏 成功回调】之后调用。
 */
- (void)vvPayOrderWithInfo:(VVPay *) info;

/*!
 * @method 注销【可选】
 * @brief 需要在【登录结果回调 -vvLoginWithParams:error:】之后调用
 */
- (void)vvLogout;


/*!
 @method 拉起游戏回调, 【必接】
 @brief 在 [Appdelegate application:handleOpenURL:] 中调用
 */
- (BOOL)vvHandleOpenURL:(NSURL *)url;
- (BOOL)vvOpenURL:(NSURL *)url options:(NSDictionary*)options;

/*!
 * @method 支付进程间回调, 【必接】
 * @brief 在 [Appdelegate applicationWillEnterForeground:] 中调用
 */
- (void)vvApplicationWillEnterForeground:(UIApplication *)application;

/*!
 * @method SDK统计服务相关, 【必接】
 * @brief 在 [Appdelegate applicationWillTerminate:] 中调用
 */
- (void)vvApplicationWillTerminate:(UIApplication *)application;

/*!
 * @method SDK统计服务相关, 【必接】
 * @brief 在 [Appdelegate application:supportedInterfaceOrientationsForWindow:] 中调用
 */
- (UIInterfaceOrientationMask) vvSupportedInterfaceOrientationsForWindow:(UIWindow *)window;


/*!
 * @method 显示界面, CP不需要调用
 * @brief 需要在【初始化 成功回调】之后调用。
 * @param vview 界面类型
 *          开启登录界面
 *          [[VVSDKInstance sharedInstance] vvShowWithVView:VVView_Login];
 * @return 是否显示成功（0成功；非0为异常）
 */
- (int) vvShowWithVView:(VVView) vview;

/*!
 * @method 隐藏界面, CP不需要调用
 */
- (void) vvHideWithVView:(VVView) vview;

/**
 显示浮标 - CP不需要调用
 */
- (void)showFloatWindow;

/**
 横竖屏配置

 @param type kVVOrientationHorizontal-横屏，kVVOrientationVertical-竖屏
 */
- (BOOL)setScreenType:(NSUInteger)type;

- (void)testClearSandbox;

@end


