//
//  CCOpenLoginStrategy.h
//  用户描述抽象的登录接口,不做具体的实现
//
//  Created by 郑克明 on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCOpenProtocol.h"
#import "CCOpenRespondEntity.h"


@interface CCOpenStrategy : NSObject <CCOpenProtocol>
@property (nonatomic,copy) void (^respondHander)(CCOpenRespondEntity *);
@end