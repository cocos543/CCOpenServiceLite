//
//  CCOpenConfig.m
//  LetsShow
//
//  Created by 郑克明 on 16/4/15.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCOpenConfig.h"

@interface CCOpenConfig ()

@property (nonatomic,strong) NSString *wxAppID;
@property (nonatomic,strong) NSString *wxAppSecret;

@property (nonatomic,strong) NSString *qqAppID;
@property (nonatomic,strong) NSString *qqAppKey;

@property (nonatomic,strong) NSString *wbAppKey;
@property (nonatomic,strong) NSString *wbAppSecret;
@property (nonatomic,strong) NSString *wbRedirectURI;
@end

@implementation CCOpenConfig

static CCOpenConfig *shared;

+(instancetype)sharedConfig{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shared = [[CCOpenConfig alloc] init];
    });
    
    return shared;
}

#pragma mark - WeiXin 配置

+(void)setWeiXinAppID:(NSString *)AppID {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    config.wxAppID = AppID;
}

+(void)setWeiXinAppSecret:(NSString *)AppSecret {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    config.wxAppSecret = AppSecret;
}

+(NSString *)getWeiXinAppID {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    if (!config.wxAppID) {
        @throw [NSException exceptionWithName:@"Get wxAppID error." reason:@"wxAppID is nil" userInfo:nil];
    }
    return config.wxAppID;
}

+(NSString *)getWeiXinAppSecret {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    if (!config.wxAppSecret) {
        @throw [NSException exceptionWithName:@"Get wxAppSecret error." reason:@"wxAppSecret is nil" userInfo:nil];
    }
    return config.wxAppSecret;
}

#pragma mark - QQ 配置

+(void)setQQAppID:(NSString *)AppID {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    config.qqAppID = AppID;
}

+(NSString *)getQQAppID {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    if (!config.qqAppID) {
        @throw [NSException exceptionWithName:@"Get qqAppID error." reason:@"qqAppID is nil" userInfo:nil];
    }
    return config.qqAppID;
}

+(void)setQQAppKey:(NSString *)AppKey {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    config.qqAppKey = AppKey;
}

+(NSString *)getQQAppKey {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    if (!config.qqAppKey) {
        @throw [NSException exceptionWithName:@"Get qqAppKey error." reason:@"qqAppKey is nil" userInfo:nil];
    }
    return config.qqAppKey;
}

#pragma mark - 微博 配置
+(void)setWeiBoAppKey:(NSString *)AppKey {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    config.wbAppKey = AppKey;
}

+(NSString *)getWeiBoAppKey {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    if (!config.wbAppKey) {
        @throw [NSException exceptionWithName:@"Get wbAppKey error." reason:@"wbAppKey is nil" userInfo:nil];
    }
    return config.wbAppKey;
}

+(void)setWeiBoAppSecret:(NSString *)AppSecret {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    config.wbAppSecret = AppSecret;
}

+(NSString *)getWeiBoAppSecret {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    if (!config.wbAppSecret) {
        @throw [NSException exceptionWithName:@"Get wbAppSecret error." reason:@"wbAppSecret is nil" userInfo:nil];
    }
    return config.wbAppSecret;
}

+(void)setWeiBoRedirectURI:(NSString *)URI {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    config.wbRedirectURI = URI;
}

+(NSString *)getWeiBoRedirectURI {
    CCOpenConfig *config = [CCOpenConfig sharedConfig];
    if (!config.wbRedirectURI) {
        @throw [NSException exceptionWithName:@"Get wbRedirectURI error." reason:@"wbRedirectURI is nil" userInfo:nil];
    }
    return config.wbRedirectURI;
}

@end
