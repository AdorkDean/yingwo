//
//  FeildSecondViewModel.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FeildSecondViewModel.h"

@implementation FeildSecondViewModel

//overide 重写函数
- (void)requestTopicListWithSubjectArr:(NSArray *)subjectArr
                               success:(void (^)(NSArray *topicArr))success
                               failure:(void (^)(NSString *error))failure{
    
    //先获取对应学校的id
    Customer *user                  = [User findCustomer];
    NSString *schoolId              = user.school_id;
    
    //存放的是数组，存放TopicEntity的数组
    NSMutableArray *topicArr        = [[NSMutableArray alloc] init];
    __block NSUInteger currentIndex = 0;
    
    
    //weakself 避免循环引用，是程序崩溃 FieldSecondViewModelHelper 是单例
    FieldSecondViewModelHelper *fieldHelper              = [FieldSecondViewModelHelper shareInstance];
    __weak typeof (FieldSecondViewModelHelper) *weakself = fieldHelper;
    
    weakself.singleSuccessBlock = ^(NSArray *topic){
        
        [topicArr addObject:topic];
        currentIndex ++;
        
        if (subjectArr.count == topicArr.count) {
            success(topicArr);
        }
        else if(topicArr.count < subjectArr.count)
        {
            SubjectEntity *subject = [subjectArr objectAtIndex:currentIndex];
            
            NSDictionary *paramaters = @{@"subject_id":subject.subject_id,
                                         @"school_id":schoolId};
            
            [self requestTopicListWithUrl:RECOMMENDED_TOPIC_URL
                               paramaters:paramaters
                                  success:weakself.singleSuccessBlock
                                  failure:weakself.singleFailureBlock];
        }
        
        
    };
    
    if (subjectArr.count > 0) {
        
        SubjectEntity *subject = [subjectArr objectAtIndex:0];
        
        NSDictionary *paramaters = @{@"subject_id":subject.subject_id,
                                     @"school_id":schoolId};
        
        [self requestTopicListWithUrl:RECOMMENDED_TOPIC_URL
                           paramaters:paramaters
                              success:weakself.singleSuccessBlock
                              failure:weakself.singleFailureBlock];
        
        
    }
    
    
}

@end
