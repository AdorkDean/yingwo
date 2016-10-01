//
//  FeildViewModel.m
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FeildViewModel.h"

@implementation FeildViewModel


- (void)setupModelOfCell:(YWSubjectViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    
    //解决cell复用带来的问题
    //移除所有的子试图，再添加
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.backgroundView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    //子view的创建延迟到viewmodel中
    [cell createSubview];

    if (self.subjectArr.count > 0) {
        
        SubjectEntity *subject          = [self.subjectArr objectAtIndex:indexPath.row];
        cell.fieldListView.subject.text = subject.title;
        [cell.fieldListView.leftImageView sd_setImageWithURL:[NSURL URLWithString:subject.img]
                                            placeholderImage:[UIImage imageNamed:@"Row"]];
        
        if (self.topicArr.count > 0) {
            
            NSArray *topicArr = [self.topicArr objectAtIndex:indexPath.row];
            [cell addTopicListViewBy:topicArr];
        }
        
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

- (void)requestTopicSubjectListWithUrl:(NSString *)url
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

- (void)requestTopicListWithSubjectArr:(NSArray *)subjectArr
                               success:(void (^)(NSArray *topicArr))success
                               failure:(void (^)(NSString *error))failure{
    

    
    //存放的是数组，存放TopicEntity的数组
    NSMutableArray *topicArr        = [[NSMutableArray alloc] init];
    __block NSUInteger currentIndex = 0;
    
    
    //weakself 避免循环引用，是程序崩溃 FieldViewModelHelper 是单例
    FieldViewModelHelper *fieldHelper              = [FieldViewModelHelper shareInstance];
    __weak typeof (FieldViewModelHelper) *weakself = fieldHelper;
    
    weakself.singleSuccessBlock = ^(NSArray *topic){
        
        [topicArr addObject:topic];
        currentIndex ++;
        
        if (subjectArr.count == topicArr.count) {
            success(topicArr);
        }
        else if(topicArr.count < subjectArr.count)
        {
            SubjectEntity *subject = [subjectArr objectAtIndex:currentIndex];
            
            NSDictionary *paramaters = @{@"subject_id":subject.subject_id,
                                         @"recommended":@1};
            
            [self requestTopicListWithUrl:TOPIC_LIST_URL
                               paramaters:paramaters
                                  success:weakself.singleSuccessBlock
                                  failure:weakself.singleFailureBlock];
        }
        
        
    };
    
    if (subjectArr.count > 0) {
        
        SubjectEntity *subject = [subjectArr objectAtIndex:0];
        
        NSDictionary *paramaters = @{@"subject_id":subject.subject_id,
                                     @"recommended":@1};
        
        [self requestTopicListWithUrl:TOPIC_LIST_URL
                           paramaters:paramaters
                              success:weakself.singleSuccessBlock
                              failure:weakself.singleFailureBlock];
        

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

@end
