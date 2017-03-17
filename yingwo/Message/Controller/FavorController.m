//
//  FavorController.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FavorController.h"
#import "DetailController.h"
#import "ReplyDetailController.h"

#import "YWMessageCell.h"
#import "YWImageMessageCell.h"

#import "FavorViewModel.h"

#import "MessageEntity.h"


@interface FavorController ()

@property (nonatomic, strong) FavorViewModel *viewModel;

@end

@implementation FavorController


- (FavorViewModel *)viewModel {
    
    if (_viewModel == nil) {
        _viewModel = [[FavorViewModel alloc] init];
    }
    
    return _viewModel;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"点赞";
    
    self.requestEntity.URLString = MY_LIKED_URL;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
    
}

// overwrite
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.messageArr[indexPath.row]];
    
    YWMessageCell *cell      = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                               forIndexPath:indexPath];
    [self.viewModel setupModelOfCell:cell model:self.messageArr[indexPath.row]];
    
    if (cell.topView.deleteBtn) {
        [cell.topView.deleteBtn removeFromSuperview];
    }
    
    cell.delegate            = self;
    cell.messageEntity       = self.messageArr[indexPath.row];
    
    return cell;
}

//查看回复或评论的贴子
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //与下面代码一致
    MessageEntity *messageEntity = [self.messageArr objectAtIndex:indexPath.row];
    
    [self jumpToDetailPageWithEntity:messageEntity];

}


#pragma mark YWMessageCellDelegate
/**
 *  查看原贴或跟帖、评论
 *
 *  @return
 */
- (void)didSelectedTieZi:(MessageEntity *)messageEntity {
    
    [self jumpToDetailPageWithEntity:messageEntity];
}

#pragma mark private

- (void)jumpToDetailPageWithEntity:(MessageEntity *)messageEntity {
    
    //评论点赞数转化
    messageEntity.reply_cnt = messageEntity.source_reply_cnt;
    messageEntity.like_cnt = messageEntity.source_like_cnt;
    messageEntity.create_time = messageEntity.post_detail_create_time;
    
    //原贴
    if ([messageEntity.source_type isEqualToString:@"POST"]) {
        [self jumpToTieZiDetailPageWithModel:messageEntity];
    }
    //跟贴
    else if ([messageEntity.source_type isEqualToString:@"REPLY"]) {
        
        
        //跟贴的source_post_reply_id是空的
        
        MessageEntity *message = [[MessageEntity alloc] init];
        message.reply_id       = messageEntity.post_id;
        message.post_id        = messageEntity.post_detail_id;
        message.comment_cnt    = [messageEntity.source_comment_cnt intValue];
        message.like_cnt       = messageEntity.source_like_cnt;
        
        [self jumpToReplyDetailPageWithModel:message];
        
    }
    
}


- (void)jumpToReplyDetailPageWithModel:(MessageEntity *)message {
    
    ReplyDetailController *replyVc = [[ReplyDetailController alloc] initWithReplyModel:message
                                                                    shouldShowKeyBoard:NO];
    [self.navigationController pushViewController:replyVc animated:YES];
}

- (void)jumpToTieZiDetailPageWithModel:(MessageEntity *)message {
    
    DetailController *detailVc = [[DetailController alloc] initWithTieZiModel:message];
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
