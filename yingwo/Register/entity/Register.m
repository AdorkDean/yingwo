//
//  Register.m
//  yingwo
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "Register.h"

@implementation Register

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"customer.userId":@"id"};
}

@end
