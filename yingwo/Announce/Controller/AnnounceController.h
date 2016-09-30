//
//  AnnounceController.h
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"

@protocol AnnounceControllerDelegate;

@interface AnnounceController : BaseViewController

//判断是否是跟帖
@property (nonatomic, assign) BOOL                       isFollowTieZi;

//判断是否是发话题
@property (nonatomic, assign) BOOL                       isTopic;

//跟贴的id
@property (nonatomic, assign) NSInteger                  post_id;

//话题的id
@property (nonatomic, assign) int                        topic_id;

@property (nonatomic,assign ) id<AnnounceControllerDelegate> delegate;

@end

@protocol AnnounceControllerDelegate <NSObject>

- (void)jumpToHomeController;

@end
