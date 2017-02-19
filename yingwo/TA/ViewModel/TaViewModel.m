//
//  TaViewModel.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/29.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TaViewModel.h"

@implementation TaViewModel


- (void)setHeaderImageSuccessBlock:(HeaderImageSuccessBlock)headerImageSuccessBlock
           headerImageFailureBlock:(HeaderImageFailureBlock)failure {
    _headerImageSuccessBlock = headerImageSuccessBlock;
    _headerImageFailureBlock = failure;
}

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

- (void)requestTopicLikeListWithUrl:(NSString *)url
                         paramaters:(NSDictionary *)paramaters
                            success:(void (^)(NSArray *topicArr))success
                            failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content   = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:nil];
                  StatusEntity *entity    = [StatusEntity mj_objectWithKeyValues:content];
                  NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                  
                  for (NSDictionary *dic in entity.info) {
                      
                      TopicEntity *field = [TopicEntity mj_objectWithKeyValues:dic];
                      [tempArr addObject:field];
                      
                  }
                  
                  success(tempArr);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              success(nil);
              NSLog(@"获取我的话题失败");
          }];
    
    
}

- (void)requestUserLikeWithUrl:(NSString *)url
                    paramaters:(NSDictionary *)paramaters
                       success:(void (^)(StatusEntity *status))success
                       failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content   = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:nil];
                  StatusEntity *entity    = [StatusEntity mj_objectWithKeyValues:content];
                  
                  success(entity);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failure(@"网络错误");
          }];
}

- (void)requestForHeaderImageWithURL:(NSString *)URLString {
    
    [YWRequestTool YWRequestPOSTWithURL:URLString
                              parameter:nil
                           successBlock:^(id content) {
                             
                               StatusEntity *status = [StatusEntity mj_objectWithKeyValues:content];
                               self.headerImageSuccessBlock(status.info);
        
    } errorBlock:^(id error) {
        self.headerImageFailureBlock(error);
    }];
    
}


@end
