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
        
            if (requestEntity.sort != nil) {
                
                paramaters = @{@"topic_id":@(requestEntity.topic_id),
                               @"start_id":@(requestEntity.start_id),
                               @"page":@(requestEntity.page),
                               @"sort":requestEntity.sort};
            }
            else
            {
                paramaters = @{@"topic_id":@(requestEntity.topic_id),
                               @"start_id":@(requestEntity.start_id)};
            }
            
            if (![requestEntity.URLString isEqualToString: TOPIC_DETAIL_URL]) {
                
                
                [self requestTopicWithUrl:requestEntity.URLString
                               paramaters:paramaters
                                  success:^(NSArray *tieZi) {
                                      
                                      [subscriber sendNext:tieZi];
                                      [subscriber sendCompleted];
                                      
                                  } error:^(NSURLSessionDataTask *task, NSError *error) {
                                      [subscriber sendError:error];
                                  }];

            }
            
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

//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(TopicEntity *)topicEntity
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString *share_title             = [NSString stringWithFormat:@"%@",topicEntity.title];
    NSString *share_descr             = [NSString stringWithFormat:@"%@",topicEntity.field_description];
    NSString *share_thumbURL          = [NSString selectCorrectUrlWithAppendUrl:topicEntity.img];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:share_title
                                                                             descr:share_descr
                                                                         thumImage:share_thumbURL];
    //设置网页地址
    shareObject.webpageUrl            = [NSString stringWithFormat:@"https://share.yingwoo.com/share/topic/%@",topicEntity.topic_id];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject         = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType
                                        messageObject:messageObject
                                currentViewController:self
                                           completion:^(id data, NSError *error) {
                                               if (error) {
                                                   UMSocialLogInfo(@"************Share fail with error %@*********",error);
                                               }else{
                                                   if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                                                       UMSocialShareResponse *resp = data;
                                                       //分享结果消息
                                                       UMSocialLogInfo(@"response message is %@",resp.message);
                                                       //第三方原始返回的数据
                                                       UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                                                       
                                                   }else{
                                                       UMSocialLogInfo(@"response data is %@",data);
                                                   }
                                               }
                                               [self alertWithError:error];
                                           }];
}

//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType withModel:(TopicEntity *)topicEntity
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = [NSString stringWithFormat:@"#%@# (分享自@应我校园) https://share.yingwoo.com/share/topic/%@ #校内事，一起聊#",topicEntity.title,topicEntity.topic_id];
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
        [self alertWithError:error];
    }];
}

//分享错误提示
- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"话题分享成功"];
    }
    else{
        if (error) {
            result = [NSString stringWithFormat:@"分享失败错误码: %d\n",(int)error.code];
        }
        else{
            result = [NSString stringWithFormat:@"分享失败"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"确定", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark private method

- (void)changeImageUrlModelFor:(NSArray *)tieZiArr {
    
    for (TieZi *tie in tieZiArr) {
     //   tie.imageUrlArrEntity = [NSString separateImageViewURLString:tie.img];
        
    }
    
}



@end
