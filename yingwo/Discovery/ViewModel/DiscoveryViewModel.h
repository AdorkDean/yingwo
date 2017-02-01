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
#import "TopicEntity.h"
#import "HotTopicEntity.h"


typedef void(^FieldSuccessBlock)(id content);
typedef void(^FieldFailureBlock)(id failure);

@interface DiscoveryViewModel : BaseViewModel

@property (nonatomic, strong) RACCommand     *fecthTopicEntityCommand;

@property (nonatomic, strong) NSMutableArray *bannerArr;

@property (nonatomic, strong) NSMutableArray *FieldArr;

@property (nonatomic, strong) FieldSuccessBlock fieldSuccessBlock;
@property (nonatomic, strong) FieldFailureBlock fieldFailureBlock;



- (void)setFieldSuccessBlock:(FieldSuccessBlock)fieldSuccessBlock
           fieldFailureBlock:(FieldFailureBlock)fieldFailureBlock;

- (void)setupModelForBannerOfCell:(YWDiscoveryBaseCell *)cell model:(DiscoveryViewModel *)model;

- (void)setupModelForFieldTopicOfCell:(YWDiscoveryBaseCell *)cell
                                model:(FieldEntity *)model;

- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath;



/**
 *  获取社区热门话题（发现上面最上面的banner图片话题，本地设置为3张图片话题,但是可以增加）
 *
 *  @param url
 *  @param success    返回包含HotTopicEntity的数组
 *  @param
 */
 - (void)requestHotTopicListWithUrl:(NSString *)url
                           success:(void (^)(NSArray *hotArr))success
                              error:(void (^)(NSURLSessionDataTask *, NSError *))failure;


/**
 获取推荐话题列表
 
 @param request RequestEntity
 */
- (void)requestRecommendTopicListWith:(RequestEntity *)request;

/**
 领域请求
 */
- (void)requestForField;
@end
