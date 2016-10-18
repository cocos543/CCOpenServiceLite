//
//  CCQQOpenStrategy.m
//  
//
//  Created by 郑克明 on 16/4/18.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCQQOpenStrategy.h"
#import "AFNetworking.h"
#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "CCOpenConfig.h"

@interface CCQQOpenStrategy () <TencentSessionDelegate>
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@end

@implementation CCQQOpenStrategy

- (TencentOAuth *)tencentOAuth{
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:[CCOpenConfig getQQAppID] andDelegate:self];
    }
    return _tencentOAuth;
}

#pragma mark - <CCOpenProtocol> 面向CCOpenService
+ (instancetype)sharedOpenStrategy{
    static CCQQOpenStrategy *strategy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        strategy = [[CCQQOpenStrategy alloc] init];
    });
    return strategy;
}

- (BOOL)handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

/**
 *  获取用户信息
 *
 *  @param respondHander 异步获取到用户数据后,respondHander将会在主线程中执行
 */
- (void)requestOpenAccount:(void (^)(CCOpenRespondEntity *))respondHander{
    //@"get_simple_userinfo"
    NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO, nil];
    [self.tencentOAuth authorize:permissions inSafari:NO];
    self.respondHander = respondHander;
}

- (void)requestOpenAuthCode:(void (^)(CCOpenRespondEntity *))respondHander{
    NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO,kOPEN_PERMISSION_GET_AUTH_TOKEN, nil];
    [self.tencentOAuth authorize:permissions inSafari:NO];
    self.respondHander = respondHander;
}

- (BOOL)isAppInstalled{
    return YES;
}

- (void)logOutWithAuthCode:(NSString *)authCode{
    NSLog(@"暂时没有实现......");
}

#pragma mark - Private
- (void)respondHanderForAuthCode:(NSString *)authCode{
    CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
    entity.type = CCOpenEntityTypeQQAuthCode;
    entity.data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:authCode, @"authCode", nil];
    self.respondHander(entity);
}

- (void)respondHanderForUserInfo:(NSDictionary *)userInfo{
    CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
    entity.type = CCOpenEntityTypeQQ;
    entity.data = (NSMutableDictionary *)userInfo;
    [entity.data setObject:self.tencentOAuth.openId forKey:@"openid"];
    self.respondHander(entity);
}


#pragma mark - 实现TencentSessionDelegate
- (void)tencentDidLogin{
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length]){
        NSArray *permissions = [self.tencentOAuth valueForKey:@"_permissions"];
        if ([permissions containsObject:kOPEN_PERMISSION_GET_AUTH_TOKEN]) {
            [self respondHanderForAuthCode:self.tencentOAuth.accessToken];
        }else{
            // 记录登录用户的OpenID、Token以及过期时间
            [self.tencentOAuth getUserInfo];
        }
    }else{
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled){
        NSLog(@"用户取消登录");
    }else{
        NSLog(@"登录失败");
    }
}

- (void)tencentDidNotNetWork{
    NSLog(@"无网络连接，请设置网络");
}

/**
 *  获取到用户信息了
 *  调用[self.tencentOAuth getUserInfo]后,回调这个方法
 *  @param response 用户相关信息
 */
- (void)getUserInfoResponse:(APIResponse *)response{
    if (response.retCode != 0) {
        NSLog(@"Get user info Error! RetCode is:%d",response.retCode);
        return;
    }
    [self respondHanderForUserInfo:response.jsonResponse];
}

@end
