//
//  DetailController.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DetailController.h"
#import "FollowTieController.h"
#import "TopicController.h"
#import "ReplyDetailController.h"

#import "UMSocialUIManager.h"


@interface DetailController ()<UITableViewDelegate,UITableViewDataSource,YWDetailTabeleViewDelegate,YWGalleryViewDelegate,UITextFieldDelegate,YWKeyboardToolViewProtocol,HPGrowingTextViewDelegate,YWDetailCellBottomViewDelegate,YWSpringButtonDelegate,YWAlertButtonProtocol, YWTitleDelegate,TTTAttributedLabelDelegate,YWMasterDelegate>

@property (nonatomic, strong) UITableView     *detailTableView;

@property (nonatomic, strong) DetailViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem     *rightBarItem;
@property (nonatomic, strong) UIAlertController   *alertView;
@property (nonatomic, strong) UIAlertController   *compliantAlertView;

@property (nonatomic, strong) YWDetailReplyCell   *commentCell;

@property (nonatomic, strong) YWDetailBottomView  *replyView;
@property (nonatomic, strong) YWDetailCommentView *commentView;
@property (nonatomic, strong) YWGalleryView       *galleryView;

@property (nonatomic, strong) GalleryViewModel    *homeViewModel;

@property (nonatomic, strong) RequestEntity       *requestEntity;

@property (nonatomic, strong) MJRefreshAutoNormalFooter *footer;

@property (nonatomic, assign) int                 isMessage;

//是否回复
@property (nonatomic, assign) BOOL                 isReply;

@property (nonatomic, strong) NSMutableArray      *tieZiReplyArr;
@property (nonatomic, strong) NSMutableDictionary *commetparameter;
@end

@implementation DetailController

static NSString *detailCellIdentifier      = @"detailCell";
static NSString *detailReplyCellIdentifier = @"replyCell";

- (instancetype)initWithTieZiModel:(TieZi *)model {
    
    self = [super init];
    
    if (self) {
        self.model = model;
    }
    
    return self;
    
}

#pragma mark 懒加载

- (UITableView *)detailTableView {
    if (_detailTableView == nil) {
        _detailTableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _detailTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _detailTableView.backgroundColor = [UIColor clearColor];
        _detailTableView.delegate        = self;
        _detailTableView.dataSource      = self;
        _detailTableView.contentInset    = UIEdgeInsetsMake(0, 0, 60, 0);
      //  _detailTableView.fd_debugLogEnabled = YES;
        [_detailTableView registerClass:[YWDetailTableViewCell class] forCellReuseIdentifier:detailCellIdentifier];
        [_detailTableView registerClass:[YWDetailReplyCell class] forCellReuseIdentifier:detailReplyCellIdentifier];

    }
    return _detailTableView;
}

- (DetailViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel                 = [[DetailViewModel alloc] init];
        
    }
    return _viewModel;
}

- (GalleryViewModel *)homeViewModel {
    if (_homeViewModel == nil) {
        _homeViewModel = [[GalleryViewModel alloc] init];
    }
    return _homeViewModel;
}

- (RequestEntity *)requestEntity {
    if (_requestEntity == nil) {
        _requestEntity = [[RequestEntity alloc] init];
    }
    return _requestEntity;
}

- (TieZi *)model {
    if (_model == nil) {
        _model = [[TieZi alloc] init];
    }
    return _model;
}

-(TieZiReply *)replyModel {
    if (_replyModel == nil) {
        _replyModel = [[TieZiReply alloc] init];
    }
    return _replyModel;
}

- (UIBarButtonItem *)rightBarItem {
    if (_rightBarItem == nil) {
        _rightBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(showShareView)];
    }
    return _rightBarItem;
}

- (YWDetailBottomView *)replyView {
    if (_replyView == nil) {
        _replyView                       = [[YWDetailBottomView alloc] init];
        _replyView.messageField.delegate = self;
        _replyView.favorBtn.delegate     = self;
        _replyView.favorBtn.post_id      = self.model.tieZi_id;
        //判断是否有点赞过
        if (self.model.user_post_like  == 1) {
            [_replyView.favorBtn setBackgroundImage:[UIImage imageNamed:@"heart_red"]
                                           forState:UIControlStateNormal];
            _replyView.favorBtn.isSpring = YES;
        }
        
        _replyView.messageField.placeholder = [NSString stringWithFormat:@"%@个评论 %@个赞",
                                               self.model.reply_cnt,
                                               self.model.like_cnt];
    }
    return _replyView;
}

- (YWGalleryView *)galleryView {
    if (_galleryView == nil) {
        _galleryView                 = [[YWGalleryView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _galleryView.backgroundColor = [UIColor blackColor];
        _galleryView.delegate        = self;
    }
    return _galleryView;
}

- (YWDetailCommentView *)commentView {
    if (_commentView == nil) {
        _commentView                              = [[YWDetailCommentView alloc] initWithFrame:CGRectMake(0,
                                                                                                        SCREEN_HEIGHT,
                                                                                                        SCREEN_WIDTH,
                                                                                                          45)];
        _commentView.delegate                     = self;
        self.commentView.messageTextView.delegate = self;

    }
    return _commentView;
}

- (NSMutableArray *)tieZiReplyArr {
    if (_tieZiReplyArr == nil) {
        _tieZiReplyArr = [[NSMutableArray alloc] init];
    }
    return _tieZiReplyArr;
}

- (NSMutableDictionary *)commetparameter {
    if (_commetparameter == nil) {
        _commetparameter = [[NSMutableDictionary alloc] init];
    }
    return _commetparameter;
}

- (CGFloat)navgationBarHeight {
    //导航栏＋状态栏高度
    return  self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (UIAlertController *)compliantAlertView {
    if (_compliantAlertView == nil) {
        _compliantAlertView = [UIAlertController alertControllerWithTitle:@"举报"
                                                                  message:nil
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"广告"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"色情"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"反动"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"其他"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"取消"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        
        _compliantAlertView.view.tintColor = [UIColor blackColor];

    }
    return _compliantAlertView;
}

#pragma mark YWAlertButtonProtocol
- (void)seletedAlertView:(UIAlertController *)alertView onMoreBtn:(UIButton *)more atIndex:(NSInteger)index{
    if (index == 0) {
        [self copyTiZiText:more];
        
    }else if (index == 1) {
        self.alertView = alertView;
        [self showCompliantAlertView];
        
    }else if (index == 2) {
        [self showDeleteAlertView:more];
    }
}

/**
 *  删除警告
 */
- (void)showDeleteAlertView:(UIButton *)more {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告"
                                                                             message:@"操作不可恢复，确认删除吗？"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [self deleteTieZi:more];
                                                        }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel handler:nil]];
    
    alertController.view.tintColor = [UIColor blackColor];
    
    [self.view.window.rootViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
}

/**
 *  删除帖子
 */
- (void)deleteTieZi:(UIButton *)more {
    
    RequestEntity *request = [[RequestEntity alloc] init];

    //判断删除楼主的帖子
    if ([more.superview.superview.superview.superview isKindOfClass:[YWDetailTableViewCell class]]) {
        
        //网络请求
        NSDictionary *parameter = @{@"post_id":@(self.model.tieZi_id)};
        
        
        request.URLString = TIEZI_DEL_URL;
        request.parameter = parameter;
        
        [self deleteIndexTieZiWithRequest:request];
        
    }
    
    //判断删除跟帖
    if ([more.superview.superview.superview isKindOfClass:[YWDetailReplyCell class]]) {
        
        //获取当前选中的cell的reply_id
        YWDetailReplyCell *selectedCell = (YWDetailReplyCell *)more.superview.superview.superview;
        NSIndexPath *indexPath          = [self.detailTableView indexPathForCell:selectedCell];
        TieZiReply *replyModel;
        replyModel                      = [self.tieZiReplyArr objectAtIndex:indexPath.row];

        //网络请求
        NSDictionary *parameter         = @{@"reply_id":@( replyModel.reply_id)};

        request.URLString               = TIEZI_REPLY_DEL_URL;
        request.parameter               = parameter;

        [self deleteReplyTieZiWithRequest:request indexPath:indexPath];
        

    }
}

- (void)deleteIndexTieZiWithRequest:(RequestEntity *)request {
    
    WeakSelf(self);
    
    [self.homeViewModel setDeleteSuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
            
            [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:HUD_DELAY];
            //跳转回上一页面
            
            [weakself.navigationController popViewControllerAnimated:YES];
            
        }else if (statusEntity.status == NO){
            
            [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:1.0];
        }
        
        
    } failureBlock:^(id deleteFailureBlock) {
        
        [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:HUD_DELAY];
        
    }];
    
    [self.homeViewModel deleteTieZiWithRequest:request];

    
}

- (void)deleteReplyTieZiWithRequest:(RequestEntity *)request indexPath:(NSIndexPath *)indexPath{
    
    WeakSelf(self);
    
    [self.homeViewModel setDeleteSuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
            
            [weakself deleteReplyTieZiByIndexPath:indexPath];
            
            [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:1.0];
            
        }else if (statusEntity.status == NO){
            
            [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:1.0];
        }
        
        
    } failureBlock:^(id deleteFailureBlock) {
        
    }];
    
    [self.homeViewModel deleteTieZiWithRequest:request];
    
    
}

- (void)deleteReplyTieZiByIndexPath:(NSIndexPath *)indexPath {
    
    //删除该行跟帖数据源
    [self.tieZiReplyArr removeObjectAtIndex:indexPath.row];
    //将该行从视图中移除
    [self.detailTableView deleteRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationFade];
    [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:HUD_DELAY];
    
}

/**
 *  举报弹出框
 */
- (void)showCompliantAlertView {
    [self.view.window.rootViewController presentViewController:self.compliantAlertView
                                                      animated:YES
                                                    completion:nil];
}
/**
 *  复制帖子文字内容
 */
- (void)copyTiZiText:(UIButton *)more {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //复制内容 获取帖子文字内容
    
    if ([more.superview.superview.superview.superview isKindOfClass:[YWDetailTableViewCell class]]) {
        YWDetailTableViewCell *selectedCell = (YWDetailTableViewCell *)more.superview.superview.superview.superview;
        //复制到剪切板
        NSString *copyString = selectedCell.contentLabel.text;
        pasteboard.string = copyString;
        [SVProgressHUD showSuccessStatus:@"已复制" afterDelay:HUD_DELAY];
        
    }
    
    if ([more.superview.superview.superview isKindOfClass:[YWDetailReplyCell class]]) {
        
        YWDetailReplyCell *selectedCell = (YWDetailReplyCell *)more.superview.superview.superview;
        NSString *copyString = selectedCell.contentLabel.text;
        pasteboard.string = copyString;
        [SVProgressHUD showSuccessStatus:@"已复制" afterDelay:HUD_DELAY];
    }
}


#pragma mark Button action

- (void)jumpToFollowTieZiPage {
    
    FollowTieController *followVc = [[FollowTieController alloc] initWithTieZiId:self.model.tieZi_id
                                                                           title:@"跟贴"];
    
    
    
    //block传参数
    WeakSelf(self);
    followVc.replyTieZiBlock = ^(NSDictionary *parameter){
        
        [weakself.detailTableView.mj_footer beginRefreshing];

        weakself.isReply = YES;

    };

    
    MainNavController *mainNav = [[MainNavController alloc] initWithRootViewController:followVc];
    
    [self presentViewController:mainNav
                       animated:YES
                     completion:nil];
}

#pragma mark UITextfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.replyView.messageField) {
        [self jumpToFollowTieZiPage];
    }
    return YES;
}

#pragma  mark UI布局

- (void)layoutSubviews {
    
    //初始化楼主数据
    [self.tieZiReplyArr addObject:self.model];
    
    [self.view addSubview:self.detailTableView];
    [self.view addSubview:self.replyView];
    
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view.mas_bottom).priorityLow();
        make.left.equalTo(self.view.mas_left).priorityHigh();
        make.right.equalTo(self.view.mas_right).priorityHigh();
    }];
    
    WeakSelf(self);
    self.detailTableView.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    

    self.footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
        
    }];
    
    self.detailTableView.mj_footer = self.footer;
    
    [self.detailTableView.mj_header beginRefreshing];

    self.detailTableView.mj_footer.endRefreshingCompletionBlock = ^{
        
        if (weakself.isReply) {
            
            CGFloat bottom = weakself.detailTableView.contentSize.height - weakself.detailTableView.bounds.size.height;
            [weakself.detailTableView setContentOffset:CGPointMake(0,
                                                                   bottom)
                                          animated:YES];
            
            weakself.isReply = NO;
        }
    };
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"贴子";
    self.navigationItem.leftBarButtonItem  = self.leftBarItem;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;

    
    [self judgeNetworkStatus];

    //显示刚发布的跟贴内容，追加到tableview的最后一个
    if (self.isReleased == YES) {
        
    }

}

#pragma mark 禁止pop手势
- (void)stopSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = YES;
}

#pragma mark 开启pop手势
- (void)openSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = NO;
}


/**
 *  下拉刷新
 */
- (void)loadData {
    
    TieZi *tieZi                  = [self.tieZiReplyArr objectAtIndex:0];
    self.requestEntity.URLString = TIEZI_RELPY_URL;
    self.requestEntity.parameter = @{@"post_id":@(tieZi.tieZi_id)};

    [self loadForType:HeaderReloadDataModel];
    
}

/**
 *  上拉加载
 */
- (void)loadMoreData {

    self.requestEntity.URLString = TIEZI_RELPY_URL;
    self.requestEntity.parameter = @{@"post_id":@(self.model.tieZi_id),
                                      @"start_id":@(self.requestEntity.start_id)};
    

    [self loadForType:FooterReoladDataModel];
}

- (void)loadForType:(ReloadModel)type{
    
    @weakify(self);
    [[self.viewModel.fetchDetailEntityCommand execute:self.requestEntity] subscribeNext:^(NSArray *tieZiList) {
        @strongify(self);
        
        if (type == HeaderReloadDataModel) {
            
            //tieZiList 这里应该返回的是model成员数组，不是字典数组
            if (tieZiList.count != 0) {
                
                //最开始里面会存放一个楼主的贴子信息
                if (self.tieZiReplyArr.count == 1) {
                    
                    [self.tieZiReplyArr addObjectsFromArray:tieZiList];
                }
                else {
                    [self.tieZiReplyArr removeAllObjects];
                    [self.tieZiReplyArr addObject:self.model];
                    [self.tieZiReplyArr addObjectsFromArray:tieZiList];

                }
            }
            
            [self.detailTableView.mj_header endRefreshing];
            self.footer.stateLabel.text = @"点击或上拉查看更多跟贴";

            [self.detailTableView reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //刷新完成

                self.footer.mj_y -= 50;
                
            });
        }
        else if (type == FooterReoladDataModel) {
            
            if (tieZiList.count != 0) {
                
                [self.detailTableView.mj_footer resetNoMoreData];
                [self.tieZiReplyArr addObjectsFromArray:tieZiList];
                [self.detailTableView.mj_footer endRefreshing];
                [self.detailTableView reloadData];
                self.footer.stateLabel.text = @"点击或上拉查看更多跟贴";
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //刷新完成
                    self.footer.mj_y -= 50;
                    
                });
            }else {
                
                
                [self.detailTableView.mj_footer endRefreshingWithNoMoreData];
                self.footer.stateLabel.text = @"没有更多贴子了";
    
            }

            
        }
        if (tieZiList.count != 0) {
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            TieZiReply *lastObject           = [tieZiList objectAtIndex:tieZiList.count-1];
            self.requestEntity.start_id      = lastObject.reply_id;

        }
        
    }error:^(NSError *error) {
        //错误的情况下停止刷新（网络错误）
        [self.detailTableView.mj_header endRefreshing];
        [self.detailTableView.mj_footer endRefreshing];
    }];

}

#define mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tieZiReplyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TieZiReply *replyModel;
    replyModel                      = [self.tieZiReplyArr objectAtIndex:indexPath.row];
    NSString *cellIdentifier        = [self.viewModel idForRowByIndexPath:indexPath model:replyModel];

    YWDetailBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                      forIndexPath:indexPath];
    
    cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    cell.delegate                   = self;
    
    [self.viewModel setupModelOfCell:cell
                               model:replyModel
                           indexPath:indexPath];
    //图片显示问题，回帖中复用问题
    self.replyModel.imageUrlEntityArr = self.viewModel.imageUrlEntity;
    
    //回调block实现点击图片放大
    cell.imageTapBlock = ^(UIImageView *imageView, ImageViewItem *imagesItem) {
        
        if (imageView.tag > imagesItem.URLArr.count) {
            return ;
        }
        YWGalleryView *galleryView  = [[YWGalleryView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        galleryView.backgroundColor = [UIColor blackColor];
        galleryView.delegate = self;
        
        [galleryView setImagesItem:imagesItem showAtIndex:imageView.tag-1];
        [self.view.window.rootViewController.view addSubview:galleryView];
    };
    
    
    //这里的赋值必须在setupModelOfCell下面！！！因为bottomView的创建延迟到了viewModel中
    cell.masterView.delegate        = self;
    cell.bottomView.delegate        = self;
    cell.bottomView.favour.delegate = self;
    cell.topView.label.delegate     = self;
    cell.topView.moreBtn.delegate   = self;
    cell.moreBtn.delegate           = self;
    cell.contentLabel.delegate      = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TieZiReply *replyModel;
    replyModel                      = [self.tieZiReplyArr objectAtIndex:indexPath.row];
    NSString *cellIdentifier        = [self.viewModel idForRowByIndexPath:indexPath model:replyModel];
    
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(id cell) {
        
        [self.viewModel setupModelOfCell:cell
                                   model:replyModel
                               indexPath:indexPath];
    }];
}

//  tableview header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 0) {
        
        
        ReplyDetailController *replyVc = [[ReplyDetailController alloc] initWithReplyModel:[self.tieZiReplyArr objectAtIndex:indexPath.row]
                                                                        shouldShowKeyBoard:NO];
        [self.navigationController pushViewController:replyVc animated:YES];
    }


}

#pragma mark TTTAttributedLabelDelegate
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {

    
    MyWebViewController *webVc = [[MyWebViewController alloc] initWithURL:url];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark YWDetailTabeleViewDelegate

- (void)didSelectCommentView:(YWCommentView *)commentView {
    
    YWDetailReplyCell *cell  = (YWDetailReplyCell *)commentView.superview.superview.superview.superview;
    self.isMessage = NO;
    [self didSelectReplyCell:cell];
}

- (void)didSelectMoreCommentBtnWith:(UIButton *)btn {
    
    YWDetailReplyCell *cell  = (YWDetailReplyCell *)btn.superview.superview.superview.superview;
    self.isMessage = NO;
    [self didSelectReplyCell:cell];

}


#pragma mark - GalleryView Delegate
- (void)galleryView:(YWGalleryView *)galleryView removePageAtIndex:(NSInteger)pageIndex {
    galleryView = nil;
}

#pragma YWSpringButtonDelegate

- (void)didSelectSpringButtonOnView:(UIView *)view postId:(int)postId model:(int)model {

    
    NSDictionary *parameter = @{@"post_id":@(postId),@"value":@(model)};

    WeakSelf(self);
    
    [self.homeViewModel setLikeSuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
            
            if (statusEntity.status == YES) {
                
                if (model == YES) {
                    [weakself.homeViewModel saveLikeCookieWithPostId:[NSNumber numberWithInt:postId]];
                }
                else
                {
                    [weakself.homeViewModel deleteLikeCookieWithPostId:[NSNumber numberWithInt:postId]];
                }
                
            }
        }
        
        
    } likeFailureBlock:^(id likeFailureBlock) {
        
    }];
    
    RequestEntity *requestEntity = [[RequestEntity alloc] init];
    requestEntity.URLString = TIEZI_LIKE_URL;
    requestEntity.parameter = parameter;
    
    [self.homeViewModel requestForLikeTieZiWithRequest:requestEntity];
    
}

- (void)didSelectReplySpringButtonOnView:(UIView *)view replyId:(int)replyId model:(int)model {
    
    //点赞数量的改变，这里要注意的是，无论是否可以网络请求，本地数据都要显示改变
    UILabel *favour = [view viewWithTag:201];
    
    NSDictionary *parameter = @{@"reply_id":@(replyId),@"value":@(model)};
    
    WeakSelf(self);
    
    [self.viewModel setLikeSuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
            
            [weakself setReplyLikeCountWithModel:model countLabel:favour saveWithId:replyId];
            
        }
        
        
    } likeFailureBlock:^(id likeFailureBlock) {
        
    }];
    
    RequestEntity *requestEntity = [[RequestEntity alloc] init];
    requestEntity.URLString = TIEZI_REPLY_LIKE;
    requestEntity.parameter = parameter;
    
    [self.viewModel requestForReplyLikeTieZiWithRequest:requestEntity];
    
}

- (void)setReplyLikeCountWithModel:(Boolean)model countLabel:(UILabel *)label saveWithId:(int)postId{
    
    int count       = [label.text intValue];
    
    if (model == YES) {
        count ++;
        [self.viewModel saveLikeCookieWithReplyId:[NSNumber numberWithInt:postId]];
    }
    else
    {
        count --;
        [self.viewModel deleteLikeCookieWithReplyId:[NSNumber numberWithInt:postId]];
    }
    
    if (count >= 0) {
        label.text = [NSString stringWithFormat:@"%d",count];
    }else {
        label.text = [NSString stringWithFormat:@"%d",0];
    }
    
}


#pragma mark YWDetailCellBottomViewDelegate

//点击跟贴上的气泡，跳转到跟贴界面
//原理是监听弹出的键盘事件，再弹出跟贴界面

- (void)didSelectMessageWith:(NSInteger)post_id onSuperview:(UIView *)view{
    
    self.isMessage = YES;
    
    YWDetailReplyCell *cell  = (YWDetailReplyCell *)view.superview.superview;
    [self didSelectReplyCell:cell];
}

#pragma mark YWLabelDelegate

- (void)didSelectLabel:(YWTitle *)label {
        
    TopicController *topicVc = [[TopicController alloc] initWithTopicId:label.topic_id];
    
    [self.navigationController pushViewController:topicVc animated:YES];
    
}

#pragma mark YWMasterDelegate
-(void)didSelectMaster:(YWDetailMasterView *)masterView {

    
    TAController *taVc = [[TAController alloc] initWithUserId:masterView.user_id];
    
    [self.navigationController pushViewController:taVc animated:YES];
}

#pragma mark private method

- (void)showShareView {
    //显示分享面板
    WeakSelf(self);
     [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(YWShareView *shareSelectionView, UMSocialPlatformType platformType) {
     if (platformType == UMSocialPlatformType_Sina) { //如果是微博平台的话，分享文本
     [weakself.viewModel shareTextToPlatformType:platformType withModel:self.model];
     }else {
     //其他平台分享网页
     [weakself.viewModel shareWebPageToPlatformType:platformType withModel:self.model];
     }
     }];
    
    
}

/*
 *  添加跟贴到tableview的最后一个
 */
- (void)addReplyViewAtLastWith:(NSDictionary *)paramters {
    
    Customer *user          = [User findCustomer];
    //获取刚才发布的跟贴
    TieZiReply *reply       = [TieZiReply mj_objectWithKeyValues:paramters];

    reply.imageUrlEntityArr = [NSString separateImageViewURLString:reply.img];
    reply.user_name         = user.name;
    reply.user_face_img     = user.face_img;
    reply.create_time       = [[NSDate date] timeIntervalSince1970];
    
    //将跟帖添加到self.tieZiReplyArr数组中
    
    [self.tieZiReplyArr addObject:reply];
    
    //通过initWithIndex获取需要添加的所在位置 （count－1）
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tieZiReplyArr.count-1
                                                inSection:0];
    [self.detailTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                withRowAnimation:UITableViewRowAnimationAutomatic];
    
    //通过insertSections将数据插入到tableview的指定数组中

}

- (void)didSelectReplyCell:(YWDetailReplyCell *)replyCell {
    
    NSIndexPath *selectIndex       = [self.detailTableView indexPathForCell:replyCell];
    TieZiReply *model              = [self.tieZiReplyArr objectAtIndex:selectIndex.row];

    ReplyDetailController *replyVc = [[ReplyDetailController alloc] initWithReplyModel:model
                                                                    shouldShowKeyBoard:self.isMessage];
    
    [self.navigationController pushViewController:replyVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  网路监测
 */
- (void)judgeNetworkStatus {
    [YWNetworkTools networkStauts];
}


@end
