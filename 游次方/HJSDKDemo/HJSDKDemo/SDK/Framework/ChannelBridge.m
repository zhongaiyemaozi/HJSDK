//
//  ChannelBridge.m
//  DynamicLibrary
//
//  Created by bx_zhen on 2019/10/28.
//  Copyright © 2019 CL. All rights reserved.
//

#import "ChannelBridge.h"
#import <YouCiFangSDK/XiFaSDKManager.h>
#import <CommonCrypto/CommonDigest.h>




@interface ChannelBridge ()
@property(nonatomic,strong)NSDictionary  *dataModelDict; //数据模型
@property(nonatomic,copy)NSString *appKey;
@property(nonatomic,copy)NSString *PUBLIC_KEY;
@end

@implementation ChannelBridge

#pragma mark - 渠道初始化
-(void)initChannel{
#pragma mark - 获取游戏对接参数plist文件的字典数据
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"GameParametersList" ofType:@"plist"];
        NSDictionary *parametersDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        self.app_id = parametersDict[@"app_id"]==nil?@"":parametersDict[@"app_id"];//app_id
        self.client_id = parametersDict[@"channel_id"]==nil?@"":parametersDict[@"channel_id"];//设置横竖屏，横竖屏设置。1 = 竖屏   2 = 横屏
        self.client_key = parametersDict[@"client_key"]==nil?@"":parametersDict[@"client_key"];//appScheme，唯一标识符
        self.app_key = parametersDict[@"app_key"]==nil?@"":parametersDict[@"app_key"];//app_key
    
    //初始化通知回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initNotice:) name:@"XiFaSDKInit" object:nil];
    
    
    
    
    [XiFaSDKManager initializeXiFaSDKWithAppId:self.app_id appKey:self.app_key appScheme:self.client_key direction:[self.client_id intValue]];
    
}



#pragma mark - 渠道登录
-(void)channelsLogin{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotice:) name:@"XiFaSDKLogin" object:nil];
    
    [XiFaSDKManager addLoginView:[self topController]];
    
}

#pragma mark - 查询实名认证
- (void)checkRealName:(id)sender
{
    //查询是否实名认证，结果见回调（注意：登录成功后再调用此方法）
    [XiFaSDKManager checkRealNameVerify];
}



#pragma mark - 渠道上传角色
-(void)channelUploadRole{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRoleNotice:) name:@"XiFaSDKSendRole" object:nil];
    
    //上报
    XFGameRoleInfo* roleInfo = [[XFGameRoleInfo alloc] init];
    //数据类型，1为进入游戏，2为创建角色，3为角色升级，4为退出，5为充值
    if ([self.key_dataType isEqualToString:@"1"]) {
        roleInfo.uploadType = UploadRoleInfoTypeEnterGame;
    }else if([self.key_dataType isEqualToString:@"2"]) {
        roleInfo.uploadType = UploadRoleInfoTypeCreateRole;
    }else if([self.key_dataType isEqualToString:@"3"]) {
        roleInfo.uploadType = UploadRoleInfoTypeCreateRole;
    }else if([self.key_dataType isEqualToString:@"4"]) {
        roleInfo.uploadType = UploadRoleInfoTypeExitGame;
    }else if([self.key_dataType isEqualToString:@"5"]) {
        roleInfo.uploadType = UploadRoleInfoTypeNone;
    }
    
    roleInfo.serverId = self.key_serverId;
    roleInfo.serverName = self.key_serverName;
    roleInfo.roleId = self.key_roleId;
    roleInfo.roleName = self.key_roleName;
    roleInfo.roleLevel = self.key_roleLevel;
    roleInfo.partyName = self.key_partyName;
    roleInfo.roleCTime = [self.key_rolelevelCtime integerValue];
    roleInfo.balance = [self.key_roleBalence floatValue];
    roleInfo.fightingCapacity = @"1";
    roleInfo.reincarnation = @"0";
    roleInfo.roleVip = self.key_roleVip;
    [XiFaSDKManager sendXFGameRoleInfo:roleInfo];
    
}
#pragma mark - 渠道登出
-(void)channelsLogout{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theLoginOut) name:@"XiFaSDKLoginOut" object:nil];
    
    [XiFaSDKManager logout];
}
#pragma mark -渠道支付
-(void)channePay{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payNotice:) name:@"XiFaSDKPaySucc" object:nil];
    
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
    [XiFaSDKManager PayWithMoney:self.key_productPrice ProductId:self.key_productId ProductName:self.key_productName ProductDesc:self.key_productdesc RoleId:self.key_roleId RoleName:self.key_roleName ExtInfo:self.key_cpOrderId ServerId:self.key_serverId ServerName:self.key_serverName];
    
    
    
    
    
}


#pragma mark - private
- (NSDictionary *)createGameSign:(NSDictionary *)dic {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    NSString *sign = @"";
    NSArray *keys = [dict allKeys];
    NSArray *sortKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSInteger i = 0; i < [sortKeys count]; ++i) {
        NSString *v = [dict objectForKey:[sortKeys objectAtIndex:i]];
        if (i == [sortKeys count] - 1) {
            sign = [sign stringByAppendingString:[NSString stringWithFormat:@"%@=%@", [sortKeys objectAtIndex:i], v]];
        } else {
            sign = [sign stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", [sortKeys objectAtIndex:i], v]];
        }
    }
    sign = [sign stringByAppendingString:self.PUBLIC_KEY];
    [dict setObject:[self md5HexDigest:sign] forKey:@"game_sign"];
    return dict;
}

- (NSString *)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", (unsigned int)(result[i])];
    }
    return ret;
}





-(void)theLoginOut
{
    NSLog(@"注销登录成功");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsLogoutSucceed" object:@""];
}


- (void)initNotice:(NSNotification *)notification
{
    NSString *code = [notification.userInfo objectForKey:@"code"];
    NSLog(@"初始化结果----code=%@",code);
    /**
     code返回
     101  初始化成功
     102  初始化失败
     103  网络错误
     **/
//    [XiFaSDKManager addLoginView:self];
}

- (void) loginNotice:(NSNotification *)notification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(realNameVerifyNotice:) name:@"XiFaSDKRealNameVerifySucc" object:nil];
    
    
    //通过sign，去服务器获取uid
    NSString *sign = [notification.userInfo objectForKey:@"sign"];
    NSString *code = [notification.userInfo objectForKey:@"code"];
    NSString *uid = [notification.userInfo objectForKey:@"uid"];
    NSLog(@"登录结果-----sign=%@  code = %@",sign,code);
    
    
    
    NSDictionary *dict = @{
        @"Uid":uid,
        @"Token":sign,
        
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsLoginSuccess" object:dict];
    
    
    
}

- (void)payNotice:(NSNotification *)notification
{
    NSString*code = [notification.userInfo objectForKey:@"code"];
    NSLog(@"支付结果-----code=%@",code);
    /**
     code返回
     301  支付成功
     302  支付失败
     303  网络错误
     306  用户取消支付
     **/
    if ([code isEqualToString:@"301"]) {
        NSLog(@"支付成功");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kJHChannelsPaySuccess" object:nil];
    }else if ([code isEqualToString:@"302"]){
        NSLog(@"支付失败");
        
    }
}

- (void)sendRoleNotice:(NSNotification *)notifacation
{
    NSString *code = [notifacation.userInfo objectForKey:@"code"];
    NSLog(@"上传角色结果----code=%@",code);
    /**
     code返回
     401  上传角色成功
     402  上传角色失败
     403  网络错误
     **/
    
}

- (void)realNameVerifyNotice:(NSNotification *)notifacation
{
    NSString *code = [notifacation.userInfo objectForKey:@"code"];
    int result = [[notifacation.userInfo objectForKey:@"result"] intValue];
    NSLog(@"获取实名认证状态结果----code=%@, result=%d",code,result);
    
    /*
     result: 0:身份信息未设置，年龄未知
     1:身份信息已设置，年龄<8岁
     2:身份信息已设置，8岁<=年龄<16岁
     3:身份信息已设置，16岁<= (年龄) <18岁
     4:身份信息已设置，年龄 >=18岁 (成年)
     */
    
    /**
     code返回
     501  获取实名认证状态成功
     502  获取实名认证状态失败
     **/
}








//post请求（获取uid）
- (void)postWithUrl:(NSString *)url bodyParam:(NSDictionary *)bodyParam success:(void(^)(NSDictionary *response))success fail:(void(^)(NSError *error))fail{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[self stringWithDic:bodyParam] dataUsingEncoding:NSUTF8StringEncoding];
    request.timeoutInterval = 15;
    //创建NSURLSession
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //创建任务
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    success(dic);
                }
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                fail(error);
            });
        }
    }];
    //开始任务
    [task resume];
}
//json 转 字典
- (NSString *)stringWithDic:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    NSArray *allKeys = [dic allKeys];
    if (allKeys.count == 0) {
        return nil;
    }
    NSMutableString *mutString = [NSMutableString string];
    for (NSString *key in allKeys) {
        NSString *value = dic[key];
        if (value) {
            [mutString appendFormat:@"%@=%@&",key,value];
        }
    }
    return [mutString substringToIndex:mutString.length - 1];
}
//MD5
- (NSString*)md5:(NSString*)string{
    const char *cStr = [string UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
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

- (UIViewController *)topController {
    
    UIViewController *topC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (topC.presentedViewController) {
        topC = [self topViewController:topC.presentedViewController];
    }
    return topC;
}

- (UIViewController *)topViewController:(UIViewController *)controller {
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)controller topViewController]];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)controller selectedViewController]];
    } else {
        return controller;
    }
}

@end
