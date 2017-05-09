//
//  CCWeiXinOpenStrategy.m
//  
//
//  Created by Cocos on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCWeiXinOpenStrategy.h"
#import "AFNetworking.h"
#import "WXApi.h"
#import "CCOpenConfig.h"

@interface CCWeiXinOpenStrategy() <WXApiDelegate>

@property (nonatomic,strong) NSString *openID;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *refreshToken;
//token过期时间 2小时 7200秒
@property (nonatomic,strong) NSDate *expiresDate;

@end

@implementation CCWeiXinOpenStrategy

#pragma mark - <CCOpenProtocol> 面向CCOpenService
//由于微信有一个步骤需要设置代理 [WXApi handleOpenURL:url delegate:self]
//所以需要将weixin的strategy设置成单例
+ (instancetype)sharedOpenStrategy {
    static CCWeiXinOpenStrategy *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shared = [[CCWeiXinOpenStrategy alloc] init];
        //向微信注册
        [WXApi registerApp:[CCOpenConfig getWeiXinAppID]];
    });
    return shared;
}

/**
 *  获取用户信息
 *
 *  @param respondHander 异步获取到用户数据后,respondHander将会在主线程中执行
 */
- (void)requestOpenAccount:(void (^)(CCOpenRespondEntity *))respondHander{
    if ([WXApi isWXAppInstalled] == NO ) {
        //没安装微信直接返回nil
        respondHander(nil);
        return;
    }
    //构造SendAuthReq结构体
    SendAuthReq* req = [[SendAuthReq alloc ] init ];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    self.respondHander = respondHander;
}

- (void)requestOpenAuthCode:(void (^)(CCOpenRespondEntity *))respondHander{
    if ([WXApi isWXAppInstalled] == NO ) {
        //没安装微信直接返回nil
        respondHander(nil);
        return;
    }
    //构造SendAuthReq结构体
    SendAuthReq* req = [[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    req.state = kOPEN_PERMISSION_GET_AUTH_TOKEN;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    self.respondHander = respondHander;
}

- (BOOL)handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)isAppInstalled{
    return [WXApi isWXAppInstalled];
}

- (BOOL)openApp {
    return [WXApi openWXApp];
}

- (void)logOutWithAuthCode:(NSString *)authCode{
    NSLog(@"暂时没有实现......");
}

- (void)updateAppConfig {
    [WXApi registerApp:[CCOpenConfig getWeiXinAppID]];
}

/**
 Weixin pay

 @param payEntity CCOpenWXPayRequestEntity *
 @param respondHander respond block
 */
- (void)requestPay:(CCOpenWXPayRequestEntity *)payEntity respondHander:(void(^)(CCOpenRespondEntity *respond))respondHander{
    self.respondHander = respondHander;
    PayReq *request = [[PayReq alloc] init];
    request.openID    = payEntity.wxAppID;
    request.partnerId = payEntity.partnerID;
    request.prepayId  = payEntity.prepayID;
    request.package   = payEntity.package;
    request.nonceStr  = payEntity.nonceStr;
    request.timeStamp = [payEntity.timestamp intValue];
    request.sign      = payEntity.sign;
    
    
    [WXApi sendReq:request];

}

- (void)shareMessageWith:(CCOpenShareRequestEntity *)shareEntity respondHander:(void(^)(CCOpenRespondEntity *))respondHander {
    self.respondHander = respondHander;
    if ([shareEntity isKindOfClass:[CCOpenURLShareRequestEntity class]]) {
        WXMediaMessage *msg = [WXMediaMessage message];
        msg.title = shareEntity.title;
        msg.description = shareEntity.desc;
        
        [msg setThumbImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:shareEntity.thumbURL]]];
        WXWebpageObject *webpage = [WXWebpageObject object];
        webpage.webpageUrl = [(CCOpenURLShareRequestEntity *)shareEntity urlString];
        msg.mediaObject = webpage;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = msg;
        if (shareEntity.shareTo == CCOpenShareToWeChatTL) {
            req.scene = WXSceneTimeline;
        }else {
            req.scene = WXSceneSession;
        }
        [WXApi sendReq:req];
    }
}

#pragma mark - Private
- (void)respondHanderForAuthCode:(NSString *)authCode{
    CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
    entity.type = CCOpenEntityTypeWeiXinAuthCode;
    entity.data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:authCode, @"authCode", nil];
    self.respondHander(entity);
}

- (void)respondHanderForUserInfo:(NSDictionary *)userInfo{
    CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
    entity.type = CCOpenEntityTypeWeiXin;
    entity.data = (NSMutableDictionary *)userInfo;
    self.respondHander(entity);
}

#pragma mark - 实现WXApiDelegate
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]] || [resp isKindOfClass:[SendMessageToWXResp class]]) {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        PayResp *response = (PayResp *)resp;
        switch(response.errCode){
            case WXSuccess:
                resultDic[@"result"] = @"CCSuccess";
                NSLog(@"wx success");
                break;
            case WXErrCodeUserCancel:
                if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
                    NSLog(@"User canceled");
                    return;
                }
                resultDic[@"result"] = @"CCErrCodeUserCancel";
                NSLog(@"wx cancel");
                break;
            default:
                resultDic[@"result"] = @"CCErr";
                NSLog(@"wx fail，retcode=%d",resp.errCode);
                break;
        }
        
        CCOpenRespondEntity *entity = [[CCOpenRespondEntity alloc] init];
        entity.type = CCOpenEntityTypeWeiXin;
        entity.data = resultDic;
        self.respondHander(entity);
    }else if ([resp isKindOfClass:[SendAuthResp class]]){
        
        [self requestUserInfoWithBaseResp:(SendAuthResp *)resp];
        
    }
}

- (void)onReq:(BaseReq *)req {
    NSLog(@"onReq :%@",req);
}

#pragma mark - 授权流程

- (void)requestUserInfoWithBaseResp:(SendAuthResp *)resp{
    NSString *code = [resp code];
    if ([resp.state isEqualToString:kOPEN_PERMISSION_GET_AUTH_TOKEN]) {
        [self respondHanderForAuthCode:code];
    }else{
        NSURL *getTokenURL = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",[CCOpenConfig getWeiXinAppID], [CCOpenConfig getWeiXinAppSecret], code]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        // manager.responseSerializer默认就是期望JSON类型的response
        
        [manager GET:getTokenURL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            responseObject = (NSDictionary *)responseObject;
            if ([responseObject valueForKey:@"access_token"]) {
                self.accessToken  = [responseObject valueForKey:@"access_token"];
                self.openID       = [responseObject valueForKey:@"openid"];
                self.refreshToken = [responseObject valueForKey:@"refreshToken"];
                
                //获取用户信息
                NSURL *getUserInfoURL = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", self.accessToken, self.openID]];
                
                [manager GET:getUserInfoURL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
                    responseObject = (NSDictionary *)responseObject;
                    if ([responseObject valueForKey:@"openid"]) {
                        //成功获取到用户数据,组成实体并且通知主线程的handerBlock
                        [self respondHanderForUserInfo:responseObject];
                    }else{
                        NSLog(@"JSON: %@", responseObject);
                    }
                } failure:^(NSURLSessionDataTask * task, NSError * error) {
                    NSLog(@"Error: %@", error);
                }];
            }else{
                NSLog(@"JSON: %@", responseObject);
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}


@end
