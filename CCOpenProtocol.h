//
//  CCOpenProtocol.h
//  LetsShow
//
//  Created by 郑克明 on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#ifndef CCOpenProtocol_h
#define CCOpenProtocol_h

@class CCOpenRespondEntity;

@protocol CCOpenProtocol <NSObject>
@required
/**
 *  获取单例
 *
 *  @return 单例对象
 */
+(instancetype)sharedOpenStrategy;
/**
 *  获取用户登录帐号信息
 *
 *  @param respondHander 获取到信息后回调该块
 */
-(void)requestOpenAccount:(void(^)(CCOpenRespondEntity *respond))respondHander;
/**
 *  操作其他程序调用当前程序
 *
 *  @param url 其他程序传入的url
 *
 *  @return 是否接收调用
 */
-(BOOL)handleOpenURL:(NSURL *)url;

/**
 *  后续可以增加其他功能,比如分享,收藏等
 */

@end

#endif /* CCOpenProtocol_h */

