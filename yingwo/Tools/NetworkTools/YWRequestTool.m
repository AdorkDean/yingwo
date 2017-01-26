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

+ (void)YWRequestGETWithRequest:(RequestEntity *)request
                   successBlock:(SuccessBlock)contentBlock
                     errorBlock:(ErrorBlock)errorBlock {
    
    [YWRequestTool YWRequestGETWithURL:request.URLString
                             parameter:request.parameter
                          successBlock:^(id success) {
                               
                               contentBlock(success);
                               
                           } errorBlock:^(id error) {
                               
                               errorBlock([error description]);
                               
                           }];
    
}


@end
