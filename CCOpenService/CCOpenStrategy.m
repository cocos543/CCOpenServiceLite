//
//  CCOpenStrategy.m
//  
//
//  Created by 郑克明 on 16/4/12.
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
@end
