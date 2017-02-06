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
#import "MessageDetailController.h"
#import "ChatListController.h"
#import "YWCustomerCell.h"

@interface MessageController ()

@property (nonatomic, strong) ChatListController *chatListVc;

@property (nonatomic, strong) YWCustomerCell     *commentBtn;
@property (nonatomic, strong) YWCustomerCell     *favorBtn;
@property (nonatomic, strong) YWCustomerCell     *concernBtn;
@property (nonatomic, strong) YWCustomerCell     *chatlistBtn;

@end

@implementation MessageController

<<<<<<< HEAD
- (SMPagerTabView *)messagePgaeView {
    if (_messagePgaeView == nil) {
        
        _messagePgaeView          = [[SMPagerTabView alloc] initWithFrame:CGRectMake(0,
                                                                                   40,
                                                                                   SCREEN_WIDTH,
                                                                                   SCREEN_HEIGHT)];
        _messagePgaeView.delegate = self;
        
        
        [self.catalogVcArr addObject:self.commentVc];
        [self.catalogVcArr addObject:self.favorVc];
        
        //开始构建UI
        [_messagePgaeView buildUI];
        //起始选择一个tab
        [_messagePgaeView selectTabWithIndex:0 animate:NO];
=======
- (ChatListController *)chatListVc {
    if (_chatListVc == nil) {
        _chatListVc = [[ChatListController alloc] init];
>>>>>>> Developing
    }
    return _chatListVc;
}

<<<<<<< HEAD
- (UIView *)messageSectionView {
    if (_messageSectionView == nil) {
        _messageSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     SCREEN_WIDTH,
                                                                     40)];
        
        [_messageSectionView addSubview:self.messagePgaeView.tabView];
=======
- (YWCustomerCell *)commentBtn {
    if (_commentBtn == nil) {
        _commentBtn = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"pinglun"] labelText:@"我的评论"];
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"input_top"] forState:UIControlStateNormal];
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"input_top_selected"] forState:UIControlStateHighlighted];
        [_commentBtn addTarget:self action:@selector(jumpToMyCommentPage) forControlEvents:UIControlEventTouchUpInside];
>>>>>>> Developing
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
- (YWCustomerCell *)concernBtn {
    if (_concernBtn == nil) {
        _concernBtn = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"guanzhu"] labelText:@"关注我的"];
        [_concernBtn setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_concernBtn setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];
    }
    return _concernBtn;
}

- (YWCustomerCell *)chatlistBtn {
    if (_chatlistBtn == nil) {
        _chatlistBtn = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"pinglun"] labelText:@"聊天"];
        [_chatlistBtn setBackgroundImage:[UIImage imageNamed:@"input_col"] forState:UIControlStateNormal];
        [_chatlistBtn setBackgroundImage:[UIImage imageNamed:@"input_col_selected"] forState:UIControlStateHighlighted];
        [_chatlistBtn addTarget:self action:@selector(jumpToMyChatListPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatlistBtn;
}

- (void)layoutSubviews {
    
    [self.view addSubview:self.commentBtn];
    [self.view addSubview:self.favorBtn];
    [self.view addSubview:self.concernBtn];
    [self.view addSubview:self.chatlistBtn];

    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.favorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentBtn.mas_bottom);
        make.centerX.equalTo(self.view);

    }];
    
    [self.concernBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorBtn.mas_bottom);
        make.centerX.equalTo(self.view);

    }];
    
    [self.chatlistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.concernBtn.mas_bottom);
        make.centerX.equalTo(self.view);

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
<<<<<<< HEAD
    [self.view addSubview:self.messagePgaeView];
    [self.view addSubview:self.messageSectionView];
    
=======

>>>>>>> Developing
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    self.title = @"我的消息";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[MessageDetailController class]]) {
        if ([segue.identifier isEqualToString:@"messageDetail"]) {
            
            MessageDetailController *messageDetailVc = segue.destinationViewController;
            messageDetailVc.model                    = self.messageEntity;

        }
    }else if ([segue.destinationViewController isKindOfClass:[DetailController class]]) {
        
        if([segue.identifier isEqualToString:@"detail"]) {
        DetailController *detailVc = segue.destinationViewController;
        detailVc.model             = self.tieZiModel;
            
        }
    }else if ([segue.destinationViewController isKindOfClass:[TAController class]]) {
        
        if ([segue.identifier isEqualToString:@"ta"]) {
            TAController *taVc = segue.destinationViewController;
            taVc.ta_id = [self.messageEntity.follow_user_id intValue];
        }
    }
    
}
*/

#pragma mark private method

- (void)jumpToMyCommentPage {
    
    CommentController *commentVc = [[CommentController alloc] init];
    
    [self.navigationController pushViewController:commentVc animated:YES];

}

- (void)jumpToMyFavorPage {
    
    FavorController *favorVc = [[FavorController alloc] init];
    [self.navigationController pushViewController:favorVc animated:YES];
}

- (void)jumpToMyConcernPage {
    
   // [self.navigationController pushViewController:commentVc animated:YES];
}

- (void)jumpToMyChatListPage {
    
    ChatListController *chatList = [[ChatListController alloc] init];
    
    [self.navigationController pushViewController:chatList animated:YES];
}

@end
