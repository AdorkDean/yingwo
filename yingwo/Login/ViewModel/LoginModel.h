//
//  LoginModel.h
//  yingwo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject

/**
 *  登录请求
 *
 *  @param url        部分url
 *  @param parameters 请求参数
 *  @param success    成功
 *  @param failure    失败
 */
- (void)requestForLoginWithUrl:(NSString *)url
                    parameters:(id)parameters
                       success:(void (^)(User *user))success
                       failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

/**
 *  //请求头像
 *
 *  @param url     部分头像url
 *  @param success 成功返回头像
 */
- (void)requestForHeadImageWithUrl:(NSString *)imageUrl;

@end
