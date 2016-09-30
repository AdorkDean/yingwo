//
//  TopicController.h
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "TieZi.h"

@protocol TopicControllerDelegate;

@interface TopicController : BaseViewController

<<<<<<< HEAD
@property (nonatomic, strong) TieZi    *model;

@property (nonatomic, assign) int      topic_id;
@property (nonatomic, copy  ) NSString * topic_title;
=======
@property (nonatomic, strong)TieZi *model;

@property (nonatomic, assign)int topic_id;
@property (nonatomic, copy)NSString * topic_title;
>>>>>>> origin/master

@end

@protocol TopicControllerDelegate <NSObject>

- (void)didSelectCellWith:(TieZi *)model;

@end
