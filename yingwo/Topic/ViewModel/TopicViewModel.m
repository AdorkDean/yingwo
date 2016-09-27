//
//  TopicViewModel.m
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TopicViewModel.h"

@implementation TopicViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupRACComand];
    }
    return self;
}

- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return @"topicCell";
    }
    else
    {
        return @"segmentCell";
    }
}

- (void)setupRACComand {
    
    @weakify(self);
    self.fecthTieZiEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            RequestEntity *requestEntity = (RequestEntity *)input;
            
            NSDictionary *paramaters = nil;
        
            paramaters = @{@"topic_id":@(requestEntity.topic_id),
                            @"start_id":@(requestEntity.start_id)};
            
            
            [self requestTieZiWithUrl:TIEZI_URL
                           paramaters:paramaters
                              success:^(NSArray *tieZi) {
                                  
                                  [subscriber sendNext:tieZi];
                                  [subscriber sendCompleted];
                                  
                              } error:^(NSURLSessionDataTask *task, NSError *error) {
                                  [subscriber sendError:error];
                              }];
            
            return nil;
        }];
    }];
    
}


- (void)requestTopicDetailInfoWithUrl:(NSString *)url
                           paramaters:(id)paramaters
                              success:(void (^)(TopicEntity *topic))success
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
              
              
              TopicResult *topicDetail = [TopicResult mj_objectWithKeyValues:content];
              TopicEntity *topic       = [TopicEntity mj_objectWithKeyValues:topicDetail.info];
              
              success(topic);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"topic detail error:%@",error);
              failure(task,error);
              
          }];

    
}

- (void)requestTopicWithUrl:(NSString *)url
                 paramaters:(id)paramaters
                    success:(void (^)(NSArray *))success
                      error:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
              
              
              TieZiResult *tieZiResult = [TieZiResult mj_objectWithKeyValues:content];
              
              NSArray *tieZiArr        = [TieZi mj_objectArrayWithKeyValuesArray:tieZiResult.info];
              
              
              NSLog(@"tieZiArr:%@",tieZiResult.info);
              
              //需要将返回的url字符串，转化为imageUrl数组
              [self changeImageUrlModelFor:tieZiArr];
              
              success(tieZiArr);
              
              //  NSLog(@"content:%@",content);
              //  NSLog(@"tieZiArr:%@",tieZiResult.info);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              NSLog(@"error:%@",error);
              failure(task,error);
              
          }];
    
}

#pragma mark private method

- (void)changeImageUrlModelFor:(NSArray *)tieZiArr {
    
    for (TieZi *tie in tieZiArr) {
        tie.imageUrlArrEntity = [NSString separateImageViewURLString:tie.img];
        
    }
    
}



@end
