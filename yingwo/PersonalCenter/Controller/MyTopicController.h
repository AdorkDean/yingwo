//
//  MyTopicController.h
//  yingwo
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "TopicListController.h"

@interface MyTopicController : BaseViewController

//校园生活
@property (nonatomic, strong) TopicListController *oneFieldVc;
//兴趣爱好
@property (nonatomic, strong) TopicListController *twoFieldVc;
//学科专业
@property (nonatomic, strong) TopicListController *threeFieldVc;

@property (nonatomic, assign) int                 userId;

@property (nonatomic, assign) BOOL                isMyTopic;


- (instancetype)initWithUserId:(int)userId title:(NSString *)title;

@end
