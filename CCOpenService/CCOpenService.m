//
//  CCOpenService.m
//
//
//  Created by Cocos on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCOpenService.h"
#import "CCWeiXinOpenStrategy.h"
#import "CCQQOpenStrategy.h"
#import "CCWeiBoOpenStrategy.h"

@interface CCOpenService ()

@property (nonatomic,strong) id<CCOpenProtocol> strategy;

@end


@implementation CCOpenService

#pragma mark - 面向用户

/**
 *  获取service实例
 *
 *  @param strategyName 生成context实例时需要指定具体的策略对象名字
 *
 *  @return service实例
 */
+ (instancetype)getOpenServiceWithName:(CCOpenServiceName)name {
    CCOpenStrategy *strategy = nil;
    CCOpenService *service = [[CCOpenService alloc] init];
    switch (name) {
        case CCOpenServiceNameWeiXin:
            strategy = [CCWeiXinOpenStrategy sharedOpenStrategy];
            break;
        case CCOpenServiceNameQQ:
            strategy = [CCQQOpenStrategy sharedOpenStrategy];
            break;
        case CCOpenServiceNameWeiBo:
            strategy = [CCWeiBoOpenStrategy sharedOpenStrategy];
            break;
        default:
            break;
    }
    service.strategy = strategy;
    return service;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [self.strategy handleOpenURL:url];
}

- (void)requestOpenAccount:(void(^)(CCOpenRespondEntity *))respondHander {
    [self.strategy requestOpenAccount:^(CCOpenRespondEntity *respond) {
        respondHander(respond);
    }];
}

- (void)requestOpenAuthCode:(void(^)(CCOpenRespondEntity *))respondHander {
    [self.strategy requestOpenAuthCode:^(CCOpenRespondEntity *respond) {
        respondHander(respond);
    }];
}

- (BOOL)isAppInstalled {
    return [self.strategy isAppInstalled];
}

- (BOOL)openApp {
    return [self.strategy openApp];
}

- (void)logOutWithAuthCode:(NSString *)authCode {
    [self.strategy logOutWithAuthCode:authCode];
}

- (void)updateAppConfig {
    [self.strategy updateAppConfig];
}

- (void)requestPay:(CCOpenPayRequestEntity *)payEntity respondHander:(void(^)(CCOpenRespondEntity *respond))respondHander{
    [self.strategy requestPay:payEntity respondHander:respondHander];
}

- (void)shareMessageWith:(CCOpenShareRequestEntity *)shareEntity respondHander:(void (^)(CCOpenRespondEntity *))respondHander {
    [self.strategy shareMessageWith:shareEntity respondHander:respondHander];
}

@end
