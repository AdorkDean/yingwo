//
//  MessageEntity.m
//  yingwo
//
//  Created by apple on 2016/11/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MessageEntity.h"

@implementation MessageEntity

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tieZi_id":@"source_id",
             @"reply_id":@"follow_id",
             @"message_id":@"id",
             @"user_id":@"source_user_id",
             @"user_name":@"source_user_name",
             @"content":@"source_content",
             @"img":@"source_img",
             @"user_face_img":@"source_user_face_img"};
}

@end

