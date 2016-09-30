//
//  FieldSecondViewModelHelper.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FieldSecondViewModelHelper.h"

static FieldSecondViewModelHelper *_singleInstance = nil;

@implementation FieldSecondViewModelHelper

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleInstance = [[super allocWithZone:NULL] init];
    });
    return _singleInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [FieldSecondViewModelHelper shareInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [FieldSecondViewModelHelper shareInstance];
}

@end
