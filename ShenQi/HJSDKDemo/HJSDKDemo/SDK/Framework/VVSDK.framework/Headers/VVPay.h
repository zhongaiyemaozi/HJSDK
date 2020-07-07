//
//  VVHappy.h
//  WYSDK
//
//  Created by 唐 on 2017/9/5.
//  Copyright © 2017年 Weep Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VVPay : NSObject

@property(strong, nonatomic) NSString *orderId;//(必填)
@property(assign,nonatomic)  double money;//(必填) 单位分
@property(strong, nonatomic) NSString *productId;//(必填)
@property(strong, nonatomic) NSString *productName;//(必填)
@property(strong, nonatomic) NSString *productDesc;//(可选)
@property(strong, nonatomic) NSString *notifyUrl;//(可填)
@property(strong, nonatomic) NSString *extension;//(可选)

@end
