//
//  FeildViewModel.h
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FieldViewModelHelper.h"

#import "YWSubjectViewCell.h"

#import "FieldEntity.h"
#import "SubjectEntity.h"
#import "TopicEntity.h"
#import "Topic.h"

@interface FeildViewModel : NSObject

@property (nonatomic, strong)RACCommand *fetchEntityCommand;

//主题数组
@property (nonatomic, strong) NSMutableArray *subjectArr;

//主题下话题数组
@property (nonatomic, strong) NSMutableArray *topicArr;



- (void)setupModelOfCell:(YWDiscoveryBaseCell *)cell indexPath:(NSIndexPath *)indexPath;

/**
 *  获取领域话题列表
 *
 *  @param url
 *  @param success  返回包含FieldEntity的数组
 *  @param failure
 */
- (void)requestTopicFieldWithUrl:(NSString *)url
                         success:(void (^)(NSArray *fieldArr))success
                         failure:(void (^)(NSString *error))failure;

/**
 *  获取话题主题列表
 *
 *  @param url
 *  @param paramaters 含一个参数 field_id 领域id
 *  @param success    返回包含SubjectEntity的数组
 *  @param failure
 */
- (void)requestTopicSubjectListWithUrl:(NSString *)url
                            paramaters:(NSDictionary *)paramaters
                               success:(void (^)(NSArray *fieldArr))success
                               failure:(void (^)(NSString *error))failure;

/**
 *  获取对应主题下的话题数组，对这里是数组
 *
 *  @param subjectArr 主题数组
 *  @param paramaters 两个参数：subject_id和school_id
 *  @param success
 *  @param failure    
 */
- (void)requestTopicListWithSubjectArr:(NSArray *)subjectArr
                               success:(void (^)(NSArray *topicArr))success
                               failure:(void (^)(NSString *error))failure;

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
                        failure:(void (^)(NSString *error))failure;
@end
