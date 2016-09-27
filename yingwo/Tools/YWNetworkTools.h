//
//  XWNetworkTools.h
//  yingwo
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

/**
 *  继承于AFHTTPSessionManager,主要用于判断网络链接
 */
@interface YWNetworkTools : AFHTTPSessionManager

//+ (instancetype)shareNetworkTools;
+ (instancetype)shareNetworkToolsWithBaseUrl;

/**
 *  检测网络状态
 */
+ (void)AFNetworkStatus;

/**
 *  检测是否有网络
 *
 *  @return YES/NO
 */
+ (BOOL)networkStauts;

/*
 *  cookie解释：AFNetwoking在请求之前会去NSHTTPCookieStorage里找cookie并自动带上
 *  不需要手动设置请求cookie
 */

/**
 *  保存cookie
 */
+ (void)cookiesValueWithKey:(NSString *)key;

/**
 *  加载cookie
 */
+ (void)loadCookiesWithKey:(NSString *)key;
/**
 *  删除置顶cookie
 *
 *  @param key 根据的指定key删除cookie
 */
+ (void)deleteCookiesWithKey:(NSString *)key;

@end
