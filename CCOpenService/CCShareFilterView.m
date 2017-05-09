//
//  CCShareFilterView.m
//  
//
//  Created by Cocos on 2017/5/3.
//  Copyright © 2017年 Cocos. All rights reserved.
//

#import "CCShareFilterView.h"

#define CC_ACT_Link @"Link"
#define CC_ACT_QQ @"QQ"
#define CC_ACT_QZone @"QZone"
#define CC_ACT_WeChat @"WeChat"
#define CC_ACT_WeChatTL @"WeChatTL"
#define CC_ACT_WeiBo @"WeiBo"

@interface CCShareFilterView () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *servList;

@property (nonatomic,copy) void (^completeHander)(NSString *);


@end

@implementation CCShareFilterView
static NSString * const reuseIdentifierCell = @"reuseIdentifierCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadData];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CCShareCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifierCell];
}

- (void)loadData {
        self.servList = @[@{@"title": @"微信好友", @"imgName": @"CC_WeChat", @"act":CC_ACT_WeChat}, @{@"title": @"朋友圈", @"imgName": @"CC_WeChatTL", @"act":CC_ACT_WeChatTL}, @{@"title": @"QQ好友", @"imgName": @"CC_QQ", @"act":CC_ACT_QQ}, @{@"title": @"QQ空间", @"imgName": @"CC_QZone", @"act":CC_ACT_QZone}, @{@"title": @"新浪微博", @"imgName": @"CC_WeiBo", @"act":CC_ACT_WeiBo}, @{@"title": @"复制链接 ", @"imgName": @"CC_Link", @"act":CC_ACT_Link}];
}

- (void)showFilterViewWithOptions:(NSUInteger)options completeHander:(void(^)(NSString *msg))hander {
    self.completeHander = hander;
    
    UIView *containerView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.tag = 3345;
    [[UIApplication sharedApplication].keyWindow addSubview:containerView];
    
    UIView *maskView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    maskView.tag = 3335;
    maskView.alpha = 0;
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [containerView addSubview:maskView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTapped:)];
    tapGesture.delegate = self;
    [maskView addGestureRecognizer:tapGesture];
    
    CGRect frame = self.frame;
    frame.size.width = maskView.frame.size.width;
    frame.origin.y = maskView.frame.size.height;
    self.frame = frame;
    
    [containerView addSubview:self];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:0 animations:^{
        maskView.alpha = 1;
        
        CGRect frame = self.frame;
        frame.origin.y = frame.origin.y - frame.size.height;
        self.frame = frame;
    } completion:nil];
    
}

- (void)hideFilterView:(BOOL)animated {
    UIView *containerView = [[UIApplication sharedApplication].keyWindow viewWithTag:3345];
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.frame;
            frame.origin.y += frame.size.height;
            self.frame = frame;
            
            UIView *maskView = [[UIApplication sharedApplication].keyWindow viewWithTag:3335];
            maskView.alpha = 0;
        } completion:^(BOOL finished) {
            [containerView removeFromSuperview];
        }];
    }else {
        [containerView removeFromSuperview];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.servList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    NSDictionary *model = self.servList[indexPath.item];
    UIImageView *imgView = [cell viewWithTag:1];
    UILabel *label = [cell viewWithTag:2];
    label.text = model[@"title"];
    imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:model[@"imgName"] ofType:@"png"]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.3 animations:^{
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor whiteColor]];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setBackgroundColor:[CCSimpleTools stringToColor:@"#D9D9D9" opacity:1]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self hideFilterView:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (indexPath.item < self.servList.count) {
            NSDictionary *servDic = self.servList[indexPath.item];
            if ([servDic[@"act"] isEqualToString:CC_ACT_Link]) {
                //Copy link
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.shareEntity.urlString;
                if (self.completeHander) {
                    self.completeHander(@"复制成功");
                }
            }else if ([servDic[@"act"] isEqualToString:CC_ACT_QQ] || [servDic[@"act"] isEqualToString:CC_ACT_QZone]) {
                CCOpenService *service = [CCOpenService getOpenServiceWithName:CCOpenServiceNameQQ];
                if ([servDic[@"act"] isEqualToString:CC_ACT_QZone]) {
                    self.shareEntity.shareTo = CCOpenShareToQZone;
                }
                [service shareMessageWith:self.shareEntity respondHander:^(CCOpenRespondEntity *respondEntity) {
                    NSString *result = respondEntity.data[@"result"];
                    NSString *noticeTxt;
                    if ([result isEqualToString:@"CCSuccess"]) {
                        noticeTxt = @"分享成功";
                    }else {
                        noticeTxt = @"分享失败";
                    }
                    
                    if (self.completeHander) {
                        self.completeHander(noticeTxt);
                    }
                }];
            }else if ([servDic[@"act"] isEqualToString:CC_ACT_WeChat] || [servDic[@"act"] isEqualToString:CC_ACT_WeChatTL]) {
                CCOpenService *service = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiXin];
                if ([servDic[@"act"] isEqualToString:CC_ACT_WeChatTL]) {
                    self.shareEntity.shareTo = CCOpenShareToWeChatTL;
                }
                [service shareMessageWith:self.shareEntity respondHander:^(CCOpenRespondEntity *respondEntity) {
                    NSString *result = respondEntity.data[@"result"];
                    NSString *noticeTxt;
                    if ([result isEqualToString:@"CCSuccess"]) {
                        noticeTxt = @"分享成功";
                    }else {
                        noticeTxt = @"分享失败";
                    }
                    
                    if (self.completeHander) {
                        self.completeHander(noticeTxt);
                    }
                }];
            }else if ([servDic[@"act"] isEqualToString:CC_ACT_WeiBo]) {
                CCOpenService *service = [CCOpenService getOpenServiceWithName:CCOpenServiceNameWeiBo];
                [service shareMessageWith:self.shareEntity respondHander:^(CCOpenRespondEntity *respondEntity) {
                    NSString *result = respondEntity.data[@"result"];
                    NSString *noticeTxt;
                    if ([result isEqualToString:@"CCSuccess"]) {
                        noticeTxt = @"分享成功";
                    }else {
                        noticeTxt = @"分享失败";
                    }
                    
                    if (self.completeHander) {
                        self.completeHander(noticeTxt);
                    }
                }];
            }
        }
    });
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 65.f;
    return CGSizeMake(width, width * 1.15);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 24, 8, 24);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8.f;
}


#pragma mark - Event
- (void)backgroundTapped:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self];
    //Touch in masView
    if (point.y < 0) {
        [self hideFilterView:YES];
    }
}

- (IBAction)confirmAction:(id)sender {
    [self hideFilterView:YES];
}


@end
