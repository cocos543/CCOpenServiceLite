//
//  CCQQOpenStrategy.m
//  LetsShow
//
//  Created by 郑克明 on 16/4/18.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCQQOpenStrategy.h"
#import "AFNetworking.h"
#import "TencentOAuth.h"
#import "CCOpenConfig.h"


@interface CCQQOpenStrategy () <TencentSessionDelegate>
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@end

@implementation CCQQOpenStrategy

-(TencentOAuth *)tencentOAuth{
    if (!_tencentOAuth) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:[CCOpenConfig getQQAppID] andDelegate:self];
    }
    return _tencentOAuth;
}

#pragma mark - <CCOpenProtocol> 面向CCOpenService
+(instancetype)sharedOpenStrategy{
    static CCQQOpenStrategy *strategy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        strategy = [[CCQQOpenStrategy alloc] init];
    });
    return strategy;
}

-(BOOL)handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

/**
 *  获取用户信息
 *
 *  @param respondHander 异步获取到用户数据后,respondHander将会在主线程中执行
 */
-(void)requestOpenAccount:(void (^)(CCOpenRespondEntity *))respondHander{
    NSArray *permissions = [NSArray arrayWithObjects:@"get_simple_userinfo", nil];
    [self.tencentOAuth authorize:permissions inSafari:NO];
    
    self.respondHander = respondHander;
}

#pragma mark - 实现TencentSessionDelegate
-(void)tencentDidLogin{
    if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length]){
        // 记录登录用户的OpenID、Token以及过期时间
        [self.tencentOAuth getUserInfo];
    }else{
        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled){
        NSLog(@"用户取消登录");
    }else{
        NSLog(@"登录失败");
    }
}

-(void)tencentDidNotNetWork{
    NSLog(@"无网络连接，请设置网络");
}

/**
 *  获取到用户信息了
 *  调用[self.tencentOAuth getUserInfo]后,回调这个方法
 *  @param response 用户相关信息
 */
-(void)getUserInfoResponse:(APIResponse *)response{
    if (response.retCode != 0) {
        NSLog(@"Get user info Error! RetCode is:%d",response.retCode);
        return;
    }
    CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
    entity.type = CCOpenEntityTypeQQ;
    entity.data = (NSMutableDictionary *)response.jsonResponse;
    [entity.data setObject:self.tencentOAuth.openId forKey:@"openid"];
    self.respondHander(entity);
}

@end
