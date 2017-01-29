//
//  YWRequestTool.h
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@interface YWRequestTool : NSObject


/**
 GET请求

 @param urlString URL
 @param parameter 参数
 @param successBlock 请求成功
 @param errorBlock 请求失败
 */
+ (void)YWRequestGETWithURL:(NSString *)urlString
                  parameter:(id)parameter
               successBlock:(SuccessBlock)successBlock
                 errorBlock:(ErrorBlock)errorBlock;

/**
 GET请求
 
 @param request request模型
 @param parameter 参数
 @param successBlock 请求成功
 @param errorBlock 请求失败
 */

+ (void)YWRequestGETWithRequest:(RequestEntity *)request
                   successBlock:(SuccessBlock)contentBlock
                     errorBlock:(ErrorBlock)errorBlock;


/**
 POST请求
 
 @param urlString URL
 @param parameter 参数
 @param successBlock 请求成功
 @param errorBlock 请求失败
 */
+ (void)YWRequestPOSTWithURL:(NSString *)urlString
                   parameter:(id)parameter
                successBlock:(SuccessBlock)returnBlock
                  errorBlock:(ErrorBlock)failureBlock;


/**
 POST请求缓存

 @param urlString URL
 @param parameter 字典参数
 @param contentBlock 请求成功回调
 @param errorBlock 网络请求失败
 */
+ (void)YWRequestCachedPOSTWithURL:(NSString *)urlString
                         parameter:(id)parameter
                      successBlock:(SuccessBlock)contentBlock
                        errorBlock:(ErrorBlock)errorBlock;

/**
 POST请求缓存
 
 @param urlString URL
 @param request RequestEntity参数
 @param contentBlock 请求成功回调
 @param errorBlock 网络请求失败
 */
+ (void)YWRequestCachedPOSTWithRequest:(RequestEntity *)request
                          successBlock:(SuccessBlock)contentBlock
                            errorBlock:(ErrorBlock)errorBlock;
/**
 POST请求
 
 @param request request模型
 @param parameter 参数
 @param successBlock 请求成功
 @param errorBlock 请求失败
 */

+ (void)YWRequestPOSTWithRequest:(RequestEntity *)request
                    successBlock:(SuccessBlock)contentBlock
                      errorBlock:(ErrorBlock)errorBlock;



@end
