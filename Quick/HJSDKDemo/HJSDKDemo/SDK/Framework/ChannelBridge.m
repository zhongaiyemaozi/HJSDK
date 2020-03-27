//
//  ChannelBridge.m
//  DynamicLibrary
//
//  Created by bx_zhen on 2019/10/28.
//  Copyright © 2019 CL. All rights reserved.
//

#import "ChannelBridge.h"
#import <SMPCQuickSDK/SMPCQuickSDK.h>


@interface ChannelBridge ()
@property(nonatomic,strong)NSDictionary  *dataModelDict; //数据模型
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,strong)NSObject      *quickNobjcet;
@end

@implementation ChannelBridge

- (void)HJpayResult:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    
//    [[AsInfoKit sharedInstance] payResult:url sourceApplication:sourceApplication];
    
}

//- (BOOL)HJapplication:(UIApplication *)app openURL:(NSURL *)url options: (NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
//
//
//
//}

#pragma mark - 渠道初始化
-(void)initChannel{
    
    
    
#pragma mark - 获取游戏对接参数plist文件的字典数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameParametersList" ofType:@"plist"];
    NSDictionary *parametersDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    self.app_id = parametersDict[@"app_id"]==nil?@"":parametersDict[@"app_id"];
    self.client_id = parametersDict[@"client_id"]==nil?@"":parametersDict[@"client_id"];
    self.client_key = parametersDict[@"client_key"]==nil?@"":parametersDict[@"client_key"];
    self.app_key = parametersDict[@"app_key"]==nil?@"":parametersDict[@"app_key"];
    self.app_Name = parametersDict[@"app_Name"]==nil?@"":parametersDict[@"app_Name"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(smpcQpInitResult:)
                                                 name:kSmpcQuickSDKNotiInitDidFinished
                                               object:nil];
    
    //暂停结束 这个回调可以不用添加
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smpcQpPauseOver:) name:kSmpcQuickSDKNotiPauseOver object:nil];
    
    NSDictionary *initDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"didFinishLaunchingWithOptions"];
    //初始化
    SMPCQuickSDKInitConfigure *cfg = [[SMPCQuickSDKInitConfigure alloc] init];
    cfg.productKey = self.app_key;
    cfg.productCode = self.client_key;
        
    [[SMPCQuickSDK defaultInstance] initWithConfig:cfg application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:initDict];
    
    
}



#pragma mark - 渠道登录
-(void)channelsLogin{
    
    //登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smpcQpLoginResult:) name:kSmpcQuickSDKNotiLogin object:nil];
    
    int error = [[SMPCQuickSDK defaultInstance] login];
    if (error != 0) {
        NSLog(@"%d",error);
    }
    
}




#pragma mark - 渠道上传角色
-(void)channelUploadRole{
    
    
    // 更新角色信息
    SMPCQuickSDKGameRoleInfo *gameRoleInfo = [SMPCQuickSDKGameRoleInfo new];
    gameRoleInfo.serverName = self.key_serverName;
    gameRoleInfo.gameRoleName = self.key_roleName;
    gameRoleInfo.serverId = self.key_serverId; //需要是数字字符串
    gameRoleInfo.gameRoleID = self.uid;
    gameRoleInfo.gameUserBalance = self.key_roleBalence;
    gameRoleInfo.vipLevel = self.key_roleVip;
    gameRoleInfo.gameUserLevel = self.key_roleLevel;
    gameRoleInfo.partyName = self.key_partyName;
    [[SMPCQuickSDK defaultInstance] updateRoleInfoWith:gameRoleInfo isCreate:NO];//如果这个角色是刚刚创建的，这里isCreate可以传YES
    
}
#pragma mark - 渠道登出
-(void)channelsLogout{
    
    //注销
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smpcQpLogoutResult:) name:kSmpcQuickSDKNotiLogout object:nil];
    
    //代码注销
    [[SMPCQuickSDK defaultInstance] logout];
    
}
#pragma mark -渠道支付
-(void)channePay{
    
    //充值结果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(smpcQpRechargeResult:) name:kSmpcQuickSDKNotiRecharge object:nil];
    
//    //充值
//    CFUUIDRef theUUID = CFUUIDCreate(NULL);
//    CFStringRef guid = CFUUIDCreateString(NULL, theUUID);
//    CFRelease(theUUID);
//    NSString *uuidString = [((__bridge NSString *)guid) stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    CFRelease(guid);
    
    SMPCQuickSDKGameRoleInfo *role = [[SMPCQuickSDKGameRoleInfo alloc] init];
    SMPCQuickSDKPayOrderInfo *order = [[SMPCQuickSDKPayOrderInfo alloc] init];
    role.serverName = self.key_serverName; //必填
    role.gameRoleName = self.key_roleName;//@""
    role.serverId = self.key_serverId; //需要是数字字符串
    role.gameRoleID = self.key_roleId;//
    role.gameUserBalance = self.key_roleBalence;//
    role.vipLevel = self.key_roleVip;//
    role.gameUserLevel = self.key_roleLevel;
    role.partyName = self.key_partyName;//
    order.goodsID = self.key_productId; //必填 iap时注意和苹果开发者后台一致，或者渠道映射的
    order.productName = self.key_productName;//必填
    order.cpOrderID = self.key_cpOrderId; //必填 游戏订单号
    order.count = 1;  //必填 数量
    order.amount = [self.key_productPrice floatValue]; //必填 总价
    order.callbackUrl = @"";
    order.extrasParams = self.key_ext;
    //个别渠道要求单价*数量==总价
//    if([SMPCQuickSDK defaultInstance].channelType == 9999){
//        //通过判断渠道号处理特定渠道的参数
//        order.goodsID = @"productlist.name";
//    }
    int error = [[SMPCQuickSDK defaultInstance] payOrderInfo:order
                                                    roleInfo:role];
    if (error!=0)
        NSLog(@"%d", error);
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




#pragma mark -
#pragma mark - Notifications

- (void)smpcQpLoginResult:(NSNotification *)notify {
    NSLog(@"登录成功通知%@",notify);
    int error = [[[notify userInfo] objectForKey:kSmpcQuickSDKKeyError] intValue];
    NSDictionary *userInfo = [notify userInfo];
    if (error == 0) {
        //显示工具条
        [[SMPCQuickSDK defaultInstance] showToolBar:SMPC_QUICK_SDK_TOOLBAR_TOP_LEFT];
        
        
        NSString *uid = [[SMPCQuickSDK defaultInstance] userId];
        self.uid = uid;
        
        NSString *user_name = [[SMPCQuickSDK defaultInstance] userNick];
        //获取user_token，用于从服务器去验证用户信息
        NSString *user_token = userInfo[kSmpcQuickSDKKeyUserToken];
        
        NSDictionary *dict = @{
                               @"Uid":uid,
                               @"Token":user_token,
                               @"user_name":user_name,
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsLoginSuccess" object:dict];
        
    }
}

- (void)smpcQpLogoutResult:(NSNotification *)notify {
    NSLog(@"%s",__func__);
    NSDictionary *userInfo = notify.userInfo;
    int errorCode = [userInfo[kSmpcQuickSDKKeyError] intValue];
    switch (errorCode) {
        case SMPC_QUICK_SDK_ERROR_NONE:
        {
            NSLog(@"注销成功");
            //注销成功
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsLogoutSucceed" object:@""];
        }
            break;
        case SMPC_QUICK_SDK_ERROR_LOGOUT_FAIL:
        default:
        {
            //注销失败
            NSLog(@"注销失败");
        }
            break;
    }
    if (errorCode == SMPC_QUICK_SDK_ERROR_NONE) {
        
    }
    
}

- (void)smpcQpRechargeResult:(NSNotification *)notify{
    NSLog(@"充值结果%@",notify);
    NSDictionary *userInfo = notify.userInfo;
    int error = [[userInfo objectForKey:kSmpcQuickSDKKeyError] intValue];
    switch (error) {
        case SMPC_QUICK_SDK_ERROR_NONE:
        {
            //充值成功
            //QuickSDK订单号,cp下单时传入的订单号，渠道sdk的订单号，cp下单时传入的扩展参数
            NSString *orderID = userInfo[kSmpcQuickSDKKeyOrderId];
            NSString *cpOrderID = userInfo[kSmpcQuickSDKKeyCpOrderId];
            
            NSDictionary *orderDict = @{
                                        @"orderID":orderID,
                                        @"cpOrderID":cpOrderID,
                                        };
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsPaySuccess" object:orderDict];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"kBridgeOrderSuccend" object:orderDict];
            NSLog(@"充值成功数据：%@,%@",orderID,cpOrderID);
        }
            break;
        case SMPC_QUICK_SDK_ERROR_RECHARGE_CANCELLED:
        case SMPC_QUICK_SDK_ERROR_RECHARGE_FAILED:
        {
            //充值失败
            NSString *orderID = userInfo[kSmpcQuickSDKKeyOrderId];
            NSString *cpOrderID = userInfo[kSmpcQuickSDKKeyCpOrderId];
            NSLog(@"充值失败数据%@,%@",orderID,cpOrderID);
        }
            break;
        default:
            break;
    }
}
- (void)smpcQpPauseOver:(NSNotification *)notify{
    NSLog(@"收到QuickSDK暂停结束通知");
}


- (void)smpcQpInitResult:(NSNotification *)notify {
    NSLog(@"init result:%@",notify);
    NSDictionary *userInfo = notify.userInfo;
    int errorCode = [userInfo[kSmpcQuickSDKKeyError] intValue];
    switch (errorCode) {
        case SMPC_QUICK_SDK_ERROR_NONE:
        {
            NSLog(@"初始化成功");
        }
            break;
        case SMPC_QUICK_SDK_ERROR_INIT_FAILED:
        default:
        {
            //初始化失败
            NSLog(@"渠道初始化失败");
        }
            break;
    }
    
}




@end
