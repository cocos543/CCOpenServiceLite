//
//  CCOpenStrategy.h
//  
//
//  Created by 郑克明 on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCOpenStrategy.h"

typedef enum : NSInteger{
    CCOpenServiceNameWeiXin = 0,
    CCOpenServiceNameQQ,
    CCOpenServiceNameWeiBo
} CCOpenServiceName;


@interface CCOpenService : NSObject

+(instancetype)getOpenServiceWithName:(CCOpenServiceName)name;
-(BOOL)handleOpenURL:(NSURL *)url;
-(void)requestOpenAccount:(void(^)(CCOpenRespondEntity *))respondHander;

@end
