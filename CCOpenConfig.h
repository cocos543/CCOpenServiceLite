//
//  CCOpenConfig.h
//  LetsShow
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCOpenConfig : NSObject
//微信 配置
+(void)setWeiXinAppID:(NSString *)AppID;
+(NSString *)getWeiXinAppID;

+(void)setWeiXinAppSecret:(NSString *)AppSecret;
+(NSString *)getWeiXinAppSecret;

//QQ 配置
+(void)setQQAppID:(NSString *)AppID;
+(NSString *)getQQAppID;

+(void)setQQAppKey:(NSString *)AppKey;
+(NSString *)getQQAppKey;

//微博 配置
+(void)setWeiBoAppKey:(NSString *)AppKey;
+(NSString *)getWeiBoAppKey;

+(void)setWeiBoAppSecret:(NSString *)AppSecret;
+(NSString *)getWeiBoAppSecret;

+(void)setWeiBoRedirectURI:(NSString *)URI;
+(NSString *)getWeiBoRedirectURI;
@end
