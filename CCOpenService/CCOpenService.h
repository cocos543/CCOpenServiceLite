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

+ (instancetype)getOpenServiceWithName:(CCOpenServiceName)name;
- (BOOL)handleOpenURL:(NSURL *)url;
- (void)requestOpenAccount:(void(^)(CCOpenRespondEntity *))respondHander;

/**
 *  QQ and WeiBo will return an ACCESS_TOKEN. WeiXin will return a CODE.
 *  
 *  Note: This method can be used in some special cases when the server require higher security.
 *
 *  @param respondHander respondHander's block.
 */
- (void)requestOpenAuthCode:(void(^)(CCOpenRespondEntity *))respondHander;

@end
