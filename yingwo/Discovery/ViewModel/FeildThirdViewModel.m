//
//  FeildThirdViewModel.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FeildThirdViewModel.h"

@implementation FeildThirdViewModel

//overide 重写函数
- (void)requestTopicListWithSubjectArr:(NSArray *)subjectArr
                               success:(void (^)(NSArray *topicArr))success
                               failure:(void (^)(NSString *error))failure{
    
    
    //存放的是数组，存放TopicEntity的数组
    NSMutableArray *topicArr        = [[NSMutableArray alloc] init];
    __block NSUInteger currentIndex = 0;
    
    
    //weakself 避免循环引用，是程序崩溃 FieldThirdViewModelHelper 是单例
    FieldThirdViewModelHelper *fieldHelper              = [FieldThirdViewModelHelper shareInstance];
    __weak typeof (FieldThirdViewModelHelper) *weakself = fieldHelper;
    
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
                                         @"recommended":@1};
            
            [self requestTopicListWithUrl:TOPIC_LIST_URL
                               paramaters:paramaters
                                  success:weakself.singleSuccessBlock
                                  failure:weakself.singleFailureBlock];
        }
        
        
    };
    
    if (subjectArr.count > 0) {
        
        SubjectEntity *subject = [subjectArr objectAtIndex:0];
        
        NSDictionary *paramaters = @{@"subject_id":subject.subject_id,
                                     @"recommended":@1};
        
        [self requestTopicListWithUrl:TOPIC_LIST_URL
                           paramaters:paramaters
                              success:weakself.singleSuccessBlock
                              failure:weakself.singleFailureBlock];
        
        
    }
    
    
}

@end
