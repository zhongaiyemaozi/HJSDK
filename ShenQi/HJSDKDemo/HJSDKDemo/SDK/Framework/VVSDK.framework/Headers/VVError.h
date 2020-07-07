//
//  VVError.h
//  WYSDK
//
//  Created by 唐 on 2017/9/7.
//  Copyright © 2017年 Weep Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nullable const VVDomain;

typedef NS_ENUM(NSInteger,VVErrorCode) {
    VVErrorUnknown = 0,
    VVErrorInitedFail =1,
    VVErrorLoginFail =2,
    VVErrorLogoutFail =3,
    VVErrorEnterGameFail = 4,
    VVErrorQuitGameFail = 5,
    VVErrorLevelupFail = 6,

    // network
    VVErrorNetworkException = 7,
    VVErrorServerException = 8,
    VVErrorServerDataException = 9,

    // pay order
    VVErrorPayOrderFail = 10,
    VVErrorPayOrderCancel = 11,
    VVErrorPayOrderTransactionFailed = 12,
    VVErrorPayOrderProductNoexist = 13,
	VVErrorPaySandboxError = 10001,
	
	VVErrorNoLogined = 14,
    VVErrorDataError = 15,
	
	VVErrorPayOrderRestore = 16, //已购买
    VVErrorUserNotAgreedPrivacy = 17,  // 用户未同意协议
    
};

@interface VVError : NSError

+ (instancetype _Nullable )errorWithCode:(NSInteger)code;

+ (instancetype _Nullable )errorWithCode:(NSInteger)code userInfo:(nullable NSDictionary *)dict;


@end
