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
                               @"key_dataType" : @"0",
                               @"key_serverId" : @"0",
                               @"key_serverName" : @"剑域1服00",
                               @"key_roleId" : @"10000010",
                               @"key_roleName" : @"空若冰qq",
                               @"key_roleLevel" : @"1",
                               @"key_roleVip" : @"1",
                               @"key_roleBalence" : @"0",
                               @"key_partyName" : @"testparty",
                               @"key_rolelevelCtime" : @"0",
                               @"key_rolelevelMtime" : @"0",
                               @"key_currencyName":@"元宝"
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
                                @"key_cpOrderId": dateStr,
                                @"key_serverId": @"1",
                                @"key_serverName": @"剑域1服",
                                @"key_productId": @"2",
                                @"key_productName": @"6",
                                @"key_productdesc": @"6",
                                @"key_ext": @"1_80127",
                                @"key_productPrice": @"1.00",
                                @"key_roleId": @"10000010",
                                @"key_roleName": @"空若冰ads",
                                @"key_currencyName" : @"元宝",
                                @"key_callbackurl": @"" //回调url这个值根据需要填写
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
    
    NSLog(@"UserID:%@",userDict[@"UserId"]);//用户ID
    
    NSLog(@"Toekn:%@",userDict[@"Token"]);//用户Token
    
    
    
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
