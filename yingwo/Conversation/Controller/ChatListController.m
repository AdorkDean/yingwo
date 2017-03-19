//
//  ChatListController.m
//  TEvaluatingSystem
//
//  Created by apple on 2017/2/3.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "ChatListController.h"
#import "TokenEntity.h"
#import "ChatViewModel.h"
#import "ChatController.h"

@interface ChatListController ()

@property (nonatomic, strong) ChatViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *leftBarItem;

@end

@implementation ChatListController

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(backToFarword)];
    }
    return _leftBarItem;
}

- (ChatViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[ChatViewModel alloc] init];
    }
    return _viewModel;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天";
    

    [self initDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
}

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

-(void)didTapCellPortrait:(RCConversationModel *)model {
    
    ChatController *conversationVC = [[ChatController alloc]init];
    conversationVC.conversationType              = model.conversationType;
    conversationVC.targetId                      = model.targetId;
    conversationVC.title                         = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
#pragma mark private

- (void)backToFarword {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
