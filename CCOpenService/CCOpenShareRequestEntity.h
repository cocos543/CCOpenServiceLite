//
//  CCOpenShareRequestEntity.h
//  FlowMiner
//
//  Created by Cocos on 2017/5/5.
//  Copyright © 2017年 Cocos. All rights reserved.
//

#import "CCOpenRequestEntity.h"

typedef NS_ENUM(NSInteger, CCOpenShareTo) {
    CCOpenShareToDefault = 0,
    CCOpenShareToQZone,
    CCOpenShareToWeChatTL,
};

@interface CCOpenShareRequestEntity : CCOpenRequestEntity
@property (assign, nonatomic) CCOpenShareTo shareTo;
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *desc;
@property(strong, nonatomic) NSURL *thumbURL;
@end


@interface CCOpenURLShareRequestEntity : CCOpenShareRequestEntity
@property(strong, nonatomic) NSString *urlString;
@end
