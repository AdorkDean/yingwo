//
//  SubjectEntity.m
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "SubjectEntity.h"

@implementation SubjectEntity


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"subject_id":@"id",@"field_description":@"description"};
}

@end
