//
//  CCWeiBoOpenStrategy.m
//  LetsShow
//
//  Created by 郑克明 on 16/4/19.
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
        //only add it to dictionary if it is not nil
        if (key && value) {
            [dict setObject:value forKey:key];
        }
    }
    return dict;
}

#pragma mark - <CCOpenProtocol> 面向CCOpenService
+(instancetype)sharedOpenStrategy{
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

-(BOOL)handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

/**
 *  获取用户信息
 *  
 *  @param respondHander 异步获取到用户数据后,respondHander将会在主线程中执行
 */
-(void)requestOpenAccount:(void (^)(CCOpenRespondEntity *))respondHander{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = [CCOpenConfig getWeiBoRedirectURI];
    request.scope = @"all";
    //可以不填写....
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
    self.respondHander = respondHander;
}

#pragma mark - 实现WeiboSDKDelegate
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    NSLog(@"Request is :%@",request);
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if (response.statusCode != WeiboSDKResponseStatusCodeSuccess) {
        NSLog(@"StatusCode is :%d",response.statusCode);
        return;
    }
    WBAuthorizeResponse *autoResopnse = (WBAuthorizeResponse *)response;
    [WBHttpRequest requestForUserProfile:autoResopnse.userID withAccessToken:autoResopnse.accessToken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
        entity.type = CCOpenEntityTypeWeiBo;
        entity.data = [CCWeiBoOpenStrategy dictionaryFromeWeiboUser:(WeiboUser *)result];
        self.respondHander(entity);
        
    }];
}
@end
