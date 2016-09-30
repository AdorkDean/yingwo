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


@end

@protocol DiscoveryDelegate <NSObject>

- (void)didSelectSubjectWith:(NSString *)subject subjectId:(int)subjectId;
- (void)didSelectTopicWith:(int)topicId;

@end

