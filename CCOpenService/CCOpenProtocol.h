//
//  CCOpenProtocol.h
//  
//
//  Created by Cocos on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#ifndef CCOpenProtocol_h
#define CCOpenProtocol_h

@class CCOpenRespondEntity;
@class CCOpenPayRequestEntity;
@class CCOpenShareRequestEntity;

@protocol CCOpenProtocol <NSObject>
@required
/**
 *  获取单例
 *
 *  @return 单例对象
 */
+ (instancetype)sharedOpenStrategy;

- (void)respondHanderForAuthCode:(NSString *)authCode;

- (void)respondHanderForUserInfo:(NSDictionary *)userInfo;

/**
 *  获取用户登录账号信息
 *
 *  @param respondHander 获取到信息后回调该块
 */
- (void)requestOpenAccount:(void(^)(CCOpenRespondEntity *respond))respondHander;

/**
 *  QQ and WeiBo will return an ACCESS_TOKEN. WeiXin will return a CODE.
 *
 *  Note: This method can be used in some special cases when the server require higher security.
 *
 *  @param respondHander respondHander's block.
 */
- (void)requestOpenAuthCode:(void(^)(CCOpenRespondEntity *))respondHander;

/**
 *  操作其他程序调用当前程序
 *
 *  @param url 其他程序传入的url
 *
 *  @return 是否接收调用
 */
- (BOOL)handleOpenURL:(NSURL *)url;


- (BOOL)isAppInstalled;

- (void)logOutWithAuthCode:(NSString *)authCode;

- (BOOL)openApp;

/**
 *  Pay
 *
 *  @param payEntity
 */
- (void)requestPay:(CCOpenPayRequestEntity *)payEntity respondHander:(void(^)(CCOpenRespondEntity *respond))respondHander;

- (void)updateAppConfig;

/**
 * Share
 */
- (void)shareMessageWith:(CCOpenShareRequestEntity *)shareEntity respondHander:(void(^)(CCOpenRespondEntity *))respondHander;

@end

#endif /* CCOpenProtocol_h */

