//
//  ChannelBridge.m
//  DynamicLibrary
//
//  Created by bx_zhen on 2019/10/28.
//  Copyright © 2019 CL. All rights reserved.
//

#import "ChannelBridge.h"

#import <CommonCrypto/CommonDigest.h>

#import <VVSDK/VVSDK.h>


@interface ChannelBridge ()<VVSDKDelegate>
@property(nonatomic,strong)NSDictionary  *dataModelDict; //数据模型
@property(nonatomic,copy)NSString *CappKey;
@property(nonatomic,copy)NSString *CappID;
@property(nonatomic,copy)NSString *PUBLIC_KEY;
@end

@implementation ChannelBridge


#pragma mark - 创建单利类
+(instancetype)sharedJHAggregation{
    static ChannelBridge *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [ChannelBridge new];
        
        [sharedInstance NoticSystemInformsNum];
    });
    return sharedInstance;
}

#pragma mark - 渠道初始化
-(void)initChannel{
    
    [ChannelBridge sharedJHAggregation];
    
    //悬浮标适配，kVVOrientationHorizontal为横屏，kVVOrientationVertical为竖屏
    BOOL success = [[VVSDKInstance sharedInstance] setScreenType:kVVOrientationHorizontal];
    
    NSLog(@"setScreenType success - %d", success);
    
#pragma mark - 获取游戏对接参数plist文件的字典数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameParametersList" ofType:@"plist"];
    NSDictionary *parametersDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.app_id = parametersDict[@"app_id"]==nil?@"":parametersDict[@"app_id"];
    self.client_id = parametersDict[@"client_id"]==nil?@"":parametersDict[@"client_id"];
    self.client_key = parametersDict[@"client_key"]==nil?@"":parametersDict[@"client_key"];
    self.app_key = parametersDict[@"app_key"]==nil?@"":parametersDict[@"app_key"];
    self.app_Name = parametersDict[@"app_Name"]==nil?@"":parametersDict[@"app_Name"];
    self.PUBLIC_KEY = parametersDict[@"PUBLIC_KEY"]==nil?@"":parametersDict[@"PUBLIC_KEY"];
    
    
    self.CappKey = self.app_key;
    self.CappID = self.app_id;
    [[VVSDKInstance sharedInstance] vvSDKInitWithAppID:self.app_id
                                                appKey:self.app_key];
    
    [VVSDKInstance sharedInstance].delegate = self;
    
    
    //系统通知
    [self NoticSystemInformsNum];
    
}


#pragma mark - 系统通知
- (void)NoticSystemInformsNum {
    
    //程序将要进入后台
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
    //程序将要进入前台
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //程序已经进入后台
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    //程序已经进入前台
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //程序退出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillTerminateNotification:) name:UIApplicationWillTerminateNotification object:nil];
    
    //openURL
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ApplicationOpenURLOptionsSourceApplicationKey:) name:UIApplicationOpenURLOptionsSourceApplicationKey object:nil];
    
}



#pragma mark - 接受通知

//- (BOOL)ApplicationOpenURLOptionsSourceApplicationKey:(NSNotification *)notification {
//
////    return [[VVSDKInstance sharedInstance] vvOpenURL:url options:notification.object];
//    return YES;
//}


#pragma mark - 程序将要进入后台
-(void)applicationWillResignActiveNotification:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    
    
}

#pragma mark - 程序将要进入前台
-(void)applicationWillEnterForegroundNotification:(NSNotification *)notification{
    
    [[VVSDKInstance sharedInstance] vvApplicationWillEnterForeground:notification.object];
    
    NSLog(@"%@",notification);
    
}

#pragma mark - 程序已经进入后台,进入后台不显示该页面暂停定时器
-(void)applicationDidEnterBackgroundNotification:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    
    
}

#pragma mark - 程序已经进入前台,继续定时器
-(void)applicationDidBecomeActiveNotification:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    
}

#pragma mark - 程序退出释放定时器
-(void)applicationWillTerminateNotification:(NSNotification *)notification{
    //释放定时器
    
    NSLog(@"%@",notification);
    
    [[VVSDKInstance sharedInstance] vvApplicationWillTerminate:notification.object];
    
}


#pragma mark - 渠道登录
-(void)channelsLogin{
    [VVSDKInstance sharedInstance].delegate = self;
    int state = [[VVSDKInstance sharedInstance] vvLogin];
    NSLog(@"登录是否异常 - %d", state);
}




#pragma mark - 渠道上传角色
-(void)channelUploadRole{
    
    [VVSDKInstance sharedInstance].delegate = self;
    
    // 同步进入游戏信息【必须实现, 且必须在登录成功后实现】
    NSString *zoneId = self.key_serverId;
    NSString *zoneName = self.key_serverName;
    NSString *roleId = self.key_roleId;
    NSString *roleName = self.key_roleName;
    NSString *roleLevel = self.key_roleLevel;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *gameCoin = [f numberFromString:self.key_roleBalence];
    
    [[VVSDKInstance sharedInstance] vvSyncDataWithActionType:(VVActionType_Levelup)
                                                      zoneId:zoneId zoneName:zoneName
                                                      roleId:roleId roleName:roleName
                                                   roleLevel:roleLevel
                                                    gameCoin:gameCoin
                                                    callback:^(id success, NSError *error) {
        if ([success boolValue]) {
            
            
            //            [self showTip:@"更新升级成功" hideAfterTime:1];
        }
    }];
    
    
    
}
#pragma mark - 渠道登出
-(void)channelsLogout{
    
    [VVSDKInstance sharedInstance].delegate = self;
    
    [[VVSDKInstance sharedInstance] vvLogout];
    
    NSString *zoneId = self.key_serverId;
    NSString *zoneName = self.key_serverName;
    NSString *roleId = self.key_roleId;
    NSString *roleName = self.key_roleName;
    NSString *roleLevel = self.key_roleLevel;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *gameCoin = [f numberFromString:self.key_roleBalence];
    [[VVSDKInstance sharedInstance] vvSyncDataWithActionType:(VVActionType_QuitGame)
                                                      zoneId:zoneId zoneName:zoneName
                                                      roleId:roleId roleName:roleName
                                                   roleLevel:roleLevel
                                                    gameCoin:gameCoin
                                                    callback:^(id success, NSError *error) {
        if ([success boolValue]) {
            
            
            //                       [self showTip:@"退出游戏成功" hideAfterTime:1];
            
        }
    }];
    
}
#pragma mark -渠道支付
-(void)channePay{
    
    [VVSDKInstance sharedInstance].delegate = self;
    
    BOOL isApplePay = [VVSDKInstance sharedInstance].AP;
    
    VVPay *vo = [[VVPay alloc]init];
    vo.orderId      = self.key_cpOrderId;// 这里传入CP端的订单id
    
    double price = [self.key_productPrice doubleValue] * 100;
    
    
    if (isApplePay) {
        vo.productId    = self.key_productId;// 需要用内购支持的商品id
        vo.money        = price;// 1元(单位分),必须是内购商品对应的金额
    }else{
        vo.productId = self.key_productId;// CP后台定义的产品id
        vo.money        = price;// 1元(单位分)
    }
    vo.productName  = self.key_productName;
    vo.productDesc  = self.key_productdesc;
    vo.notifyUrl    = @"";// 支付成功，Server异步通知该地址，告诉游戏服务器发货
    vo.extension    = self.key_ext;// 游戏自定义数据，充值成功，回调游戏服的时候，会原封不动返回
    [[VVSDKInstance sharedInstance] vvPayOrderWithInfo:vo];
    
    
    
}





#pragma mark - VVSDKDelegate

- (void)vvSDKInited:(NSDictionary *)params error:(VVError *)error
{
    if(error){
        // 初始化失败时需要重新调用初始化接口
        NSLog(@"初始化失败");
        
        
        [[VVSDKInstance sharedInstance] vvSDKInitWithAppID:self.CappID
                                                    appKey:self.CappKey];
        
        return;
    }
    
    NSLog(@"初始化完成");
    
}

- (void)vvLoginWithParams:(NSDictionary *)params error:(VVError *)error {
    
    NSString *specialSign = params[@"specialSign"]; // CP标识，专服系列游戏包用来区分专区
    NSString *userToken = params[@"userToken"]; // 用户 Token
    
    if (error) {
        NSLog(@"登录失败");
        
        return;
    }
    
    //容错处理
    if (specialSign == nil) {
        specialSign = @"NULL";
    }
    
    
    NSLog(@"登录成功, specialSign - %@, userToken = %@", specialSign, userToken);
    NSDictionary *dict = @{
        @"Uid":specialSign,
        @"Token":userToken,
        
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsLoginSuccess" object:dict];
    
    
    NSString *zoneId = self.key_serverId;
    NSString *zoneName = self.key_serverName;
    NSString *roleId = self.key_roleId;
    NSString *roleName = self.key_roleName;
    NSString *roleLevel = self.key_roleLevel;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *gameCoin = [f numberFromString:self.key_roleBalence];
    [[VVSDKInstance sharedInstance] vvSyncDataWithActionType:(VVActionType_EnterGame)
                                                      zoneId:zoneId zoneName:zoneName
                                                      roleId:roleId roleName:roleName
                                                   roleLevel:roleLevel
                                                    gameCoin:gameCoin
                                                    callback:nil];
    
    
    
    
}

- (void)vvPayOrder:(NSDictionary *)params error:(VVError *)error
{
    if (error) {
        NSLog(@"支付失败");
    } else {
        NSLog(@"支付成功");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsPaySuccess" object:nil];
        
    }
}

- (void)vvLogout
{
    NSLog(@"登出成功");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsLogoutSucceed" object:@""];
    
}



#pragma mark -释放通知
-(void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self];
}
#pragma mark - 给数据模型赋值
-(NSDictionary *)dataModelDict{
    NSMutableDictionary *modelDict = [NSMutableDictionary dictionary];
    if (self.app_id) {
        [modelDict setObject:self.app_id forKey:@"app_id"];
    }
    if (self.client_id) {
        [modelDict setObject:self.client_id forKey:@"client_id"];
    }
    if (self.client_key) {
        [modelDict setObject:self.client_key forKey:@"client_key"];
    }
    if (self.app_key) {
        [modelDict setObject:self.app_key forKey:@"app_key"];
    }
    if (self.app_Name) {
        [modelDict setObject:self.app_Name forKey:@"app_Name"];
    }
    if (self.key_dataType) {
        [modelDict setObject:self.key_dataType forKey:@"key_dataType"];
    }
    if (self.key_serverId) {
        [modelDict setObject:self.key_serverId forKey:@"key_serverId"];
    }
    if (self.key_serverName) {
        [modelDict setObject:self.key_serverName forKey:@"key_serverName"];
    }
    if (self.key_roleId) {
        [modelDict setObject:self.key_roleId forKey:@"key_roleId"];
    }
    if (self.key_roleName) {
        [modelDict setObject:self.key_roleName forKey:@"key_roleName"];
    }
    if (self.key_roleLevel) {
        self.key_roleLevel = [self.key_roleLevel isEqual:@"0"]?@"1":self.key_roleLevel;
        [modelDict setObject:self.key_roleLevel forKey:@"key_roleLevel"];
    }
    if (self.key_roleVip) {
        self.key_roleVip = [self.key_roleVip isEqual:@"0"]?@"1":self.key_roleVip;
        [modelDict setObject:self.key_roleVip forKey:@"key_roleVip"];
    }
    if (self.key_roleBalence) {
        [modelDict setObject:self.key_roleBalence forKey:@"key_roleBalence"];
    }
    if (self.key_partyName) {
        [modelDict setObject:self.key_partyName forKey:@"key_partyName"];
    }
    if (self.key_rolelevelCtime) {
        [modelDict setObject:self.key_rolelevelCtime forKey:@"key_rolelevelCtime"];
    }
    if (self.key_rolelevelMtime) {
        [modelDict setObject:self.key_rolelevelMtime forKey:@"key_rolelevelMtime"];
    }
    if (self.key_cpOrderId) {
        [modelDict setObject:self.key_cpOrderId forKey:@"key_cpOrderId"];
    }
    if (self.key_productId) {
        [modelDict setObject:self.key_productId forKey:@"key_productId"];
    }
    if (self.key_productName) {
        [modelDict setObject:self.key_productName forKey:@"key_productName"];
    }
    if (self.key_productdesc) {
        [modelDict setObject:self.key_productdesc forKey:@"key_productdesc"];
    }
    if (self.key_ext) {
        [modelDict setObject:self.key_ext forKey:@"key_ext"];
    }
    if (self.key_productPrice) {
        [modelDict setObject:self.key_productPrice forKey:@"key_productPrice"];
    }
    if (self.key_currencyName) {
        [modelDict setObject:self.key_currencyName forKey:@"key_currencyName"];
    }
    return modelDict.copy;
}


@end
