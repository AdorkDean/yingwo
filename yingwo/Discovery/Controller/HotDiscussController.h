//
//  HotDiscussController.h
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "HotDisscussViewModel.h"

@protocol HotDiscussControllerDelegate;

@interface HotDiscussController : BaseViewController

@property (nonatomic, strong) id<HotDiscussControllerDelegate> delegate;

@property (nonatomic, strong) HotDiscussEntity    *model;

@end

@protocol HotDiscussControllerDelegate <NSObject>

- (void)didSelectHotDisTopicWith:(HotDiscussEntity *)model;

@optional
- (void)didSelectHotDisTopicLabelWith:(int)topic_id;

@end
