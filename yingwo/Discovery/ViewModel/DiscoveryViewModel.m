//
//  DiscoveryViewModel.m
//  yingwo
//
//  Created by apple on 16/8/27.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DiscoveryViewModel.h"

@implementation DiscoveryViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        [self setupRACComand];
        
    }
    
    return self;
}

- (NSMutableArray *)bannerArr {
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _bannerArr;
}

- (void)setFieldSuccessBlock:(FieldSuccessBlock)fieldSuccessBlock
           fieldFailureBlock:(FieldFailureBlock)fieldFailureBlock {
    
    _fieldSuccessBlock = fieldSuccessBlock;
    _fieldFailureBlock = fieldFailureBlock;
    
}

- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        return @"bannerCell";
    }
    return @"subjectCell";
}

- (void)setupRACComand {
    
    @weakify(self);
    _fecthTopicEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            RequestEntity *requestEntity = (RequestEntity *)input;
            
            //这里刷新只刷新banner大图
            //先获取热点大图
            [self requestHotTopicListWithUrl:requestEntity.URLString
                                     success:^(NSArray *hotArr) {
                                         
                                         [self.bannerArr removeAllObjects];
                                         
                                         [self.bannerArr addObjectsFromArray:hotArr];
                                         
                                         [subscriber sendNext:hotArr];
                                         [subscriber sendCompleted];
                                         
                                     } error:^(NSURLSessionDataTask *task, NSError *error) {
                                         [subscriber sendError:error];
                                     }];

            return nil;
        }];
    }];
    
}

- (void)setupModelForBannerOfCell:(YWDiscoveryBaseCell *)cell model:(DiscoveryViewModel *)model {
    
    if (model == nil) {
        
        if (self.bannerArr.count != 0) {
            
            NSMutableArray *bannerUrlArr = [[NSMutableArray alloc] init];
            
            for (HotTopicEntity *hot in self.bannerArr) {
                
                [bannerUrlArr addObject:hot.big_img];
                                
            }

                cell.mxScrollView.images = bannerUrlArr;
        }
        
    }

}

- (void)setupModelForFieldTopicOfCell:(YWDiscoveryBaseCell *)cell
                                model:(SubjectEntity *)model{
    
    //解决cell复用带来的问题
    //移除所有的子试图，再添加
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.backgroundView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    //子view的创建延迟到viewmodel中
    [cell createSubview];
    
    cell.fieldListView.subject.text = model.title;
    [cell.fieldListView.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.img]
                                        placeholderImage:[UIImage imageNamed:@"Row"]];
    
    if (model.topicArr.count > 0) {
        
        [cell addTopicListViewBy:model.topicArr];
    }
    
}

- (void)requestHotTopicListWithUrl:(NSString *)url
                           success:(void (^)(NSArray *hotArr))success
                             error:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [YWRequestTool YWRequestCachedPOSTWithURL:url
                                    parameter:nil
                                 successBlock:^(id content) {
        
                                     StatusEntity *entity    = [StatusEntity mj_objectWithKeyValues:content];
                                     NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                                     
                                     for (NSDictionary *dic in entity.info) {
                                         
                                         HotTopicEntity *Field = [HotTopicEntity mj_objectWithKeyValues:dic];
                                         
                                         [tempArr addObject:Field];
                                         
                                     }
                                     
                                     success(tempArr);

    } errorBlock:^(id error) {
        
    }];
    
    
}

- (void)requestRecommendTopicListWith:(RequestEntity *)request {
    
    [YWRequestTool YWRequestCachedPOSTWithRequest:request
                                     successBlock:^(id content) {
                                         
                                         StatusEntity *entity    = [StatusEntity mj_objectWithKeyValues:content];
                                         NSArray *subjects = [SubjectEntity mj_objectArrayWithKeyValuesArray:entity.info];
                                         
                                         
                                         self.successBlock(subjects);
                                         
                                     } errorBlock:^(id error) {
                                         
                                     }];
    
}

- (void)requestForField {
    
    [YWRequestTool YWRequestCachedPOSTWithURL:TOPIC_FIELD_URL
                                    parameter:nil
                                 successBlock:^(id content) {
        
                                     StatusEntity *entity    = [StatusEntity mj_objectWithKeyValues:content];
                                     NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                               
                                     for (NSDictionary *dic in entity.info) {
                                   
                                         FieldEntity *field = [FieldEntity mj_objectWithKeyValues:dic];
                                         [tempArr addObject:field];
                                   
                                     }
                               
                                     self.fieldSuccessBlock(tempArr);
                               
    } errorBlock:^(id error) {
        
    }];
    
}

@end
