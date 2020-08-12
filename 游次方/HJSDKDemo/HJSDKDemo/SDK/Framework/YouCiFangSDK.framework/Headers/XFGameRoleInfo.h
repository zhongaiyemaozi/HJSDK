//
//  XFGameRoleInfo.h
//  XiFaGameSDK
//
//  Created by admin on 2019/12/12.
//  Copyright © 2019 lqz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 上报类型
 */
typedef NS_ENUM(NSInteger, UploadRoleInfoType) {
    UploadRoleInfoTypeNone = 1,     //未定义
    UploadRoleInfoTypeEnterGame,    //进入游戏
    UploadRoleInfoTypeCreateRole,   //创建角色
    UploadRoleInfoTypeRoleLevelUp,  //角色升级
    UploadRoleInfoTypeJoinParty,    //加入帮派
    UploadRoleInfoTypeExitGame,     //退出游戏
    UploadRoleInfoTypeOther         //其他情况
};

@interface XFGameRoleInfo : NSObject

/**
 * 上报类型
 */
@property (nonatomic, assign)UploadRoleInfoType uploadType;

/**
 * 服务器ID
 */
@property (nonatomic, copy)NSString* serverId;

/**
 * 服务器名称
 */
@property (nonatomic, copy)NSString* serverName;

/**
 * 角色ID
 */
@property (nonatomic, copy)NSString* roleId;

/**
 * 角色名称
 */
@property (nonatomic, copy)NSString* roleName;

/**
 * 角色等级
 */
@property (nonatomic, copy)NSString* roleLevel;

/**
 * 角色创建时间（单位：秒）
 */
@property (nonatomic, assign)NSInteger roleCTime;

/**
 * 战力
 */
@property (nonatomic, copy)NSString* fightingCapacity;

/**
 * 帮派名称（不存在写“无帮派”）
 */
@property (nonatomic, copy)NSString* partyName;

/**
 * 转生
 */
@property (nonatomic, copy)NSString* reincarnation;

/**
 * 余额
 */
@property (nonatomic, assign)float balance;

/**
 * VIP等级
 */
@property (nonatomic, copy)NSString* roleVip;

@end

NS_ASSUME_NONNULL_END

