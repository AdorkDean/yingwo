//
//  DiscoveryViewModel.m
//  yingwo
//
//  Created by apple on 16/8/27.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DiscoveryViewModel.h"

@implementation DiscoveryViewModel

- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        return @"bannerCell";
    }
    return @"discoveryCell";
}

- (void)setupModelOfCell:(YWDiscoveryBaseCell *)cell model:(DiscoveryViewModel *)model {
    
    if (model == nil) {
        
        //获取热点大图
        [self requestHotTopicListWithUrl:HOT_TOPIC_URL
                                           success:^(NSArray *hotArr) {
                                               
                                               _bannerArr = [NSMutableArray arrayWithCapacity:3];
                                               
                                               for (HotTopicEntity *topic in hotArr)
                                               {
                                                   [_bannerArr addObject:topic.big_img];
                                               }
                                               
                                               cell.mxScrollView.images = _bannerArr;

                                           } failure:^(NSString *error) {
                                               
                                           }];

      //  cell.backgroundColor = [UIColor blueColor];
    }

    
    
}

- (void)requestTopicFieldWithUrl:(NSString *)url
                         success:(void (^)(NSArray *fieldArr))success
                         failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:nil
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
                      
                      FieldEntity *field = [FieldEntity mj_objectWithKeyValues:dic];
                      [tempArr addObject:field];
                      
                  }
                  
                  success(tempArr);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];

    
}

- (void)requestSubjectListWithUrl:(NSString *)url
                       paramaters:(NSDictionary *)paramaters
                          success:(void (^)(NSArray *fieldArr))success
                         failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
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
                      
                      SubjectEntity *field = [SubjectEntity mj_objectWithKeyValues:dic];
                      [tempArr addObject:field];
                      
                  }
                  
                  success(tempArr);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
    
    
}

- (void)requestTopicListWithUrl:(NSString *)url
                    paramaters:(NSDictionary *)paramaters
                        success:(void (^)(NSArray *fieldArr))success
                        failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
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
              
          }];
    
    
}

- (void)requestHotTopicListWithUrl:(NSString *)url
                           success:(void (^)(NSArray *hotArr))success
                           failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:nil
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
                      
                      HotTopicEntity *field = [HotTopicEntity mj_objectWithKeyValues:dic];
                      [tempArr addObject:field];
                      
                  }
                  
                  success(tempArr);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
    
    
}


@end
