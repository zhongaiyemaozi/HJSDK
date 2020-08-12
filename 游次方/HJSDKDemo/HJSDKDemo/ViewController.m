//
//  ViewController.m
//  HJSDKDemo
//
//  Created by bx_zhen on 2019/11/12.
//  Copyright © 2019 CL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<JHAggregationInitDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //遵循代理
    [HJAggregationSDK sharedJHAggregation].delegate = self;
    
}

//登录
- (IBAction)loginYargetButton:(UIButton *)sender {
    
    [[HJAggregationSDK sharedJHAggregation] loginGame];
    
    
}

//角色上报
- (IBAction)UserUpdateTarget:(UIButton *)sender {
    
    NSDictionary *userDict = @{
                               @"key_dataType" : @"0",//数据类型，1为进入游戏，2为创建角色，3为角色升级，4为退出，5为充值
                               @"key_serverId" : @"0",//角色所在的serverid
                               @"key_serverName" : @"剑域1服00",//服务器名
                               @"key_roleId" : @"10000010",//角色id
                               @"key_roleName" : @"空若冰qq",//角色名字
                               @"key_roleLevel" : @"1",//角色等级
                               @"key_roleVip" : @"1",//角色VIP等级
                               @"key_roleBalence" : @"0",//角色游戏币余额
                               @"key_partyName" : @"testparty",//公会名字，可选
                               @"key_rolelevelCtime" : @"0",//创建角色的时间 时间戳（秒级别）
                               @"key_rolelevelMtime" : @"0",//角色等级变化时间 时间戳
                               @"key_currencyName":@"元宝"//货币名
                               };
    [[HJAggregationSDK sharedJHAggregation]userInfoGame:userDict];
    
}

//支付
- (IBAction)userPayTarget:(UIButton *)sender {
    
    NSDate * date = [NSDate date];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/ddHH:mm:ss"];
    NSString * dateStr = [dateFormatter stringFromDate:date];
    
    NSDictionary *orderInfo = @{
                                @"key_cpOrderId": dateStr,      //游戏使用的订单号，必须唯一
                                @"key_serverId": @"1",//角色所在的serverid
                                @"key_serverName": @"剑域1服",//服务器名称
                                @"key_productId": @"2",//商品ID(内购代码)
                                @"key_productName": @"6",//商品名字
                                @"key_productdesc": @"6",//商品描述(可选)
                                @"key_ext": @"1_80127",//扩展参数，CP订单，默认传@"1"。
                                @"key_productPrice": @"0.01",//商品金融（单位元,要精确到小数点后两位数，比如1.00）
                                @"key_roleId": @"10000010",//角色ID
                                @"key_roleName": @"空若冰ads",//角色名字
                                @"key_currencyName" : @"元宝",//货币名
                                @"key_callbackurl": @"" //支付回调地址
                                };
    [[HJAggregationSDK sharedJHAggregation]orderInfoGame:orderInfo];
    
}

//登出
- (IBAction)userLogOutTarget:(UIButton *)sender {
    
    
    [[HJAggregationSDK sharedJHAggregation]loginOutGame];
    
}

#pragma mark - JHAggregationInitDelegate
/**
 初始化成功的回调
 @param initDict 初始化的返回数据
 */
- (void)inInitDict:(NSDictionary *)initDict{
    NSLog(@"初始化成功%@",initDict);
}

/**
 初始化失败的回调
 @param initDict 初始化失败的返回数据
 */
- (void)InInitDictFailed:(NSDictionary *)initDict{
    NSLog(@"初始化失败%@",initDict);
}

/**
 登录成功的回调
 @param userDict 登录的返回数据
 */
- (void) loginSuccendUserDict:(NSDictionary *)userDict{
    
    NSLog(@"用户UserID:%@",userDict[@"UserId"]);//用户ID
    
    NSLog(@"用户Toekn:%@",userDict[@"Token"]);//用户Token
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@%@%@%@",userDict[@"Url"],@"?UserId=",userDict[@"UserId"],@"&Token=",userDict[@"Token"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"验证地址：%@",url);
    
}

/**
 登录失败的回调
 @param userDict 登录失败的返回数据
 */
- (void) loginFailedUserDict:(NSDictionary *)userDict{
    NSLog(@" 登录失败的回调!");
}


/**
 登出的回调
 @param dict 登出的返回数据
 */
- (void) loginOutSuceend:(NSDictionary *)dict{
    NSLog(@"登出回调成功!");
    //登出成功再次登录
    //    [self loginButton:nil];
}


/**
 登出失败回调
 @param dict 登出失败的返回数据
 */
- (void) loginOutFailed:(NSDictionary *)dict{
    NSLog(@"登出失败回调!");
}

/**
 支付成功的回调
 @param oredrDict 支付的返回数据
 */
- (void) orderSuccendOrderDict:(NSDictionary *)oredrDict{
    NSLog(@"支付回调成功!");
}

/**
 支付失败的回调
 @param oredrDict 支付失败的返回数据
 */
-(void)orderFailedOrderDict:(NSDictionary *)oredrDict{
    NSLog(@"支付失败!");
}

/**
 上报角色成功的回调
 @param infoDict 上报角色的返回数据
 */
- (void) uploadSuccendInfoDict:(NSDictionary *)infoDict{
    NSLog(@"上传角色回调成功!");
}

/**
 上报角色失败的回调
 @param infoDict 上报角色失败的返回数据
 */
- (void) uploadFailedInfoDict:(NSDictionary *)infoDict{
    NSLog(@"上报角色失败的回调!");
}



@end
