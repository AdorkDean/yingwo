//
//  TopicViewModel.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TopicListViewModel.h"

@implementation TopicListViewModel

- (void)setupModelOfCell:(YWTopicViewCell *)cell model:(TopicEntity *)model {
    
    if (model != nil) {
        
        cell.topic.text          = model.title;
        cell.numberOfTopic.text  = [NSString stringWithFormat:@"%@贴子",model.post_cnt];
        cell.numberOfFavour.text = [NSString stringWithFormat:@"%@关注",model.like_cnt];
        cell.topic_id            = [model.topic_id intValue];

        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.img]
                              placeholderImage:nil];
        
        //这里注意未关注前user_post_like的初始值为为null，关注后才为1，取消后为0
        if (model.user_post_like == nil || [model.user_post_like intValue] == 0) {
            
            [cell.rightBtn setBackgroundImage:[UIImage imageNamed:@"weiguanzhu"]
                                     forState:UIControlStateNormal];

            [cell.rightBtn addTarget:self
                              action:@selector(addLike:)
                    forControlEvents:UIControlEventTouchUpInside];
            
        }
        else
        {

            [cell.rightBtn addTarget:self
                              action:@selector(cancelLike:)
                    forControlEvents:UIControlEventTouchUpInside];

        }
    }
    
}

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
