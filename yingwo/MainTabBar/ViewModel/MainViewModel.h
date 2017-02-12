//
//  MainViewModel.h
//  yingwo
//
//  Created by apple on 2017/2/10.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "BaseViewModel.h"
#import "BadgeCount.h"

typedef enum : NSUInteger {
    HomeBadgeModel,
    CommentBadgeModel,
    LikeBadgeModel,
    
} BadgeModel;

typedef void(^BadgeBlock)(int bageCount,BadgeModel badgeModel);

@interface MainViewModel : BaseViewModel

@property (nonatomic, strong)BadgeBlock badgeBlock;

- (void)requestForHomeBadgeWithUrl:(NSString *)url;

- (void)requestForCommentBadgeWithUrl:(NSString *)url;

- (void)requestForLikeBadgeWithUrl:(NSString *)url;


@end
