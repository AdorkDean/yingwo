//
//  MessageController.h
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageEntity.h"
#import "SMPagerTabView.h"
#import "YWCustomerCell.h"


@protocol MessageControllerDelegate ;

@interface MessageController : BaseViewController

@property (nonatomic, strong) SMPagerTabView *messagePgaeView;

// main tabBar上的消息按钮
@property (nonatomic, strong) UIButton       *bubBtn;

@property (nonatomic, strong) YWCustomerCell *commentBtn;
@property (nonatomic, strong) YWCustomerCell *favorBtn;
@property (nonatomic, strong) YWCustomerCell *chatlistBtn;

@property (nonatomic, assign) BOOL           hasCommentBadge;
@property (nonatomic, assign) BOOL           hasLikeBadge;



@end

@protocol MessageControllerDelegate <NSObject>

- (void)didSelectMessageWith:(MessageEntity *)model;
- (void)didSelectHeadImageWith:(MessageEntity *)model;

@end
