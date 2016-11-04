//
//  TopicViewModel.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TopicListViewModel.h"

@implementation TopicListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setupRACComand];
        
    }
    return self;
}

- (void)setupRACComand {
    
    @weakify(self);
    _fecthTopicEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            
            RequestEntity *requestEntity = (RequestEntity *)input ;
            
            NSDictionary *paramaters = nil;
            
            //这里是获取用户（我和TA）关注的话题
            if (self.isMyTopic == YES) {
                
                paramaters = @{@"field_id":@(requestEntity.field_id),@"user_id":@(self.user_id)};
                
                [self requestTopicLikeListWithUrl:TOPIC_LIKE_LIST_URL
                                       paramaters:paramaters
                                          success:^(NSArray *topicArr) {
                                              
                                              [subscriber sendNext:topicArr];
                                              [subscriber sendCompleted];
                    
                } failure:^(NSString *error) {
                    
                }];
                
            }
            
            //这里是获取所有话题
            else
            {
                
                paramaters = @{@"subject_id":@(requestEntity.subject_id)};
                
                [self requestTopicListWithUrl:TOPIC_LIST_URL
                                   paramaters:paramaters
                                      success:^(NSArray *topicArr) {
                                          
                                          [subscriber sendNext:topicArr];
                                          [subscriber sendCompleted];
                                          
                                          
                                      } failure:^(NSString *error) {
                                          // [subscriber sendError:error];
                                          
                                      }];
  
            }
            
            
            return nil;
        }];
    }];
    
}


- (void)setupModelOfCell:(YWTopicViewCell *)cell model:(TopicEntity *)model {
    
    if (model != nil) {
        
        cell.topic.text          = model.title;
        cell.numberOfTopic.text  = [NSString stringWithFormat:@"%@贴子",model.post_cnt];
        cell.numberOfFavour.text = [NSString stringWithFormat:@"%@关注",model.like_cnt];
        cell.topic_id            = [model.topic_id intValue];

        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.img]
                              placeholderImage:nil];
        
        //这里注意未关注前user_post_like的初始值为为null，关注后才为1，取消后为0
        
//        Customer *user = [User findCustomer];
//        if ([user.userId intValue] == self.user_id) {
//            
//            [cell.rightBtn addTarget:self
//                              action:@selector(cancelLike:)
//                    forControlEvents:UIControlEventTouchUpInside];
//            
//            [cell.rightBtn setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
//                                     forState:UIControlStateNormal];
//        } else {
//        
//            if (model.user_topic_like != nil && [model.user_topic_like intValue] == 0) {
//                
//                [cell.rightBtn addTarget:self
//                                  action:@selector(addLike:)
//                        forControlEvents:UIControlEventTouchUpInside];
//                
//                [cell.rightBtn setBackgroundImage:[UIImage imageNamed:@"weiguanzhu"]
//                                         forState:UIControlStateNormal];
//                
//            } else {
//            
//                        [cell.rightBtn addTarget:self
//                                          action:@selector(cancelLike:)
//                                forControlEvents:UIControlEventTouchUpInside];
//            
//                        [cell.rightBtn setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
//                                                 forState:UIControlStateNormal];
//            
//            
//                    }
//        }
        
        if (model.user_topic_like != nil && [model.user_topic_like intValue] == 0) {

            [cell.rightBtn addTarget:self
                              action:@selector(addLike:)
                    forControlEvents:UIControlEventTouchUpInside];
            
            [cell.rightBtn setBackgroundImage:[UIImage imageNamed:@"weiguanzhu"]
                                     forState:UIControlStateNormal];

        }
        else
        {
            
            [cell.rightBtn addTarget:self
                              action:@selector(cancelLike:)
                    forControlEvents:UIControlEventTouchUpInside];
            
            [cell.rightBtn setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
                                     forState:UIControlStateNormal];


        }
}
    
}

/**
 *  获取话题
 *
 *  @param url
 *  @param paramaters
 *  @param success
 *  @param failure
 */
- (void)requestTopicListWithUrl:(NSString *)url
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
              
          }];
    
    
}

/**
 *  用户关注的话题
 *
 *  @param url        /Topic/like_list
 *  @param paramaters field_id
 *  @param success      
 *  @param failure
 */
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


/**
 *  话题关注和取消
 *
 *  @param url        Topic/like
 *  @param paramaters 两个参数topic_id value(0取消关注，1关注)
 *  @param success
 *  @param failure
 */

- (void)requestTopicLikeWithUrl:(NSString *)url
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

#pragma mark private method

//关注话题
- (void)addLike:(UIButton *)sender {
    
    [SVProgressHUD showLoadingStatusWith:@""];
    
    YWTopicViewCell *cell = (YWTopicViewCell *)[sender superview];
    
    NSDictionary *paramater = @{@"topic_id":@(cell.topic_id),@"value":@1};
    
    [self requestTopicLikeWithUrl:TOPIC_LIKE_URL
                       paramaters:paramater
                          success:^(StatusEntity *status) {
        
                              if (status.status == YES) {
                                  
                                  [sender setBackgroundImage:[UIImage imageNamed:@"yiguanzhu"]
                                                    forState:UIControlStateNormal];
                                  
                                  //先移除之前已经添加的action，在添加新的action
                                  [sender removeTarget:self
                                                action:@selector(addLike:)
                                      forControlEvents:UIControlEventTouchUpInside];

                                  [sender addTarget:self
                                             action:@selector(cancelLike:)
                                   forControlEvents:UIControlEventTouchUpInside];
                                  
                                  if ([cell.delegate respondsToSelector:@selector(didSelectRightBtnWith:)]) {
                                      [cell.delegate didSelectRightBtnWith:1];
                                  }
                                  
                              }
                              else
                              {
                                  if ([cell.delegate respondsToSelector:@selector(didSelectRightBtnWith:)]) {
                                      [cell.delegate didSelectRightBtnWith:-1];
                                  }

                              }
    } failure:^(NSString *error) {
        
        if ([cell.delegate respondsToSelector:@selector(didSelectRightBtnWith:)]) {
            [cell.delegate didSelectRightBtnWith:-1];
        }

    }];
    
    
}

//取消关注
- (void)cancelLike:(UIButton *)sender {
    
    [SVProgressHUD showLoadingStatusWith:@""];

    YWTopicViewCell *cell = (YWTopicViewCell *)[sender superview];

    NSDictionary *paramater = @{@"topic_id":@(cell.topic_id),@"value":@0};

    [self requestTopicLikeWithUrl:TOPIC_LIKE_URL
                       paramaters:paramater
                          success:^(StatusEntity *status) {
                              
                              if (status.status == YES) {
                                  
                                  [sender setBackgroundImage:[UIImage imageNamed:@"weiguanzhu"]
                                                           forState:UIControlStateNormal];
                                  
                                  //先移除之前已经添加的action，在添加新的action
                                  [sender removeTarget:self
                                                action:@selector(cancelLike:)
                                      forControlEvents:UIControlEventTouchUpInside];
                                  

                                  [sender addTarget:self
                                             action:@selector(addLike:)
                                   forControlEvents:UIControlEventTouchUpInside];
                                  
                                  if ([cell.delegate respondsToSelector:@selector(didSelectRightBtnWith:)]) {
                                      [cell.delegate didSelectRightBtnWith:0];
                                  }

                                  
                              }
                              else
                              {
                                  if ([cell.delegate respondsToSelector:@selector(didSelectRightBtnWith:)]) {
                                      [cell.delegate didSelectRightBtnWith:-1];
                                  }

                              }
                          } failure:^(NSString *error) {
                              
                              if ([cell.delegate respondsToSelector:@selector(didSelectRightBtnWith:)]) {
                                  [cell.delegate didSelectRightBtnWith:-1];
                              }

                          }];

}


@end
