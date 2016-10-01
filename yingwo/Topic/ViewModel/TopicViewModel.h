//
//  TopicViewModel.h
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TieZiViewModel.h"

#import "TieZi.h"
#import "TieZiResult.h"
#import "TopicResult.h"
#import "TopicEntity.h"

@interface TopicViewModel : TieZiViewModel

@property (nonatomic, strong) TieZi *model;


- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath;

/**
 *  获取话题的详细资料
 *
 *  @param url        topic/detail
 *  @param paramaters 一个topic_id
 *  @param success    返回TopicEntity
 *  @param failure    失败
 */
- (void)requestTopicDetailInfoWithUrl:(NSString *)url
                           paramaters:(id)paramaters
                              success:(void (^)(TopicEntity *topic))success
                                error:(void (^)(NSURLSessionDataTask *, NSError *))failure;


- (void)requestTopicWithUrl:(NSString *)url
                 paramaters:(id)paramaters
                    success:(void (^)(NSArray *))success
                      error:(void (^)(NSURLSessionDataTask *, NSError *))failure;

- (void)requestTopicLikeWithUrl:(NSString *)url
                     paramaters:(NSDictionary *)paramaters
                        success:(void (^)(StatusEntity *status))success
                        failure:(void (^)(NSString *error))failure;
@end
