//
//  VVCallBack.h
//  WYSDK
//
//  Created by Weep Yan on 16/5/10.
//  Copyright © 2016年 Weep Yan. All rights reserved.
//

#ifndef VVCallBack_h
#define VVCallBack_h

// 网络回调
typedef void (^VVHttpDataCallBack)(id result, NSError *error);
typedef void (^VVViewCallBack)(id result, NSError *error);
typedef void (^VVCallback)(id success, NSError *error);

#endif /* VVCallBack_h */
