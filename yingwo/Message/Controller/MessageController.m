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

@interface MessageController ()

@property (nonatomic, strong) ChatListController *chatListVc;

@end

@implementation MessageController


- (ChatListController *)chatListVc {
    if (_chatListVc == nil) {
        _chatListVc = [[ChatListController alloc] init];
    }
    return _chatListVc;
}

- (YWCustomerCell *)commentBtn {
    if (_commentBtn == nil) {
        _commentBtn = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"pinglun"] labelText:@"评论"];
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"input_top"] forState:UIControlStateNormal];
        [_commentBtn setBackgroundImage:[UIImage imageNamed:@"input_top_selected"] forState:UIControlStateHighlighted];
        [_commentBtn addTarget:self action:@selector(jumpToMyCommentPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBtn;
}

- (YWCustomerCell *)favorBtn {
    if (_favorBtn == nil) {
        _favorBtn = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"zan"] labelText:@"点赞"];
        [_favorBtn setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_favorBtn setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];
        [_favorBtn addTarget:self action:@selector(jumpToMyFavorPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favorBtn;
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
    [self.view addSubview:self.chatlistBtn];

    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(10);
        make.centerX.equalTo(self.view);
    }];
    
    [self.favorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commentBtn.mas_bottom);
        make.centerX.equalTo(self.view);

    }];
    
    [self.chatlistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorBtn.mas_bottom);
        make.centerX.equalTo(self.view);


    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    self.title = @"我的消息";

    [self clearBubRedDot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark private method

- (void)jumpToMyCommentPage {
    
    self.hasCommentBadge = NO;
    
    [self clearBubRedDot];
    
    CommentController *commentVc = [[CommentController alloc] init];
    
    [self.navigationController pushViewController:commentVc animated:YES];

}

- (void)jumpToMyFavorPage {
    
    self.hasLikeBadge = NO;
    [self clearBubRedDot];

    FavorController *favorVc = [[FavorController alloc] init];
    [self.navigationController pushViewController:favorVc animated:YES];
}

- (void)jumpToMyChatListPage {
    
    ChatListController *chatList = [[ChatListController alloc] init];
    
    [self.navigationController pushViewController:chatList animated:YES];
}

- (void)clearBubRedDot {
    if (!self.hasCommentBadge && !self.hasLikeBadge) {
        
        [self.bubBtn clearBadge];
    }
}

@end
