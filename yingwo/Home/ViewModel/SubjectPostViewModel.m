//
//  SubjectPostViewModel.m
//  yingwo
//
//  Created by 王世杰 on 2017/3/6.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "SubjectPostViewModel.h"

@implementation SubjectPostViewModel


- (void)setupModelForFieldTopicOfCell:(YWTopicScrView *)topicScrView
                                model:(SubjectEntity *)model{
    
    //子view的创建延迟到viewmodel中
    
    if (model.topicArr.count > 0) {
        
        [topicScrView addRecommendTopicWith:model.topicArr];
    }
    
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

- (void)requestAllRecommendTopicListWith:(RequestEntity *)request {
    
    [YWRequestTool YWRequestCachedPOSTWithRequest:request
                                     successBlock:^(id content) {
                                         
                                         StatusEntity *entity           = [StatusEntity mj_objectWithKeyValues:content];
                                         NSArray *subjects              = [SubjectEntity mj_objectArrayWithKeyValuesArray:entity.info];
                                         
                                         NSMutableArray *subjectIdArr   = [NSMutableArray arrayWithCapacity:subjects.count];
                                         NSMutableArray *subjectNameArr = [NSMutableArray arrayWithCapacity:subjects.count];
                                         
                                         for (SubjectEntity *subject in subjects) {
                                             [subjectIdArr addObject:subject.subject_id];
                                             [subjectNameArr addObject:subject.title];
                                         }
                                         
                                         NSArray *subjectArr = [[NSArray alloc] initWithObjects:subjectIdArr,subjectNameArr,subjects, nil];
                                         
                                         self.successBlock(subjectArr);
                                         
                                     } errorBlock:^(id error) {
                                         
                                     }];

}

@end
