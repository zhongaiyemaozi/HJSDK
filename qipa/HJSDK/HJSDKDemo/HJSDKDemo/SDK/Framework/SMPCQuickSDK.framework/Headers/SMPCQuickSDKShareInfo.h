//
//  SMPCQuickSDKShareInfo.h
//  SMPCQuickSDK
//
//  Created by xiaoxiao on 2019/2/19.
//

#import <Foundation/Foundation.h>


@interface SMPCQuickSDKShareInfo : NSObject

@property (nonatomic, strong) NSString *type;   //分享类型 1.facebook分享连接 2.facebook分享图片 3.微信分享文本 4.微信分享图片
@property (nonatomic, strong) NSString *title;   //分享标题
@property (nonatomic, strong) NSString *content;   //分享内容
@property (nonatomic, strong) NSString *imgPath;   //分享图片本地地址
@property (nonatomic, strong) NSString *filePath;   //分享文件路径
@property (nonatomic, strong) NSString *imgUrl;   //分享图片网络地址
@property (nonatomic, strong) NSString *sencetype;   //发送场景 0 聊天界面，1 朋友圈，2 收藏
@property (nonatomic, strong) NSString *url;   //分享链接
@property (nonatomic, strong) NSString *shareTo;   //分享到哪里
@property (nonatomic, strong) NSString *extenal;   //额外备注
@property (nonatomic, assign) float width;  //缩略图宽
@property (nonatomic, assign) float height;   //缩略图高

@end


