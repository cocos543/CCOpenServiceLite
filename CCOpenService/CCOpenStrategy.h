//
//  CCOpenStrategy.h
//  用户描述抽象的登录接口,不做具体的实现
//
//  Created by 郑克明 on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCOpenProtocol.h"
#import "CCOpenRespondEntity.h"

#define kOPEN_PERMISSION_GET_AUTH_TOKEN @"kOPEN_PERMISSION_GET_AUTH_TOKEN"

@interface CCOpenStrategy : NSObject <CCOpenProtocol>
@property (nonatomic,copy) void (^respondHander)(CCOpenRespondEntity *);
@end