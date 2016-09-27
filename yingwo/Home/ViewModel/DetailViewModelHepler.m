//
//  DetailViewModelHepler.m
//  yingwo
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DetailViewModelHepler.h"

static DetailViewModelHepler *_singleInstance = nil;

//单例，实现多线程
@implementation DetailViewModelHepler

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleInstance = [[super allocWithZone:NULL] init];
    });
    return _singleInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [DetailViewModelHepler shareInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [DetailViewModelHepler shareInstance];
}

@end
