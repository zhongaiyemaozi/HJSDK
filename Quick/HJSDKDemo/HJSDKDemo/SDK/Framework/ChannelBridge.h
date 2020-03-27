//
//  ChannelBridge.h
//  DynamicLibrary
//
//  Created by bx_zhen on 2019/10/28.
//  Copyright © 2019 CL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ChannelBridge : NSObject


@property(nonatomic,strong)NSString *app_id;
@property(nonatomic,strong)NSString *client_id;
@property(nonatomic,strong)NSString *client_key;
@property(nonatomic,strong)NSString *app_key;
@property(nonatomic,strong)NSString *app_Name;
@property(nonatomic,strong)NSString *key_dataType;
@property(nonatomic,strong)NSString *key_serverId;
@property(nonatomic,strong)NSString *key_serverName;
@property(nonatomic,strong)NSString *key_roleId;
@property(nonatomic,strong)NSString *key_roleName;
@property(nonatomic,strong)NSString *key_roleLevel;
@property(nonatomic,strong)NSString *key_roleVip;
@property(nonatomic,strong)NSString *key_roleBalence;
@property(nonatomic,strong)NSString *key_partyName;
@property(nonatomic,strong)NSString *key_rolelevelCtime;
@property(nonatomic,strong)NSString *key_rolelevelMtime;
@property(nonatomic,strong)NSString *key_cpOrderId;
@property(nonatomic,strong)NSString *key_productId;
@property(nonatomic,strong)NSString *key_productName;
@property(nonatomic,strong)NSString *key_productdesc;
@property(nonatomic,strong)NSString *key_ext;
@property(nonatomic,strong)NSString *key_productPrice;
@property(nonatomic,strong)NSString *key_currencyName;
/**
 @"app_id"                                   //游戏ID
 @"client_id"                                //客户端ID
 @"client_key"                               //客户端KEY
 @"app_key"                                  //游戏KEY
 @"app_Name"                                 //游戏名称
 @"key_dataType"                             //数据类型，1为进入游戏，2为创建角色，3为角色升级，4为退出，5为充值
 @"key_serverId"                             //角色所在的serverid
 @"key_serverName"                           //服务器名
 @"key_roleId"                               //角色id
 @"key_roleName"                             //角色名字
 @"key_roleLevel"                            //角色等级
 @"key_roleVip"                              //角色VIP等级
 @"key_roleBalence"                          //角色游戏币余额
 @"key_partyName"                            //公会名字，可选
 @"key_rolelevelCtime"                       //创建角色的时间 时间戳（秒级别）
 @"key_rolelevelMtime"                       //角色等级变化时间 时间戳
 @"key_cpOrderId"                            //游戏使用的订单号
 @"key_productId"                            //商品ID(内购代码)
 @"key_productName"                          //商品名字
 @"key_productdesc"                          //商品描述(可选)
 @"key_ext"                                  //扩展参数，CP订单，默认传@"1"。
 @"key_productPrice"                         //商品金额（单位元）
 @"key_currencyName"                         //商品名字
 */
//渠道初始化
-(void)initChannel;
//渠道登录
-(void)channelsLogin;
//渠道登出
-(void)channelsLogout;
//渠道上传角色
-(void)channelUploadRole;
//渠道支付
-(void)channePay;

/**
 *  第三方支付结果处理
 *
 *  @param url               url
 *  @param sourceApplication sourceApplication
 */
- (void)HJpayResult:(NSURL *)url sourceApplication:(NSString *)sourceApplication;


- (BOOL)HJapplication:(UIApplication *)app openURL:(NSURL *)url options: (NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

@end


