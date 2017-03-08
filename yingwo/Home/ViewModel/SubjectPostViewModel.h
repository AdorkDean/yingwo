//
//  SubjectPostViewModel.h
//  yingwo
//
//  Created by 王世杰 on 2017/3/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "BaseViewModel.h"
#import "FieldEntity.h"
#import "YWTopicScrView.h"

//typedef void(^FieldSuccessBlock)(id content);
//typedef void(^FieldFailureBlock)(id failure);

@interface SubjectPostViewModel : BaseViewModel

//@property (nonatomic, strong) FieldSuccessBlock fieldSuccessBlock;
//@property (nonatomic, strong) FieldFailureBlock fieldFailureBlock;

//- (void)setFieldSuccessBlock:(FieldSuccessBlock)fieldSuccessBlock
//           fieldFailureBlock:(FieldFailureBlock)fieldFailureBlock;

- (void)setupModelForFieldTopicOfCell:(YWTopicScrView *)topicScrView
                                model:(SubjectEntity *)model;



/**
 获取推荐话题列表
 
 @param request RequestEntity
 */
- (void)requestRecommendTopicListWith:(RequestEntity *)request;

/**
 获取所有推荐话题列表 取subject
 
 @param request RequestEntity
 */
- (void)requestAllRecommendTopicListWith:(RequestEntity *)request;


@end
