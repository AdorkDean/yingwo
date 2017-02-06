//
//  MessageDetailController.m
//  yingwo
//
//  Created by apple on 2016/11/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MessageDetailController.h"

#import "AnnounceController.h"

#import "YWDetailTableViewCell.h"
#import "YWDetailBaseTableViewCell.h"
#import "YWDetailReplyCell.h"

#import "MessageDetailViewModel.h"
#import "GalleryViewModel.h"

#import "YWDetailBottomView.h"
#import "YWDetailCommentView.h"
#import "YWCommentView.h"

#import "TieZiComment.h"

#import "YWAlertButton.h"



@interface MessageDetailController ()

@property (nonatomic, strong) MessageDetailViewModel *viewModel;

@end

@implementation MessageDetailController

#pragma mark 懒加载

- (MessageDetailViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel                 = [[MessageDetailViewModel alloc] init];
    }
    return _viewModel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"评论详情";

    //显示刚发布的跟贴内容，追加到tableview的最后一个
    if (self.isReleased == YES) {
        
    }
    
}


@end
