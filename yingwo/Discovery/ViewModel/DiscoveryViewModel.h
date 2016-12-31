//
//  DiscoveryViewModel.h
//  yingwo
//
//  Created by apple on 16/8/27.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWDiscoveryBaseCell.h"
#import "FeildViewModel.h"

#import "FieldEntity.h"
#import "SubjectEntity.h"
#import "TopicEntity.h"
#import "HotTopicEntity.h"


@interface DiscoveryViewModel : NSObject

@property (nonatomic, strong) RACCommand     *fecthTopicEntityCommand;

@property (nonatomic, strong) NSMutableArray *bannerArr;

@property (nonatomic, strong) NSMutableArray *fieldArr;



- (void)setupModelOfCell:(YWDiscoveryBaseCell *)cell model:(DiscoveryViewModel *)model;

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




@end
