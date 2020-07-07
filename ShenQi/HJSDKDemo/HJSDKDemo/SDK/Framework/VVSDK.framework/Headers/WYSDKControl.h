//
//  WYSDKControl.h
//  WYSDK
//
//  Created by Weep Yan on 16/5/10.
//  Copyright © 2016年 Weep Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VVCallBack.h"
#import "VVDefines.h"
#import "VVConstants.h"
@class VVPay;

#define resultState result[@"state"]
#define resultMessage result[@"message"]
#define resultDesc result[@"desc"]
#define isStateSuccess(result) ([result[@"state"] intValue]==1)
#define isStateAccountNotExist(result) ([result[@"state"] intValue]==24 || [result[@"state"] intValue]==111)

@interface WYSDKControl : NSObject

+ (WYSDKControl *)sharedInstance;

@property (nonatomic, assign) BOOL isReg;
@property(nonatomic) BOOL isEnterGame;
@property(nonatomic) NSTimeInterval loginDelayTime;
@property(nonatomic) NSTimeInterval loginTime;
@property(nonatomic) BOOL cancelLogin;

- (void)sdkControlInit:(VVViewCallBack)callback;
- (void)regWithPhoneNumber:(NSString *)phoneNumber code:(NSString *)code password:(NSString *)password callBack:(VVViewCallBack)callBack;
- (void)fastRegWithPassword:(NSString *)password callback:(VVViewCallBack)callback;
/**
 *  发送手机验证码
 *  @param type  1注册  2密码重置
 */
- (void)reqPhoneCodeWithPhoneNumber:(NSString *)phoneNumber type:(NSString *)type callback:(VVViewCallBack)callback;
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password callBack:(VVViewCallBack)callBack;
/// 系列游戏登录接口
- (void)seriesLoginWithUserName:(NSString *)userName password:(NSString *)password callBack:(VVViewCallBack)callBack;
- (void)loginWithReceiptId:(NSString *)receiptId userName:(NSString *)userName callBack:(VVViewCallBack)callBack;


- (void)logoutWithUserId:(NSString *)userId callback:(VVHttpDataCallBack)callback;

- (void)updatePassword:(NSString *)password
           newPassword:(NSString *)newPassword
              callBack:(VVViewCallBack)callBack;

- (void)forgotPassword:(NSString *) password phoneNumber:(NSString *)phoneNumber detectCode:(NSString*)detectCode callback:(VVHttpDataCallBack)callback;

- (void)bindPhoneWithUserId:(NSString *) userId
                phoneNumber:(NSString *) phoneNumber
                    msgCode:(NSString *) msgCode
                   callback:(VVViewCallBack)callback;

- (void)applePayWithOutOrderNo:(NSString *)outOrderNo
                         money:(NSString *)money
                        gMoney:(NSString *)gMoney
                     ProductID:(NSString *)productID
         is_SandBoxEnvironment:(BOOL)is_sandboxenvironment;


- (void)vvPayOrderWithOrderId:(NSString *)orderId
                        money:(NSInteger)money
                    productId:(NSString *)productId
                  productName:(NSString *)productName
                  productDesc:(NSString *)productDesc
                    notifyUrl:(NSString *)notifyUrl
                    extension:(NSString *)extension
                   payChannel:(VVHappyParams)payChannel
                  isPayInside:(BOOL)isPayInside
              isUploadRoleLog:(BOOL)isUploadRoleLog
                     callback:(VVViewCallBack)callback;

/// 充值前置条件
/// @param pay pay description
/// @param completionHandle (code: msg) - (-1 接口错误提示, 1 可以充值, 2 弹实名, 3 充值限制)
- (void)rechargeFrontWithPay:(VVPay *)pay completionHandle:(void (^)(int, NSString *))completionHandle;

- (BOOL) hasErrorWithResult:(id)result error:(NSError *)error;

/// API 请求成功，但业务失败提示
+ (void)showError:(NSDictionary *)result;
/// API 请求成功，但业务失败提示
+ (NSString *)getError:(NSDictionary *)result;

@end
