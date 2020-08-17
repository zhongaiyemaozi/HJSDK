//
//  HJAggregationSDK.h
//  HJAggregationSDK
//
//  Created by bx_zhen on 2019/9/16.
//  Copyright © 2019 AGSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#pragma mark - 代理
@protocol JHAggregationInitDelegate <NSObject>

#pragma mark - 必须实现的
@required

/**
 登录成功的回调
 @param userDict 登录的返回数据
 */
- (void) loginSuccendUserDict:(NSDictionary *)userDict;


/**
 登出成功的回调
 @param dict 登出的返回数据
 */
- (void) loginOutSuceend:(NSDictionary *)dict;


/**
 **预留接口，目前不会进行回调，服务端回调
 支付成功的回调
 @param oredrDict 支付的返回数据
 */
- (void) orderSuccendOrderDict:(NSDictionary *)oredrDict;


/**
 上报角色成功的回调
 @param infoDict 上报角色的返回数据
 */
- (void) uploadSuccendInfoDict:(NSDictionary *)infoDict;



#pragma mark - 可选实现的
@optional

/**
 初始化的回调
 @param initDict 初始化的回调
 */
- (void)inInitDict:(NSDictionary *)initDict;

/**
 初始化失败的回调
 @param initDict 初始化失败的回调
 */
- (void)InInitDictFailed:(NSDictionary *)initDict;

/**
 登录失败的回调
 @param userDict 登录的返回数据
 */
- (void) loginFailedUserDict:(NSDictionary *)userDict;

/**
 登出失败的回调
 @param dict 登出的返回数据
 */
- (void) loginOutFailed:(NSDictionary *)dict;

/**
 **预留接口，目前不会进行回调，服务端回调
 支付失败回调
 @param oredrDict 支付的返回数据
 */
- (void) orderFailedOrderDict:(NSDictionary *)oredrDict;

/**
 上报角色失败的回调
 @param infoDict 上报角色的返回数据
 */
- (void) uploadFailedInfoDict:(NSDictionary *)infoDict;

@end


@interface HJAggregationSDK : NSObject

/**
 代理属性
 */
@property(nonatomic,weak) id<JHAggregationInitDelegate> delegate;



/**
 单例
 @return 返回初始化的单例
 */
+(instancetype)sharedJHAggregation;


/**
 初始化
 */
- (void)initAggregationapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
/**
 登录
 */
- (void)loginGame;


#pragma mark - 苹果支付
/**
 支付接口
 @param orderInfoDict 订单数据
 orderInfo { 参数必传，若没有统一传@"1"。
 @"key_cpOrderId"    : @"testorderid",               //游戏使用的订单号
 @"key_serverId"     : @"testserver",                //角色所在的serverid
 @"key_serverName"   : @"testserverName",            //服务器名称
 @"key_productId"    : @"com.ingcle.demo01",         //商品ID(内购代码)
 @"key_productName"  : @"商品名字",                   //商品名字
 @"key_productdesc"  : @"goodsdes",                  //商品描述(可选)
 @"key_ext"          : @"testattach",                //扩展参数，没有默认传@"1"。
 @"key_productPrice" : @"0.1",                       //商品金融（单位元）
 @"key_roleId"       : @"testrole",                  //角色ID
 @"key_roleName"     : @"biKing",                     //角色名字
 @"key_currencyName" : @"钻石",                       //货币名
 @"key_callbackurl"  : @"",                          //支付回调地址,如果需要客户端处理的就填写否则就传@""空
 }
 */
- (void)orderInfoGame:(NSDictionary *)orderInfoDict;



#pragma mark - 上传信息角色
/**
 上传角色信息
 
 @param userInfoDict 角色信息的字典
 userInfo { 参数必传参数必传，若没有统一传@"1"。
 @"key_dataType"       : @"1",                       //数据类型，1为进入游戏，2为创建角色，3为角色升级，4为退出，5为充值
 @"key_serverId"       : @"1",                       //角色所在的serverid
 @"key_serverName"     : @"testserver",              //服务器名
 @"key_roleId"         : @"123",                     //角色id
 @"key_roleName"       : @"iOS测试账号",               //角色名字
 @"key_roleLevel"      : @1,                         //角色等级
 @"key_roleVip"        : @"3",                       //角色VIP等级
 @"key_roleBalence"    : @"123",                     //角色游戏币余额
 @"key_partyName"      : @"testparty",               //公会名字，可选
 @"key_rolelevelCtime" : @"1479196021",              //创建角色的时间 时间戳（秒级别）
 @"key_rolelevelMtime" : @"1479196736",              //角色等级变化时间 时间戳
 @"key_currencyName"   : @"元宝"                      //货币名
 }
 */
- (void)userInfoGame:(NSDictionary *)userInfoDict;

/**
 登出
 */
- (void)loginOutGame;


#pragma mark - 周期函数-






@end
