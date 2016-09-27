//
//  FieldEntity.m
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FieldEntity.h"

@implementation FieldEntity

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"field_id":@"id",@"field_description":@"description"};
}

@end
