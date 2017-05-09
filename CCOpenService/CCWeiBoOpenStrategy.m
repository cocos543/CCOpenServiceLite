//
//  CCWeiBoOpenStrategy.m
//  
//
//  Created by Cocos on 16/4/19.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCWeiBoOpenStrategy.h"
#import "CCOpenConfig.h"
#import "WeiboSDK/WeiboSDK.h"
#import "WeiboSDK/WeiboUser.h"
@import ObjectiveC.runtime;

@interface CCWeiBoOpenStrategy () <WeiboSDKDelegate>

@end

@implementation CCWeiBoOpenStrategy

+ (NSMutableDictionary *)dictionaryFromeWeiboUser:(WeiboUser *)user{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList([user class], &count);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id value = [user valueForKey:key];
        //Add it to dictionary if it is not nil
        if (key && value) {
            [dict setObject:value forKey:key];
        }
    }
    return dict;
}

#pragma mark - <CCOpenProtocol> 面向CCOpenService
+ (instancetype)sharedOpenStrategy {
    static CCWeiBoOpenStrategy *strategy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        strategy = [[CCWeiBoOpenStrategy alloc] init];
        //向微博注册
        [WeiboSDK enableDebugMode:NO];
        [WeiboSDK registerApp:[CCOpenConfig getWeiBoAppKey]];
        
    });
    return strategy;
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}

/**
 *  获取用户信息
 *  
 *  @param respondHander 异步获取到用户数据后,respondHander将会在主线程中执行
 */
- (void)requestOpenAccount:(void (^)(CCOpenRespondEntity *))respondHander {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = [CCOpenConfig getWeiBoRedirectURI];
    request.scope = @"all";
    //可以不填写....
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
    self.respondHander = respondHander;
}

- (void)requestOpenAuthCode:(void (^)(CCOpenRespondEntity *))respondHander {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = [CCOpenConfig getWeiBoRedirectURI];
    request.scope = @"all";
    //可以不填写....
    request.userInfo = @{@"type":kOPEN_PERMISSION_GET_AUTH_TOKEN};
    [WeiboSDK sendRequest:request];
    self.respondHander = respondHander;
}

- (BOOL)isAppInstalled{
    return YES;
}

- (BOOL)openApp {
    return NO;
}

- (void)logOutWithAuthCode:(NSString *)authCode{
    [WeiboSDK logOutWithToken:authCode delegate:nil withTag:@"251"];
}

- (void)updateAppConfig {

}

- (void)shareMessageWith:(CCOpenShareRequestEntity *)shareEntity respondHander:(void(^)(CCOpenRespondEntity *))respondHander {
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = shareEntity.title;
    webpage.description = shareEntity.desc;
    webpage.thumbnailData = [NSData dataWithContentsOfURL:shareEntity.thumbURL];
    webpage.webpageUrl = [(CCOpenURLShareRequestEntity *)shareEntity urlString];
    message.mediaObject = webpage;
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = [CCOpenConfig getWeiBoRedirectURI];
    authRequest.scope = @"all";
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    [WeiboSDK sendRequest:request];
    
    self.respondHander = respondHander;
}

#pragma mark - Private
- (void)respondHanderForAuthCode:(NSString *)authCode{
    CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
    entity.type = CCOpenEntityTypeWeiBoAuthCode;
    entity.data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:authCode, @"authCode", nil];
    if (self.respondHander) {
        self.respondHander(entity);
    }
}

- (void)respondHanderForUserInfo:(NSDictionary *)userInfo{
    CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
    entity.type = CCOpenEntityTypeWeiBo;
    entity.data = (NSMutableDictionary *)userInfo;
    if (self.respondHander) {
        self.respondHander(entity);
    }
}

#pragma mark - 实现WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    NSLog(@"Request is :%@",request);
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if (response.statusCode != WeiboSDKResponseStatusCodeSuccess) {
        NSLog(@"StatusCode is :%@",@(response.statusCode));
        return;
    }
    
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            resultDic[@"result"] = @"CCSuccess";
        }else {
            resultDic[@"result"] = @"CCErr";
        }
        CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
        entity.type = CCOpenEntityTypeWeiBo;
        entity.data = resultDic;
        if (self.respondHander) {
            self.respondHander(entity);
        }
        
    } else if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        WBAuthorizeResponse *autoResopnse = (WBAuthorizeResponse *)response;
        if ([response.requestUserInfo[@"type"] isEqualToString:kOPEN_PERMISSION_GET_AUTH_TOKEN]) {
            [self respondHanderForAuthCode:autoResopnse.accessToken];
        }else{
            [WBHttpRequest requestForUserProfile:autoResopnse.userID withAccessToken:autoResopnse.accessToken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                [self respondHanderForUserInfo:[CCWeiBoOpenStrategy dictionaryFromeWeiboUser:(WeiboUser *)result]];
            }];
        }
    }
    
}
@end
