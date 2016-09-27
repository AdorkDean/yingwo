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

@property (nonatomic, assign) BOOL                       isFollowTieZi;
@property (nonatomic, assign) NSInteger                  post_id;

@property (nonatomic,assign ) id<AnnounceControllerDelegate> delegate;

@end

@protocol AnnounceControllerDelegate <NSObject>

- (void)jumpToHomeController;

@end