//
//  YWHTTPManager.h
//  yingwo
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/**
 *  继承于 AFHTTPSessionManager
 *  在对 AFNetworking框架使用时，一半不直接使用 AFNetworking 中的类
 */
@interface YWHTTPManager : AFHTTPSessionManager

+ (instancetype)manager;

@end
