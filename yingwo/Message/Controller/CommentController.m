//
//  CommentController.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "CommentController.h"
#import "DetailController.h"
#import "ReplyDetailController.h"



@interface CommentController ()

@property (nonatomic, strong) MessageViewModel   *viewModel;


@end

static NSString *noImageCellidentifier = @"noImage";
static NSString *imageCellidentifier   = @"hasImage";

static int start_id = 0;

@implementation CommentController

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        _tableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset    = UIEdgeInsetsMake(5, 0, 80, 0);
        
        [_tableView registerClass:[YWMessageCell class] forCellReuseIdentifier:noImageCellidentifier];
        [_tableView registerClass:[YWImageMessageCell class] forCellReuseIdentifier:imageCellidentifier];

    }
    
    return _tableView;
    
}

- (MessageViewModel *)viewModel {
    
    if (_viewModel == nil) {
        _viewModel = [[MessageViewModel alloc] init];
    }
    
    return _viewModel;
    
}

- (RequestEntity *)requestEntity {
    if (_requestEntity == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        _requestEntity.URLString = MESSAGE_REPLY_AND_COMMENT_URL;
        _requestEntity.start_id   = 0;
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
                                                                            andText:@"还没有人评论你哦~"];
        [self.tableView addSubview:_emptyRemindView];
    }
    return _emptyRemindView;
}

- (void)layoutSubview {
    
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评论";
    
    [self layoutSubview];

    [self showLoadingView];
    
    __weak CommentController *weakSelf = self;
    
    self.tableView.mj_header           = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

        //偏移量开始为0
    self.requestEntity.start_id        = start_id;
        
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

- (void)showLoadingView {
    
    [self.indicatorView showActivityLoadingInController:self];
    self.tableView.alpha = 0;
    
}

- (void)showTableView {
    
    [UIView animateWithDuration:0.8 animations:^{
        
        self.tableView.alpha = 1;
        [self.indicatorView stopIndicatorViewAnimation];
        
    } completion:^(BOOL finished) {
        
        self.indicatorView = nil;
    }];
    
    
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
    [[self.viewModel.fecthTieZiEntityCommand execute:requestEntity] subscribeNext:^(NSArray *messages) {
        @strongify(self);
        
        [self showTableView];
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




#pragma mark tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

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

    message.comment_cnt          = [messageEntity.source_comment_cnt intValue];
    message.like_cnt             = messageEntity.source_like_cnt;
    

    //跟贴
    if ([messageEntity.follow_type isEqualToString:@"REPLY"]) {
        
        message.reply_id = messageEntity.follow_id;
        [self jumpToReplyDetailPageWithModel:message andOriginalModel:messageEntity];
        
    }
    //评论
    else if ([messageEntity.follow_type isEqualToString:@"COMMENT"]) {
        
        message.reply_id = messageEntity.follow_post_reply_id;
        [self jumpToReplyDetailPageWithModel:message andOriginalModel:messageEntity];

    }
    
}

#pragma mark YWMessageCellDelegate
/**
 *  查看原贴或跟帖、评论
 *
 *  @return
 */
- (void)didSelectedTieZi:(MessageEntity *)messageEntity {
    
    //原贴
    if ([messageEntity.source_type isEqualToString:@"POST"]) {
        
        //评论点赞数转化
        messageEntity.reply_cnt = messageEntity.source_reply_cnt;
        messageEntity.like_cnt = messageEntity.source_like_cnt;
        
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
        
        [self jumpToReplyDetailPageWithModel:message andOriginalModel:messageEntity];

    }
    //评论
    else if ([messageEntity.source_type isEqualToString:@"COMMENT"]) {
        
        messageEntity.comment_cnt    = [messageEntity.source_comment_cnt intValue];
        messageEntity.like_cnt       = messageEntity.source_like_cnt;
        
        [self jumpToReplyDetailPageWithModel:messageEntity andOriginalModel:messageEntity];

    }

}

/**
 * 进入用户主页
 *
 *  @return
 */
-(void)didSelectHeadImageWithEntity:(MessageEntity *)messageEntity {
    
    TAController *taVc = [[TAController alloc] initWithUserId:[messageEntity.follow_user_id intValue]];
    
    [self customPushToViewController:taVc];

}

#pragma mark private

- (void)jumpToReplyDetailPageWithModel:(MessageEntity *)message andOriginalModel:(MessageEntity *)messageEntity{
    
    ReplyDetailController *replyVc = [[ReplyDetailController alloc] initWithReplyModel:message
                                                                    shouldShowKeyBoard:NO];
    replyVc.isFromMessage = YES;
    TieZi *tieziModel = [[TieZi alloc] init];
    replyVc.tieziModel = [self extractTieZi:tieziModel FromMessageEntity:messageEntity];
    
    [self customPushToViewController:replyVc];
}

- (void)jumpToTieZiDetailPageWithModel:(MessageEntity *)message {
    
    DetailController *detailVc = [[DetailController alloc] initWithTieZiModel:message];
    [self customPushToViewController:detailVc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(TieZi *)extractTieZi:(TieZi *)tieziModel FromMessageEntity:(MessageEntity *)message {

    TieZi *tiezi = [[TieZi alloc] init];

    tiezi.tieZi_id              = message.post_detail_id;
    tiezi.topic_id              = message.post_detail_topic_id;
    tiezi.user_id               = message.post_detail_user_id;
    tiezi.create_time           = message.post_detail_create_time;
    tiezi.topic_title           = message.post_detail_topic_title;
    tiezi.user_name             = message.post_detail_user_name;
    tiezi.content               = message.post_detail_content;
    tiezi.img                   = message.post_detail_img;
    tiezi.user_face_img         = message.post_detail_user_face_img;
    tiezi.like_cnt              = message.post_detail_like_cnt;
    tiezi.reply_cnt             = message.post_detail_reply_cnt;
    tiezi.user_post_like        = message.post_detail_user_post_like;
    
    tiezi.imageURLArr           = [NSString separateImageViewURLString:tiezi.img];
    tiezi.imageUrlEntityArr     = [NSString separateImageViewURLStringToModel:tiezi.img];
    
    return tiezi;
}

@end
