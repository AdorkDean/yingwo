//
//  HotDiscussEntity.m
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "HotDiscussEntity.h"

@implementation HotDiscussEntity

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"count":@"id",
             @"body":@"post_push_body",
             @"imageURL":@"post_push_img",
             @"time":@"push_time",
             @"replyCount":@"post_reply_cnt",
             @"listURL":@"face_list",
             @"tieZi_id":@"post_id",
             @"topic_title":@"topic_title",
             @"create_time":@"post_create_time",
             @"img":@"post_img",
             @"like_cnt":@"post_like_cnt",
             @"reply_cnt":@"post_reply_cnt",
             @"content":@"post_content",};
    
}


@end
