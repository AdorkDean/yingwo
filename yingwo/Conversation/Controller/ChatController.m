//
//  ChatController.m
//  TEvaluatingSystem
//
//  Created by apple on 2017/2/3.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "ChatController.h"

#import "ChatViewModel.h"
#import "TokenEntity.h"

@interface ChatController ()

@property (nonatomic, strong) ChatViewModel *viewModel;

@end

@implementation ChatController

- (id)initWithConversationType:(RCConversationType)conversationType
                      customer:(Customer *)customer{
    
    self = [super initWithConversationType:conversationType targetId:customer.userId];
    
    if (self) {
        
    }
    return self;
}

- (ChatViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[ChatViewModel alloc] init];
    }
    return _viewModel;
}

- (void)initDataSource {
    
    WeakSelf(self);
    [self.viewModel setTokenSuccessBlock:^(TokenEntity *tokenEntity) {
        
        [weakself initConversation];
        
    } tokenFailureBlock:^(id tokenFailureBlock) {
        
    }];
    
}

- (void)initConversation {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDataSource];
}

-(void)didTapCellPortrait:(NSString *)userId {
    TAController *taVc = [[TAController alloc] initWithUserId:[userId intValue]];
    [self.navigationController pushViewController:taVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
