//
//  MainViewModel.m
//  yingwo
//
//  Created by apple on 2017/2/10.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "MainViewModel.h"

@implementation MainViewModel

- (void)requestForHomeBadgeWithUrl:(NSString *)url {
    
    [self requestForBadgeWithUrl:url badgeModel:HomeBadgeModel];
}

- (void)requestForCommentBadgeWithUrl:(NSString *)url {
    
    [self requestForBadgeWithUrl:url badgeModel:CommentBadgeModel];

}

- (void)requestForLikeBadgeWithUrl:(NSString *)url {
    
    [self requestForBadgeWithUrl:url badgeModel:LikeBadgeModel];

}

- (void)requestForBadgeWithUrl:(NSString *)url badgeModel:(BadgeModel)model{
    
    [YWRequestTool YWRequestPOSTWithURL:url
                              parameter:nil
                           successBlock:^(id content) {
                               
                               BadgeCount *badgeCnt = [BadgeCount mj_objectWithKeyValues:content];
                               int badgeCount       =  [badgeCnt.info intValue];
                               
                               self.badgeBlock(badgeCount,model);
                               
                           } errorBlock:^(id error) {
                               
                           }];
}


@end
