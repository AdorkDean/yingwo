//
//  MessageController.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MessageController.h"
#import "CommentController.h"
#import "FavorController.h"
#import "ChatListController.h"
#import "MyRelationshipBaseController.h"
#import "TokenEntity.h"
#import "ChatViewModel.h"
#import "ChatController.h"

@interface MessageController ()

@property (nonatomic, strong) ChatViewModel *viewModel;

@end

@implementation MessageController

- (ChatViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[ChatViewModel alloc] init];
    }
    return _viewModel;
}

-(UIView *)messageHeaderView {
    if (_messageHeaderView == nil) {
        _messageHeaderView = [[UIView alloc] init];
        
        [_messageHeaderView addSubview:self.commentBtn];
        [_messageHeaderView addSubview:self.favorBtn];
        [_messageHeaderView addSubview:self.followBtn];
        
        self.messageHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.commentBtn.height * 3 + 20);
    }
    return _messageHeaderView;
}

- (YWCustomerCell *)commentBtn {
    if (_commentBtn == nil) {
        _commentBtn = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"pinglun"] labelText:@"评论我的"];
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"input_top"] forState:UIControlStateNormal];
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"input_top_selected"] forState:UIControlStateHighlighted];
        [_commentBtn addTarget:self action:@selector(jumpToMyCommentPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (YWCustomerCell *)favorBtn {
    if (_favorBtn == nil) {
        _favorBtn = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"zan"] labelText:@"赞了我的"];
        [_favorBtn setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_favorBtn setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];
        [_favorBtn addTarget:self action:@selector(jumpToMyFavorPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favorBtn;
}

- (YWCustomerCell *)followBtn {
    if (_followBtn == nil) {
        _followBtn = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"guanzhu"] labelText:@"关注我的"];
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_followBtn setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];
        [_followBtn addTarget:self action:@selector(jumpToFollowMePage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _followBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubviews];
    
    [self layoutSubviews];
    
    [self initDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    self.title = @"我的消息";

    [self clearBubRedDot];
}

- (void)creatSubviews {
    
    self.view.backgroundColor                                   = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    //设置tableView样式
    self.conversationListTableView.backgroundColor              = [UIColor colorWithHexString:BACKGROUND_COLOR];
    self.conversationListTableView.frame                        = CGRectMake(10, 0,
                                                                             SCREEN_WIDTH - 20,
                                                                             SCREEN_HEIGHT);
    self.conversationListTableView.tableHeaderView              = self.messageHeaderView;
    self.conversationListTableView.separatorColor               = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
    self.conversationListTableView.tableFooterView              = [UIView new];
    self.conversationListTableView.showsVerticalScrollIndicator = NO;
    
    // 设置在NavigatorBar中显示连接中的提示
    self.showConnectingStatusOnNavigatorBar = YES;
    //设置头像圆角
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    
}

- (void)layoutSubviews {
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageHeaderView.mas_top).offset(10);
        make.left.equalTo(self.messageHeaderView.mas_left);
        make.right.equalTo(self.messageHeaderView.mas_right);
        make.centerX.equalTo(self.messageHeaderView);
    }];
    
    [self.favorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentBtn.mas_bottom);
        make.left.equalTo(self.messageHeaderView.mas_left);
        make.right.equalTo(self.messageHeaderView.mas_right);
        make.centerX.equalTo(self.messageHeaderView);
        
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorBtn.mas_bottom);
        make.left.equalTo(self.messageHeaderView.mas_left);
        make.right.equalTo(self.messageHeaderView.mas_right);
        make.centerX.equalTo(self.messageHeaderView);
    }];
    
}

- (void)initDataSource {
    
    WeakSelf(self);
    [self.viewModel setTokenSuccessBlock:^(NSString *userId) {
        
        [weakself initConversation];
        
    } tokenFailureBlock:^(id tokenFailureBlock) {
        [weakself initConversation];
    }];
    
}

- (void)initConversation {
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    
    //设置需要将哪些类型的会话在会话列表中聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    
    [self refreshConversationTableViewIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private method

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    
    ChatController *conversationVC = [[ChatController alloc]init];
    conversationVC.conversationType              = model.conversationType;
    conversationVC.targetId                      = model.targetId;
    conversationVC.title                         = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

//点击头像跳转
-(void)didTapCellPortrait:(RCConversationModel *)model {
    
    ChatController *conversationVC = [[ChatController alloc]init];
    conversationVC.conversationType              = model.conversationType;
    conversationVC.targetId                      = model.targetId;
    conversationVC.title                         = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}

- (void)jumpToMyCommentPage {
    
    self.hasCommentBadge = NO;
    [self.commentBtn.badgeLabel clearBadge];
    
    [self clearBubRedDot];
    
    CommentController *commentVc = [[CommentController alloc] init];
    
    [self.navigationController pushViewController:commentVc animated:YES];

}

- (void)jumpToMyFavorPage {
    
    self.hasLikeBadge = NO;
    [self.favorBtn.badgeLabel clearBadge];

    [self clearBubRedDot];

    FavorController *favorVc = [[FavorController alloc] init];
    [self.navigationController pushViewController:favorVc animated:YES];
}

- (void)jumpToFollowMePage {
    self.hasFollowBadge = NO;
    [self.followBtn.badgeLabel clearBadge];
    
    [self clearBubRedDot];
    
    MyRelationshipBaseController *relationVc = [[MyRelationshipBaseController alloc] initWithRelationType:3];
    Customer *user = [User findCustomer];
    relationVc.requestEntity.user_id         = [user.userId intValue];
//    relationVc.fansCnt                       = [self.taEntity.liked_cnt intValue];
    relationVc.relationType                  = 3;
    
    [self.navigationController pushViewController:relationVc animated:YES];
}

- (void)clearBubRedDot {
    if (!self.hasCommentBadge && !self.hasLikeBadge && !self.hasFollowBadge) {
        
        [self.bubBtn clearBadge];
    }
}

@end
