//
//  YWHTTPManager.m
//  yingwo
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWHTTPManager.h"

@implementation YWHTTPManager

+ (instancetype)manager {
    
    YWHTTPManager *mgr     = [super manager];
    //ajax 添加的请求字段
    [mgr.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    
    //response 返回的是js object 需要序列化
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];

 //   mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    return mgr;
}
@end
