//
//  TopicEntity.m
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TopicEntity.h"

@implementation TopicEntity

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"topic_id":@"id",@"field_description":@"description"};
}

@end
