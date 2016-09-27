//
//  PerfectViewModel.m
//  yingwo
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "PerfectViewModel.h"

@implementation PerfectViewModel

- (void)requestForCollegeWithUrl:(NSString *)url
                         success:(void (^)(College *colleges))success
                         failure:(void (^)(NSString *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];

    [manager POST:fullUrl
       parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              College *college = [College mj_objectWithKeyValues:content];
              success(college);
              
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)requestForAcademyWithUrl:(NSString *)url
                      paramaters:(NSDictionary* )paramaters
                         success:(void (^)(College *colleges))success
                         failure:(void (^)(NSString *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
              College *college = [College mj_objectWithKeyValues:content];
              success(college);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
}

- (void)requestForFinishUserBaseInfoWithUrl:(NSString *)url
                                 paramaters:(NSDictionary *)paramaters
                                    success:(void (^)(StatusEntity *status))success
                                    failure:(void (^)(NSString *error))failure {
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    
    YWHTTPManager *manager = [YWHTTPManager manager];
    //必须要加载cookie，否则无法请求
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content        = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                                 options:NSJSONReadingMutableContainers
                                                                                   error:nil];
                  StatusEntity *statusEntity = [StatusEntity mj_objectWithKeyValues:content];
                  success(statusEntity);
              }
              

              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"@error:%@",error);
              NSLog(@"");
          }];
}

@end
