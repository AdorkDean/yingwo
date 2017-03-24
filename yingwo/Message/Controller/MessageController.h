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
#import <RongIMKit/RongIMKit.h>

@protocol MessageControllerDelegate ;

@interface MessageController : RCConversationListViewController

@property (nonatomic, strong) SMPagerTabView *messagePgaeView;

// main tabBar上的消息按钮
@property (nonatomic, strong) UIButton       *bubBtn;
@property (nonatomic, strong) UIView         *messageHeaderView;

@property (nonatomic, strong) YWCustomerCell *commentBtn;
@property (nonatomic, strong) YWCustomerCell *favorBtn;
@property (nonatomic, strong) YWCustomerCell *followBtn;
@property (nonatomic, strong) YWCustomerCell *chatlistBtn;

@property (nonatomic, assign) BOOL           hasCommentBadge;
@property (nonatomic, assign) BOOL           hasLikeBadge;
@property (nonatomic, assign) BOOL           hasFollowBadge;

-(void)jumpToMyCommentPage;
-(void)jumpToMyFavorPage;

@end

@protocol MessageControllerDelegate <NSObject>

- (void)didSelectMessageWith:(MessageEntity *)model;
- (void)didSelectHeadImageWith:(MessageEntity *)model;

@end
