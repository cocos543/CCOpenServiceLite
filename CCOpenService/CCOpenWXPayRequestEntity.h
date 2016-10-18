//
//  CCOpenWXPayRequestEntity.h
//
//
//  Created by Cocos on 16/9/29.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "CCOpenPayRequestEntity.h"

@interface CCOpenWXPayRequestEntity : CCOpenPayRequestEntity

@property (strong, nonatomic) NSString *wxAppID;
@property (strong, nonatomic) NSString *partnerID;
@property (strong, nonatomic) NSString *nonceStr;
@property (strong, nonatomic) NSString *prepayID;
@property (strong, nonatomic) NSString *package;
@property (strong, nonatomic) NSString *timestamp;
@property (strong, nonatomic) NSString *sign;

@end
