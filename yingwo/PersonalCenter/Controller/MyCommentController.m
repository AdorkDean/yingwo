//
//  MyCommentController.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/25.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyCommentController.h"
#import "DetailController.h"
#import "ReplyDetailController.h"

#import "YWMessageCell.h"
#import "YWImageMessageCell.h"

#import "MyCommentViewModel.h"

#import "MessageEntity.h"

@interface MyCommentController ()<UITableViewDelegate,UITableViewDataSource,YWMessageCellDelegate>

@property (nonatomic, strong) UITableView        *tableView;
@property (nonatomic, strong) MyCommentViewModel *viewModel;

@property (nonatomic, strong) RequestEntity      *requestEntity;
@property (nonatomic, strong) MessageEntity      *messageEntity;

@property (nonatomic, strong) NSMutableArray     *messageArr;
@property (nonatomic, strong) NSIndexPath        *selectedIndexPath;

@property (nonatomic, strong) UILabel            *noTieziLabel;

@property (nonatomic, strong) YWEmptyRemindView  *emptyRemindView;

@end

static NSString *noImageCellidentifier = @"noImage";
static NSString *imageCellidentifier   = @"hasImage";

static int start_id = 0;

@implementation MyCommentController

-(UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView                                  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate                         = self;
        _tableView.dataSource                       = self;
        _tableView.separatorStyle                   = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor                  = [UIColor clearColor];
        _tableView.contentInset                     = UIEdgeInsetsMake(5, 0, 75, 0);
        
        [_tableView registerClass:[YWMessageCell class] forCellReuseIdentifier:noImageCellidentifier];
        [_tableView registerClass:[YWImageMessageCell class] forCellReuseIdentifier:imageCellidentifier];
    }
    return _tableView;
}

-(MyCommentViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[MyCommentViewModel alloc] init];
    }
    return _viewModel;
}

-(RequestEntity *)requestEntity {
    if (_requestEntity == nil) {
        _requestEntity = [[RequestEntity alloc] init];
        _requestEntity.URLString = MY_REPLY_AND_COMMENT_URL;
        _requestEntity.start_id = 0;
    }
    return _requestEntity;
}

- (NSMutableArray *)messageArr {
    if (_messageArr == nil) {
        _messageArr = [[NSMutableArray alloc] init];
    }
    return _messageArr;
}

-(YWEmptyRemindView *)emptyRemindView {
    if (_emptyRemindView == nil) {
        _emptyRemindView                 = [[YWEmptyRemindView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
                                                                            andText:@"还没有评论过别人哦~"];
        [self.tableView addSubview:_emptyRemindView];
    }
    return _emptyRemindView;
}

-(void)layoutSubviews {
    
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的评论";

    [self layoutSubviews];
    
    [self showLoadingViewOnFrontView:self.tableView];
    
    __weak MyCommentController *weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.requestEntity.start_id = start_id;
        
        [weakSelf loadDataWithRequestEntity:self.requestEntity];
    }];
    
    self.tableView.mj_footer    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationItem.leftBarButtonItem = self.leftBarItem;
}


/**
 *  下拉刷新
 */
- (void)loadDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    [self loadForType:1 RequestEntity:requestEntity];
    
    [self.tableView.mj_footer resetNoMoreData];
}

/**
 *  上拉刷新
 */
- (void)loadMoreDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    [self loadForType:2 RequestEntity:requestEntity];
}

/**
 *  下拉、上拉刷新
 *
 *  @param type  上拉or下拉
 *  @param model 刷新类别：所有帖、新鲜事、好友动态、关注的话题
 */
- (void)loadForType:(int)type RequestEntity:(RequestEntity *)requestEntity {
    
    @weakify(self);
    [[self.viewModel.fecthCommentEntityCommand execute:requestEntity] subscribeNext:^(NSArray *messages) {
        @strongify(self);
        
        [self showFrontView:self.tableView];
        //这里是倒序获取前10个
        if (messages.count > 0) {
            
            self.emptyRemindView.hidden = YES;

            if (type == 1) {
                //   NSLog(@"tiezi:%@",tieZis);
                self.messageArr = [messages mutableCopy];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }else {
                
                [self.messageArr addObjectsFromArray:messages];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            MessageEntity *lastObject   = [messages objectAtIndex:messages.count-1];
            self.requestEntity.start_id = lastObject.message_id;
            
        }
        else
        {
            //没有任何数据
            if (messages.count == 0 && requestEntity.start_id == 0) {
                
                self.messageArr = nil;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                self.emptyRemindView.hidden = NO;
            }
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
        //错误的情况下停止刷新（网络错误）
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    }];
    
}

#pragma mark - tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.messageArr[indexPath.row]];
    
    YWMessageCell *cell      = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                               forIndexPath:indexPath];
    [self.viewModel setupModelOfCell:cell model:self.messageArr[indexPath.row]];
    
    cell.delegate            = self;
    cell.messageEntity       = self.messageArr[indexPath.row];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.messageArr[indexPath.row]];
    
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(id cell) {
                                           
                                           [self.viewModel setupModelOfCell:cell
                                                                      model:self.messageArr[indexPath.row]];
                                       }];
    
}

//查看回复或评论的贴子
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageEntity *messageEntity = [self.messageArr objectAtIndex:indexPath.row];
    
    MessageEntity *message       = [[MessageEntity alloc] init];
    
    message.post_id              = messageEntity.post_id;
    
    //跟贴
    if ([messageEntity.follow_type isEqualToString:@"REPLY"]) {
        
        message.reply_id = messageEntity.follow_id;
        [self jumpToReplyDetailPageWithModel:message];
        
    }
    //评论
    else if ([messageEntity.follow_type isEqualToString:@"COMMENT"]) {
        
        message.reply_id = messageEntity.follow_post_reply_id;
        [self jumpToReplyDetailPageWithModel:message];
        
    }    
}

/**
 *  查看原贴
 *
 *  @return
 */
#pragma mark YWMessageCellDelegate

- (void)didSelectedTieZi:(MessageEntity *)messageEntity {
    
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
        
        [self jumpToReplyDetailPageWithModel:message];
        
    }
    //评论
    else if ([messageEntity.source_type isEqualToString:@"COMMENT"]) {
        
        [self jumpToReplyDetailPageWithModel:messageEntity];
        
    }
}

-(void)didSelectHeadImageWithEntity:(MessageEntity *)messageEntity {
    
    TAController *taVc = [[TAController alloc] initWithUserId:[messageEntity.follow_user_id intValue]];
    [self.navigationController pushViewController:taVc animated:YES];
}

-(void)didSelectedDeleteBtn:(UIButton *)deleteBtn withEntity:(MessageEntity *)messageEntity {
    
    if ([deleteBtn.superview.superview.superview.superview isKindOfClass:[YWMessageCell class]]) {
        YWMessageCell *selectedCell = (YWMessageCell *)deleteBtn.superview.superview.superview.superview;
        self.selectedIndexPath = [self.tableView indexPathForCell:selectedCell];
    }
    self.messageEntity = messageEntity;
    [self showDeleteAlertView];
    
}

/**
 *  删除警告
 */
- (void)showDeleteAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告"
                                                                             message:@"操作不可恢复，确认删除吗？"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [self deleteReplyOrComment];
                                                        }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel handler:nil]];
    
    alertController.view.tintColor = [UIColor blackColor];
    
    [self.view.window.rootViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
}

- (void)deleteReplyOrComment {
    
    RequestEntity *request = [[RequestEntity alloc] init];

    WeakSelf(self);
    [self.viewModel setDeleteReplySuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
            
            //删除该行跟帖数据源
            [weakself.messageArr removeObjectAtIndex:weakself.selectedIndexPath.row];
            //将该行从视图中移除
            [weakself.tableView deleteRowsAtIndexPaths:@[weakself.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:HUD_DELAY];
        }else if(statusEntity.status == NO){
            
            [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:HUD_DELAY];
        }
     
    } failure:^(id deleteReplyFailureBlock) {
        
    }];
    
    [self.viewModel setDeleteCommentSuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
            
            //删除该行跟帖数据源
            [weakself.messageArr removeObjectAtIndex:weakself.selectedIndexPath.row];
            //将该行从视图中移除
            [weakself.tableView deleteRowsAtIndexPaths:@[weakself.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:HUD_DELAY];
        }else if(statusEntity.status == NO){
            
            [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:HUD_DELAY];
        }
        
    } failure:^(id deleteCommentFailureBlock) {
        
    }];
    
    //网络请求
    if ([self.messageEntity.follow_type isEqualToString:@"REPLY"]) {
        
        request.URLString = TIEZI_REPLY_DEL_URL;
        request.parameter = @{@"reply_id":@(self.messageEntity.reply_id)};
        
        [self.viewModel deleteReplyWithRequest:request];
        
    }else if([self.messageEntity.follow_type isEqualToString:@"COMMENT"]) {
        
        request.URLString = TIEZI_COMMENT_DEL_URL;
        request.parameter = @{@"comment_id":@(self.messageEntity.reply_id)};
        
        [self.viewModel deleteCommentWithRequest:request];
    }
    

}

#pragma mark private
- (void)jumpToReplyDetailPageWithModel:(MessageEntity *)message {
    
    ReplyDetailController *replyVc = [[ReplyDetailController alloc] initWithReplyModel:message
                                                                    shouldShowKeyBoard:NO];
    [self.navigationController pushViewController:replyVc animated:YES];
}

- (void)jumpToTieZiDetailPageWithModel:(MessageEntity *)message {
    
    DetailController *detailVc = [[DetailController alloc] initWithTieZiModel:message];
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
