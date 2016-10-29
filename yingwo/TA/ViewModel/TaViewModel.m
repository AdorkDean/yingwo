//
//  TaViewModel.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/29.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TaViewModel.h"

@implementation TaViewModel


- (void)requestTaDetailInfoWithUrl:(NSString *)url
                        paramaters:(id)paramaters
                           success:(void (^)(TaEntity *ta))success
                             error:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
              
              
              TaResult *taDetail    = [TaResult mj_objectWithKeyValues:content];
              TaEntity *ta          = [TaEntity mj_objectWithKeyValues:taDetail.info];
              
              success(ta);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"ta detail error:%@",error);
              failure(task,error);
              
          }];

}


@end
