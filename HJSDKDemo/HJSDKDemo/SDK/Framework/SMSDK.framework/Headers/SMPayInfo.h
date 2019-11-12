//
//  SMPayInfo.h
//  SMSDK
//
//  Created by zunshanli on 2017/6/22.
//  Copyright © 2017年 shangminet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMPayInfo : NSObject
//必填参数，所有属性不可以设置为@""或@"0"
@property (nonatomic, copy) NSString *game_sign;            //必填//签名
@property (nonatomic, copy) NSString *game_area;            //必填//角色所在的游戏区,20字符以内
@property (nonatomic, copy) NSString *game_level;           //必填//角色等级,30字符以内
@property (nonatomic, copy) NSString *game_orderid;         //必填//游戏订单号,60字符以内(支付通告会返回该参数)
@property (nonatomic, copy) NSString *game_price;           //必填//商品金额(单位元)(支付通告会返回该参数)
@property (nonatomic, copy) NSString *game_role_id;         //必填//游戏中角色ID信息,30字符以内
@property (nonatomic, copy) NSString *game_role_name;       //必填//游戏中角色名称,30字符以内
@property (nonatomic, copy) NSString *subject;              //必填//道具简介,30字符以内
@property (nonatomic, copy) NSString *notify_id;            //必填//回调通知的ID(不知道怎么填, 可以直接填 @"-1")
                                                                    //(当开放平台配置了多个支付回调地址时才需要填此参数)
//选填的参数，必须传递，但是可以为空
@property (nonatomic, copy) NSString *extends_info_data;    //选填//自定义订单扩展参数,60字符以内

//不需要传递
@property (nonatomic, copy) NSString *game_guid;            //不需要传递//登录后游戏方服务端通过token解析拿到的guid

@end

