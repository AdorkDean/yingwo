//
//  TopicViewModel.h
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GalleryViewModel.h"
#import "TieZi.h"
#import "TieZiResult.h"
#import "TopicResult.h"
#import "TopicEntity.h"

typedef void(^TopicDetailSuccess)(id topicDetailSuccess);
typedef void(^TopicDetailFailure)(id topicDetailfailure);

typedef void(^TopicLikeSuccess)(id topicLikeSuccess);
typedef void(^TopicLikeFailure)(id topicLikeFailure);

@interface TopicViewModel : GalleryViewModel

@property (nonatomic, strong) TopicDetailSuccess topicDetailSuccess;
@property (nonatomic, strong) TopicDetailFailure topicDetailFailure;

@property (nonatomic, strong) TopicLikeSuccess   topicLikeSuccess;
@property (nonatomic, strong) TopicLikeFailure   topicLikeFailure;


@property (nonatomic, strong) TieZi              *model;

- (void)setTopicDetailSuccess:(TopicDetailSuccess)topicDetailSuccess
                      failure:(TopicDetailFailure)failure;

- (void)setTopicLikeSuccess:(TopicLikeSuccess)topicLikeSuccess
                    failure:(TopicLikeFailure)faliure;

- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath;

/**
 *  获取话题的详细资料
 *
 *  @param url        topic/detail
 *  @param paramaters 一个topic_id
 *  @param success    返回TopicEntity
 *  @param failure    失败
 */
- (void)requestForTopicDetailWithRequest:(RequestEntity *)request;

- (void)requestForTopicLikeWithRequest:(RequestEntity *)request;

//分享文本
- (void)shareTextToPlatformType:(UMSocialPlatformType)platformType withModel:(TopicEntity *)topicEntity;
//分享网页
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withModel:(TopicEntity *)topicEntity;

@end
