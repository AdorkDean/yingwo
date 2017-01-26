//
//  YWAvatarBrowserHelper.m
//  yingwo
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWAvatarBrowserHelper.h"

static YWAvatarBrowserHelper *_singleInstance = nil;

@implementation YWAvatarBrowserHelper

+ (YWAvatarBrowserHelper *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleInstance = [[super allocWithZone:NULL] init];
    });
    return _singleInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YWAvatarBrowserHelper shareInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [YWAvatarBrowserHelper shareInstance];
}

@end
