//
//  ChannelBridge.m
//  DynamicLibrary
//
//  Created by bx_zhen on 2019/10/28.
//  Copyright © 2019 CL. All rights reserved.
//

#import "ChannelBridge.h"
#import <QPJHLightQcSDK/QPJHLightQcSDK.h>

@interface ChannelBridge ()<JHLCoreEntityDelegate>
@property(nonatomic,strong)NSDictionary  *dataModelDict; //数据模型
@property(nonatomic,copy)NSString *super_user_id;//奇葩返回的useID
@property (copy, nonatomic) NSString *serviceToken;


@end

@implementation ChannelBridge

- (void)HJpayResult:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    
//    [[AsInfoKit sharedInstance] payResult:url sourceApplication:sourceApplication];
    
}

- (BOOL)HJapplication:(UIApplication *)app openURL:(NSURL *)url options: (NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    
    return [[JHLCoreEntity sharedInstance] application:app openURL:url options:options];
}

#pragma mark - 渠道初始化
-(void)initChannel{
    
    //系统通知
    [self NoticSystemInformsNum];
    
#pragma mark - 获取游戏对接参数plist文件的字典数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameParametersList" ofType:@"plist"];
    NSDictionary *parametersDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.app_id = parametersDict[@"app_id"]==nil?@"":parametersDict[@"app_id"];
    self.client_id = parametersDict[@"client_id"]==nil?@"":parametersDict[@"client_id"];
    self.client_key = parametersDict[@"client_key"]==nil?@"":parametersDict[@"client_key"];
    self.app_key = parametersDict[@"app_key"]==nil?@"":parametersDict[@"app_key"];
    self.app_Name = parametersDict[@"app_Name"]==nil?@"":parametersDict[@"app_Name"];
    
    [[JHLCoreEntity sharedInstance] qpjh_initWithProductKey:self.client_key ProductCode:self.app_key];
    
    [[JHLCoreEntity sharedInstance] application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:@{}];
    
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

#pragma mark - 渠道登录
-(void)channelsLogin{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameParametersList" ofType:@"plist"];
    NSDictionary *parametersDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.app_id = parametersDict[@"app_id"]==nil?@"":parametersDict[@"app_id"];
    
   
    [JHLCoreEntity sharedInstance].delegate = self;
    //登录
    [[JHLCoreEntity sharedInstance] qpjh_loginStartWithGameId:self.app_id];
    
}




#pragma mark - 渠道上传角色
-(void)channelUploadRole{
    
     [JHLCoreEntity sharedInstance].delegate = self;
    
    [[JHLCoreEntity sharedInstance] qpjh_canEnterGameWithServiceID:self.key_serverId ServiceName:self.key_roleName];
    
    /*
    参数KEY      类型      注释
    super_user_id      NSString      登陆回调接口返回来的用户标识
    role_id      NSString      角色ID
    role_name      NSString      角色名
    role_level      NSString      角色等级
    service_id      NSString      服务器ID
    service_name      NSString      服务器名
    role_type      NSString      createrole 创建角色; enterserver 进入游戏; levelup 升级角色
    describe      NSString      描写 选填
    money      NSString      元宝或金币 选填
    experience      NSString      经验 选填
    */
    
    //角色上报类型role_type: createrole 创建角色; enterserver 进入服务器调用; levelup 升级角色;
    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.super_user_id, @"super_user_id",
                          self.key_dataType,@"role_type",
                          self.key_serverId, @"service_id",
                          self.key_serverName, @"service_name",
                          self.key_roleId,@"role_id",
                          self.key_roleName,@"role_name",
                          self.key_roleLevel,@"role_level",
                          self.key_productdesc, @"describe",
                          self.key_currencyName,@"money",
                          self.key_roleBalence,@"experience",
                          nil];
    NSError* error1;
    NSData* jsonData1 = [NSJSONSerialization dataWithJSONObject:dic1 options:NSJSONWritingPrettyPrinted error:&error1];
    NSString* roleData1 = [[NSString alloc] initWithData:jsonData1 encoding: NSUTF8StringEncoding];
    
    [[JHLCoreEntity sharedInstance] qpjh_superRoleUpdate:roleData1];
    
}
#pragma mark - 渠道登出
-(void)channelsLogout{
     [JHLCoreEntity sharedInstance].delegate = self;
    [[JHLCoreEntity sharedInstance] qpjh_logout];
}
#pragma mark -渠道支付
-(void)channePay {
     [JHLCoreEntity sharedInstance].delegate = self;
    
    /*
     参数KEY      类型      注释
     super_user_id      NSString      登陆回调接口返回的用户标识
     good_id      NSString      商品ID
     good_name      NSString      商品名
     game_order_sn      NSString      游戏订单号
     role_id      NSString      角色ID
     role_name      NSString      角色名
     role_level      NSString      角色等级
     service_id      NSString      服务器ID
     service_name      NSString      服务器名
     money      NSString      充值金额(单位:元)
     remark      NSString      扩展参数
     */
    
    //调用奇葩支付接口
    NSDictionary* dic1 = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.key_productId, @"good_id",
                          self.key_productName, @"good_name",
                          self.key_cpOrderId,@"game_order_sn",
                          self.super_user_id,@"super_user_id",
                          self.key_productPrice, @"money",
                          self.key_serverId,@"service_id",
                          self.key_serverName,@"service_name",
                          self.key_roleId,@"role_id",
                          self.key_serverName,@"role_name",
                          self.key_ext,@"remark",
                          nil];
    NSError* error1;
    NSData* jsonData1 = [NSJSONSerialization dataWithJSONObject:dic1 options:NSJSONWritingPrettyPrinted error:&error1];
    NSString* roleData1 = [[NSString alloc] initWithData:jsonData1 encoding: NSUTF8StringEncoding];
    [[JHLCoreEntity sharedInstance] qpjh_superOrder:roleData1];
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

#pragma mark - JHLCoreEntityDelegate


//聚合渠道:上报角色回调
- (void)getUpdateRoleCallBack:(NSDictionary *)result {
    NSLog(@"上报角色回调:%@",result);
}

//选择区服【停止新增用户】回调 当result为1可进入该区服,当result为其他值时,SDK里有错误提示.研发不做任何处理
- (void)canEnterListenCallBack:(NSString *)result {
    NSLog(@"是否可以新增回调:%@",result);
    if ([result isEqualToString:@"1"]) {
        //TODO:可以进入该大区
    } else {
        //当前选择的大区已满或已关闭,引导用户进入新的大区
    }
}

//支付成功回调
- (void)getPaySuccessCallBack:(NSDictionary *)result {
    NSLog(@"支付成功回调:%@",result);
    
    NSDictionary *dict = @{
                           
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsPaySuccess" object:dict];
    
}

//支付失败回调
- (void)getPayFailCallBack:(NSDictionary *)result {
    NSLog(@"支付失败回调:%@",result);
}

//注销, 切换账号回调
- (void)logOutCallBack:(NSString *)result {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsLogoutSucceed" object:nil];
#warning - 在游戏中主动退出SDK, 或者在悬浮窗中切换账号 都会走此回调, 请在此方法中做游戏退出的操作
    NSLog(@"注销, 切换账号回调:%@",result);
    self.super_user_id = @"";
}

- (void)getChannelLoginCallBack:(NSDictionary *)result {
    self.super_user_id = [NSString stringWithFormat:@"%@",result[@"super_user_id"]];
    self.serviceToken = [NSString stringWithFormat:@"%@",result[@"token"]];
    
    NSLog(@"super_user_id == %@, serviceToken = %@ ",self.super_user_id,self.serviceToken );
    
    
    NSDictionary *dict = @{
                           @"Uid":self.super_user_id,
                           @"Token":self.serviceToken,
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsLoginSuccess" object:dict];
    
    [[JHLCoreEntity sharedInstance] showToolBar:QPJHLightQcSDK_TOOLBAR_TOP_LEFT];
}




#pragma mark - 程序将要进入后台
-(void)applicationWillResignActiveNotification:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    
    
}

#pragma mark - 程序将要进入前台
-(void)applicationWillEnterForegroundNotification:(NSNotification *)notification{
    
    [[JHLCoreEntity sharedInstance] applicationWillEnterForeground:notification.object];
    
    NSLog(@"%@",notification);
    
}

#pragma mark - 程序已经进入后台,进入后台不显示该页面暂停定时器
-(void)applicationDidEnterBackgroundNotification:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    [[JHLCoreEntity sharedInstance] applicationDidEnterBackground:notification.object];
    
}

#pragma mark - 程序已经进入前台,继续定时器
-(void)applicationDidBecomeActiveNotification:(NSNotification *)notification{
    
    NSLog(@"%@",notification);
    
}

#pragma mark - 程序退出释放定时器
-(void)applicationWillTerminateNotification:(NSNotification *)notification{
    //释放定时器
    
    NSLog(@"%@",notification);
    
    
    
}




@end
