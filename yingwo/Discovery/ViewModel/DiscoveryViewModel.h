//
//  DiscoveryViewModel.h
//  yingwo
//
//  Created by apple on 16/8/27.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWDiscoveryBaseCell.h"

#import "FieldEntity.h"
#import "SubjectEntity.h"
#import "TopicEntity.h"
#import "HotTopicEntity.h"


@interface DiscoveryViewModel : NSObject

@property (nonatomic, strong) NSMutableArray *bannerArr;

@property (nonatomic, strong) NSMutableArray *fieldArr;

- (void)setupModelOfCell:(YWDiscoveryBaseCell *)cell model:(DiscoveryViewModel *)model;

- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath;

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
- (void)requestSubjectListWithUrl:(NSString *)url
                       paramaters:(NSDictionary *)paramaters
                          success:(void (^)(NSArray *fieldArr))success
                          failure:(void (^)(NSString *error))failure;


/**
 *  获取话题主题列表
 *
 *  @param url
 *  @param success    返回包含HotTopicEntity的数组
 *  @param
 */
 - (void)requestHotTopicListWithUrl:(NSString *)url
                           success:(void (^)(NSArray *hotArr))success
                           failure:(void (^)(NSString *error))failure;
@end
