//
//  TaViewModel.h
//  yingwo
//
//  Created by 王世杰 on 2016/10/29.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaEntity.h"
#import "TaResult.h"
#import "TopicEntity.h"

@interface TaViewModel : NSObject

@property (nonatomic, assign) int userId;

/**
 *  获取TA的详细资料
 *
 *  @param url        user/info
 *  @param paramaters 一个user_id
 *  @param success    返回TopicEntity
 *  @param failure    失败
 */
- (void)requestTaDetailInfoWithUrl:(NSString *)url
                        paramaters:(id)paramaters
                           success:(void (^)(TaEntity *ta))success
                             error:(void (^)(NSURLSessionDataTask *, NSError *))failure;

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
                            failure:(void (^)(NSString *error))failure;

/**
 *  关注用户
 *
 *  @param url        /User/like
 *  @param paramaters user_id value
 *  @param success
 *  @param failure
 */
- (void)requestUserLikeWithUrl:(NSString *)url
                    paramaters:(NSDictionary *)paramaters
                       success:(void (^)(StatusEntity *status))success
                       failure:(void (^)(NSString *error))failure;

@end
