//
//  CCShareFilterView.h
//  FlowMiner
//
//  Created by Cocos on 2017/5/3.
//  Copyright © 2017年 Cocos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCOpenService.h"


@interface CCShareFilterView : UIView

@property (strong, nonatomic) CCOpenURLShareRequestEntity *shareEntity;

- (void)showFilterViewWithOptions:(NSUInteger)options completeHander:(void(^)(NSString *msg))hander;

- (void)hideFilterView:(BOOL)animated;

@end
