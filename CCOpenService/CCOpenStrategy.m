//
//  CCOpenStrategy.m
//  
//
//  Created by Cocos on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//
#import "CCOpenStrategy.h"

@implementation CCOpenStrategy

+(instancetype)sharedOpenStrategy{
    //Do nothing.
    return nil;
}

- (void)respondHanderForAuthCode:(NSString *)authCode{
    //Do nothing.
}

- (void)respondHanderForUserInfo:(NSDictionary *)userInfo{
    //Do nothing.
}

-(void)requestOpenAccount:(void(^)(CCOpenRespondEntity *respond))respondHander {
	//Do nothing.
}

- (void)requestOpenAuthCode:(void (^)(CCOpenRespondEntity *))respondHander{
    //Do nothing.
}

-(BOOL)handleOpenURL:(NSURL *)url{
    //Do nothing.
    return NO;
}

- (BOOL)isAppInstalled{
    //Do nothing.
    return NO;
}

- (BOOL)openApp {
    //Do nothing
    return NO;
}

- (void)logOutWithAuthCode:(NSString *)authCode{
    //Do nothing.
}

- (void)updateAppConfig {
    //Do nothing.
}

- (void)requestPay:(CCOpenPayRequestEntity *)payEntity respondHander:(void(^)(CCOpenRespondEntity *respond))respondHander{
    //Do nothing.
}

- (void)shareMessageWith:(CCOpenShareRequestEntity *)shareEntity respondHander:(void (^)(CCOpenRespondEntity *))respondHander {
    
}

@end
