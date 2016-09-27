//
//  TopicController.h
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"

@interface TopicListController : BaseViewController

//主题
@property (nonatomic, copy  ) NSString       *subject;

//主题下话题数组
@property (nonatomic, strong) NSArray *topicArr;


@end
