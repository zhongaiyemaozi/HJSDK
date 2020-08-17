//
//  JHLCoreEntity.h
//  QPJHDemo
//
//  Created by 7pagame on 2019/2/14.
//  Copyright © 2019年 Vanney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - 浮动条位置 Enum
typedef enum {
    QPJHLightQcSDK_TOOLBAR_TOP_LEFT  = 1,           /* 左上 */
    QPJHLightQcSDK_TOOLBAR_TOP_RIGHT = 2,           /* 右上 */
    QPJHLightQcSDK_TOOLBAR_MID_LEFT  = 3,           /* 左中 */
    QPJHLightQcSDK_TOOLBAR_MID_RIGHT = 4,           /* 右中 */
    QPJHLightQcSDK_TOOLBAR_BOT_LEFT  = 5,           /* 左下 */
    QPJHLightQcSDK_TOOLBAR_BOT_RIGHT = 6,           /* 右下 */
}QPJHLightQcSDK_TOOLBAR_PLACE;

@interface QPJHSDKPayInfo : NSObject
@property (retain)  NSString* orderId;  //聚合订单号
@property (retain)  NSString* channel_order;   // 渠道订单号
@property (retain)  NSString* cpOrderId;   //游戏开发商给的订单号

@end

@protocol JHLCoreEntityDelegate <NSObject>

@required

//登录回调
- (void)getChannelLoginCallBack:(NSDictionary *)result;

//上报角色回调
- (void)getUpdateRoleCallBack:(NSDictionary *)result;

//支付成功回调
- (void)getPaySuccessCallBack:(QPJHSDKPayInfo *)result;
    
//支付失败回调
- (void)getPayFailCallBack:(QPJHSDKPayInfo *)result;

//退出登录,切换账号回调
- (void)logOutCallBack:(int)exitCode;

//选择区服【停止新增用户】回调: 当result为1可进入该区服,当result为其他值时,SDK里有错误提示.研发不做任何处理.
- (void)canEnterListenCallBack:(NSString *)result;
//GM商城充值回调
- (void)rechargeCallBack:(NSString *)result;
@end

@interface JHLCoreEntity : NSObject <UIApplicationDelegate>

@property id<UIApplicationDelegate> sdkDelegate;


/**
 获取SDK实例
 */
+ (JHLCoreEntity *)sharedInstance;

@property (nonatomic ,weak) id <JHLCoreEntityDelegate> delegate;


/**
 登录
 */
- (void)qpjh_loginStart;

/**
 角色更新接口
 @param roleData json 数据(请按要求传入 json 格式的 NSString 类型)
  */
- (void)qpjh_superRoleUpdate:(NSString *)roleData;
/**
 打开GM商城
 */
- (void)qpjh_openGmShop;
/**
 创建订单接口
 @param orderData json 数据(请按要求传入 json 格式的 NSString 类型)
 */
- (void)qpjh_superOrder:(NSString *)orderData;

/**
 退出登录接口
 */
- (void)qpjh_logout;

/**
 选择区服【停止新增用户】(接口说明: 玩家在选择区服时调用. )
 @param service_id   当前选择的服务器ID
 @param service_name 当前选择的服务器名
 */
- (void)qpjh_canEnterGameWithServiceID:(NSString *)service_id ServiceName:(NSString *)service_name;

/**
显示浮动菜单
*/
- (void)showToolBar:(QPJHLightQcSDK_TOOLBAR_PLACE)place;
/**
 隐藏浮动菜单
 */
- (void)hideToolBar;
/**
 进入用户中心
 */
- (int)enterUserCenter;

@end
