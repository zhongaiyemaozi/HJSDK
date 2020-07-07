//
//  VVDefines.h
//  WYSDK
//
//  Created by 唐 on 2017/9/4.
//  Copyright © 2017年 Weep Yan. All rights reserved.
//

#ifndef VVDefines_h
#define VVDefines_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VVActionType){
    VVActionType_EnterGame  = 1,    //进入游戏
    VVActionType_Levelup    = 2,    //角色升级
    VVActionType_QuitGame   = 3,    //退出游戏
    
};

typedef NS_ENUM(NSInteger, VVView){
    VVView_Login = 1, 	//登录界面
	VVView_Channel =2, 	//选择渠道
    VVView_UserCenter = 3, 	//用户中心
    VVView_Notice = 4,   	 //公告
	VVView_UserCenter_Me = 5,//用户中心_我的
	VVView_UserCenter_Infor = 6,//用户中心_资讯
	VVView_UserCenter_Intro = 7,
	VVView_UserCenter_Gift = 8,
	VVView_UserCenter_Wallet = 9,//用户中心_钱包
    VVView_UserCenter_More = 10,//用户中心_其它
    VVView_UserCenter_More_Service = 11,//用户中心_更多_客服
    VVView_UserCenter_More_Activity_detail = 12,//用户中心_更多_活动_活动详情
    VVView_UserCenter_Start_Activity = 13, // 启动-活动
    VVView_UserCenter_Me_RealNameAuth = 14, // 我的-实名认证
    VVView_Pay = 15 // 充值中心
};

typedef NS_ENUM(NSInteger, VVHappyParams){
    VVHappyParams_Platform   = 0, //蛙豆
    VVHappyParams_SParam       = 1, //微信
    VVHappyParams_ZParam     = 2, //阿里支付宝
    VVHappyParams_AParam   = 4, //Apple
    
};

static NSUInteger const kVVOrientationHorizontal = 1; // 横屏
static NSUInteger const kVVOrientationVertical = 2; // 竖屏

#endif /* VVDefines_h */
