//
//  HotTopicEntity.m
//  yingwo
//
//  Created by apple on 16/9/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "HotTopicEntity.h"

@implementation HotTopicEntity

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"topic_id":@"id",@"field_description":@"description"};
}


@end
