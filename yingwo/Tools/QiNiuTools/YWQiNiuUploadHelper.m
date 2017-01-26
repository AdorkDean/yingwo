//
//  YWQiNiuUploadHelper.m
//  yingwo
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWQiNiuUploadHelper.h"

static YWQiNiuUploadHelper *_singleInstance = nil;

@implementation YWQiNiuUploadHelper

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleInstance = [[super allocWithZone:NULL] init];
    });
    return _singleInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YWQiNiuUploadHelper shareInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [YWQiNiuUploadHelper shareInstance];
}

@end
