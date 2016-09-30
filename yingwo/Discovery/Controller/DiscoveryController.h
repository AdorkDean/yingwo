//
//  YWDiscoveryController.h
//  yingwo
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"

@protocol DiscoveryDelegate;

@interface DiscoveryController : BaseViewController

<<<<<<< HEAD

=======
>>>>>>> origin/master
@end

@protocol DiscoveryDelegate <NSObject>

<<<<<<< HEAD
- (void)didSelectSubjectWith:(NSString *)subject subjectId:(int)subjectId;
=======
- (void)didSelectSubjectWith:(NSString *)subject TopicArr:(NSArray *)topicArr;
>>>>>>> origin/master
- (void)didSelectTopicWith:(int)topicId;

@end

