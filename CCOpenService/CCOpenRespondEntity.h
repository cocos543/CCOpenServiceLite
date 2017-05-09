//
//  CCOpenRespondEntity.h
//  
//
//  Created by Cocos on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger{
    CCOpenEntityTypeWeiXin = 0,
    CCOpenEntityTypeWeiXinAuthCode,
    CCOpenEntityTypeQQ,
    CCOpenEntityTypeQQAuthCode,
    CCOpenEntityTypeWeiBo,
    CCOpenEntityTypeWeiBoAuthCode
} CCOpenEntityType;

@interface CCOpenRespondEntity : NSObject
@property (nonatomic) CCOpenEntityType type;
@property (nonatomic,strong) NSMutableDictionary *data;
@end
