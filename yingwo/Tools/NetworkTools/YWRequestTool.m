//
//  YWRequestTool.m
//  yingwo
//
//  Created by apple on 2017/1/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWRequestTool.h"

@implementation YWRequestTool

+ (void)YWRequestGETWithURL:(NSString *)urlString
                  parameter:(id)parameter
               successBlock:(SuccessBlock)contentBlock
                 errorBlock:(ErrorBlock)errorBlock {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:urlString];

    YWHTTPManager *manager = [YWHTTPManager manager];
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];

    [manager GET:fullUrl
      parameters:parameter
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task;
             
             if (httpResponse.statusCode == SUCCESS_STATUS) {
                 
                 NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                 contentBlock(content);
                 
             }
             else {
                 NSLog(@"请求失败不是200");
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             errorBlock([error description]);
             NSLog(@"网络请求错误");
         }];
    
}

+ (void)YWRequestGETWithRequest:(RequestEntity *)request
                   successBlock:(SuccessBlock)contentBlock
                     errorBlock:(ErrorBlock)errorBlock{
    // 根据需要在实现
    
}

+ (void)YWRequestPOSTWithURL:(NSString *)urlString
                   parameter:(id)parameter
                successBlock:(SuccessBlock)contentBlock
                  errorBlock:(ErrorBlock)errorBlock {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:urlString];
    
    YWHTTPManager *manager = [YWHTTPManager manager];
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:parameter
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
             
             if (httpResponse.statusCode == SUCCESS_STATUS) {
                 
                 NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
                 
                 contentBlock(content);
                 
             }
             else {
                 NSLog(@"请求失败不是200");
             }
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             errorBlock([error description]);
             NSLog(@"网络请求错误");

         }];
    
}

+ (void)YWRequestPOSTWithRequest:(RequestEntity *)request
                    successBlock:(SuccessBlock)contentBlock
                      errorBlock:(ErrorBlock)errorBlock {
    

    [YWRequestTool YWRequestPOSTWithURL:request.URLString
                              parameter:request.parameter
                           successBlock:^(id success) {
                               
                               contentBlock(success);
        
    } errorBlock:^(id error) {
        
        errorBlock([error description]);

    }];
    
}

+ (void)YWRequestCachedPOSTWithURL:(NSString *)urlString
                         parameter:(id)parameter
                      successBlock:(SuccessBlock)contentBlock
                        errorBlock:(ErrorBlock)errorBlock {
    
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:urlString];

    [HYBNetworking enableInterfaceDebug:NO];
    
    [HYBNetworking configCommonHttpHeaders:@{@"X-Requested-With":@"XMLHttpRequest"}];

    [HYBNetworking configRequestType:kHYBRequestTypePlainText
                        responseType:kHYBResponseTypeData
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];
    
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];
    [HYBNetworking obtainDataFromLocalWhenNetworkUnconnected:YES];

    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];

    [HYBNetworking postWithUrl:fullUrl
                  refreshCache:YES
                        params:parameter
                       success:^(id response) {
                           
                           contentBlock(response);
        
    } fail:^(NSError *error) {
        DLog(@"网络请求错误：%@",error);
        errorBlock(error);
    }];
    
}

+ (void)YWRequestCachedPOSTWithRequest:(RequestEntity *)request
                          successBlock:(SuccessBlock)contentBlock
                            errorBlock:(ErrorBlock)errorBlock{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:request.URLString];
    
    [HYBNetworking configCommonHttpHeaders:@{@"X-Requested-With":@"XMLHttpRequest"}];
    
    [HYBNetworking configRequestType:kHYBRequestTypePlainText
                        responseType:kHYBResponseTypeData
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];
    
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];
    [HYBNetworking obtainDataFromLocalWhenNetworkUnconnected:YES];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [HYBNetworking postWithUrl:fullUrl
                  refreshCache:YES
                        params:request.parameter
                       success:^(id response) {
                           
                           contentBlock(response);
                           
                       } fail:^(NSError *error) {
                           DLog(@"网络请求错误：%@",error);
                           errorBlock(error);
                       }];

    
}

@end
