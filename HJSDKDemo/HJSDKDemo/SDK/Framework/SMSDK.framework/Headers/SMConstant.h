//
//  SMConstant.h
//  SMSDK
//
//  Created by zunshanli on 2017/6/7.
//  Copyright © 2017年 shangminet. All rights reserved.
//

#ifndef SMConstant_h
#define SMConstant_h

#import <Foundation/Foundation.h>

//消息通知
extern NSString * const SMSDKInitDidFinishNotification;             //SDK初始化完成通知
extern NSString * const SMSDKLoginNotification;                     //SDK登录完成通知
extern NSString * const SMSDKPayResultNotification;                 //SDK支付结果通知
extern NSString * const SMSDKLogoutNotification;                    //SDK注销通知

//消息通知参数
extern NSString * const kSMSDKSuccessResult;                        //发送通知的参数,成功
extern NSString * const kSMSDKFailedResult;                         //发送通知的参数,失败
extern NSString * const kSMSDKUserCancelResult;                     //发送通知的参数,用户取消/关闭,仅支付或登录时候触发

//在userinfo中返回数据的key
extern NSString * const kSMSDKLoginTokenKey;                        //登录成功后返回的token值
extern NSString * const kSMSDKLogoutToGuidKey;                      //注销成功后返回当前注销用户的guid
extern NSString * const kSMSDKPayOrderIdKey;                        //支付结果通知返回订单号
extern NSString * const kSMSDKErrorShowKey;                         //通知回调错误显示信息, NSString
extern NSString * const kSMSDKErrorInfoKey;                         //通知回调错误详细信息, NSError对象或NSString

//错误信息
extern NSString * const kSMSDKInitError;                            //SDK没有初始化或初始化错误
extern NSString * const kSMSDKNetError;                             //网络错误
extern NSString * const kSMSDKInfoError;                            //获取信息错误
extern NSString * const kSMSDKPayInfoError;                         //支付信息不完整
extern NSString * const kSMSDKLoginError;                           //登录失败
extern NSString * const kSMSDKPayError;                             //支付失败
extern NSString * const kSMSDKUnkonwError;                          //未知错误

#endif /* SMConstant_h */
