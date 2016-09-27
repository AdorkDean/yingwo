//
//  LoginModel.m
//  yingwo
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

- (void)requestForLoginWithUrl:(NSString *)url
                    parameters:(id)parameters
                       success:(void (^)(User *user))success
                       failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure {
    
    NSString *fullUrl = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                  User *customer = [User mj_objectWithKeyValues:content[@"info"]];
                  success(customer);
              }
              else
              {
                  
              }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
        NSLog(@"%@",error);
    }];
}

- (void)requestForHeadImageWithUrl:(NSString *)imageUrl{
    
    NSURL *url              = [NSURL URLWithString:imageUrl];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           
                                        UIImage *headImage = [UIImage imageWithData:data];
            
                                        [YWSandBoxTool saveHeadPortraitIntoCache:headImage];
        
    }];
    
    [task resume];


}

@end
