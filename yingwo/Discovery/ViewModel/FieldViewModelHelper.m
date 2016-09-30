//
//  FieldViewModelHelper.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FieldViewModelHelper.h"

static FieldViewModelHelper *_singleInstance = nil;

@implementation FieldViewModelHelper

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleInstance = [[super allocWithZone:NULL] init];
    });
    return _singleInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [FieldViewModelHelper shareInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [FieldViewModelHelper shareInstance];
}


@end
