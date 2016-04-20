//
//  CCOpenRespondEntity.h
//  
//
//  Created by 郑克明 on 16/4/12.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger{
    CCOpenEntityTypeWeiXin = 0,
    CCOpenEntityTypeQQ,
    CCOpenEntityTypeWeiBo
} CCOpenEntityType;

@interface CCOpenRespondEntity : NSObject
@property (nonatomic) CCOpenEntityType type;
@property (nonatomic,strong) NSMutableDictionary *data;
@end
