//
//  RongCloudTools.h
//  TEvaluatingSystem
//
//  Created by apple on 2017/2/3.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RongCloudTokenValue)(id rongCloudTokenValue);
typedef void(^RongCloudTokenError)(id rongCloudError);

typedef void(^RongCloudReturnValue)(id rongCloudReturnValue);
typedef void(^RongCloudReturnError)(id rongCloudReturnError);

@interface RongCloudTools : NSObject

+ (void)initCustomConfigurationIn:(id)controller;

+ (void)initRongCloudWithAppKey:(NSString *)key
                          token:(NSString *)token
                        success:(RongCloudReturnValue)success
                        failure:(RongCloudReturnError)failure;

+(void)requestForRongCloudTokenWithURL:(NSString *)URLString
                             parameter:(id)parameter
                   rongCloudTokenValue:(RongCloudTokenValue)rongCloudTokenValue
                   rongCloudTokenError:(RongCloudTokenError)rongCloudTokenError;

+ (NSInteger)getRandomNumber:(NSInteger)from to:(NSInteger)to;

//获取时间戳
+ (NSString *)getTimestamp;

//sha1 加密
+ (NSString *)sha1WithKey:(NSString *)key;

//根据appKey nonce timestamp 获取signature
+ (NSString *)getSignatureWithAppKey:(NSString *)appKey
                               nonce:(NSString *)nonce
                           timestamp:(NSString *)timestamp;

@end
