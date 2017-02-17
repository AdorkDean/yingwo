//
//  AnnounceModel.m
//  yingwo
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "AnnounceModel.h"

@implementation AnnounceModel

- (void)requestForQiNiuCertificateSerialNumberWithUrl:(NSString *)url
                                               sucess:(void (^)(NSString *certfifcate))success
                                              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    NSString *fullUrl = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager GET:fullUrl
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             NSLog(@"result:%@",result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error:%@",error);
        failure(task,error);
        
    }];
}

- (void)postTieZiWithRequest:(RequestEntity *)request
                     success:(SuccessBlock)success
                     failure:(ErrorBlock)failure {
    
    [YWRequestTool YWRequestPOSTWithRequest:request
                               successBlock:^(id content) {
        
                                   NSLog(@"贴子发布发布成功");
                                   NSLog(@"result%@",content);
                                   success(content);
    } errorBlock:^(id error) {
        NSLog(@"贴子发布发布失败");
        failure(error);
    }];
    
}

@end
