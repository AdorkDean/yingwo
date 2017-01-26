//
//  DetailController.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DetailController.h"
#import "AnnounceController.h"
#import "TopicController.h"

#import "YWDetailTableViewCell.h"
#import "YWDetailBaseTableViewCell.h"
#import "YWDetailReplyCell.h"

#import "DetailViewModel.h"
#import "UMSocialUIManager.h"

#import "YWDetailBottomView.h"
#import "YWDetailCommentView.h"
#import "YWCommentView.h"

#import "TieZiComment.h"

#import "YWAlertButton.h"

@interface DetailController ()<UITableViewDelegate,UITableViewDataSource,YWDetailTabeleViewDelegate,YWGalleryViewDelegate,UITextFieldDelegate,YWKeyboardToolViewProtocol,ISEmojiViewDelegate,HPGrowingTextViewDelegate,YWDetailCellBottomViewDelegate,YWSpringButtonDelegate,YWAlertButtonProtocol, YWTitleDelegate,TTTAttributedLabelDelegate,YWMasterDelegate>

@property (nonatomic, strong) UITableView         *detailTableView;
@property (nonatomic, strong) UIBarButtonItem     *leftBarItem;
@property (nonatomic, strong) UIBarButtonItem     *rightBarItem;
@property (nonatomic, strong) UIAlertController   *alertView;
@property (nonatomic, strong) UIAlertController   *compliantAlertView;

@property (nonatomic, strong) YWDetailReplyCell   *commentCell;

@property (nonatomic, strong) YWDetailBottomView  *replyView;
@property (nonatomic, strong) YWDetailCommentView *commentView;
@property (nonatomic, strong) YWGalleryView         *galleryView;

@property (nonatomic, strong) DetailViewModel     *viewModel;
@property (nonatomic, strong) GalleryViewModel      *homeViewModel;

@property (nonatomic, strong) RequestEntity       *requestEntity;
@property (nonatomic, strong) TieZiComment        *commentEntity;

@property (nonatomic, strong) YWCommentView       *selectCommentView;

//点击查看话题内容
@property (nonatomic, assign) int                 tap_topic_id;
//点击查看用户详情
@property (nonatomic, assign) int                 tap_ta_id;

@property (nonatomic, assign) CGFloat             navgationBarHeight;

@property (nonatomic, strong) NSMutableArray      *tieZiReplyArr;
@property (nonatomic, strong) NSMutableDictionary *commetparameter;

@property (nonatomic,assign ) int                 comment_reply_id;

@property (nonatomic, assign) CGFloat             keyboardHeight;

@end

@implementation DetailController

static NSString *detailCellIdentifier      = @"detailCell";
static NSString *detailReplyCellIdentifier = @"replyCell";

#pragma mark 懒加载

- (UITableView *)detailTableView {
    if (_detailTableView == nil) {
        _detailTableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _detailTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _detailTableView.backgroundColor = [UIColor clearColor];
        _detailTableView.delegate        = self;
        _detailTableView.dataSource      = self;
        _detailTableView.contentInset    = UIEdgeInsetsMake(0, 0, 40, 0);
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

- (TieZiComment *)commentEntity {
    if (_commentEntity == nil) {
        _commentEntity = [[TieZiComment alloc] init];
    }
    return _commentEntity;
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

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToHomePage)];
    }
    return _leftBarItem;
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


#pragma mark add action

- (void)addAllAction {
    
}

#pragma mark Button action

- (void)jumpToHomePage {
    //隐藏键盘
    [self hiddenKeyboard];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)jumpToFollowTieZiPage {
    AnnounceController *announceVC = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_ANNOUNCE_IDENTIFIER];
    announceVC.isFollowTieZi       = YES;
    announceVC.post_id             = self.model.tieZi_id;
    
    //block传参数
    announceVC.replyTieZiBlock = ^(NSDictionary *parameter,BOOL isRelease){
        if (isRelease == YES) {
            
//            [self addReplyViewAtLastWith:parameter];
            [self.detailTableView.mj_footer beginRefreshing];

        }
    };

    
    MainNavController *mainNav = [[MainNavController alloc] initWithRootViewController:announceVC];
    
    [self presentViewController:mainNav
                       animated:YES
                     completion:nil];
}

- (void)showShareView {
    //显示分享面板
    __weak typeof(self) weakSelf = self;
       [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(YWShareView *shareSelectionView, UMSocialPlatformType platformType) {
           if (platformType == UMSocialPlatformType_Sina) { //如果是微博平台的话，分享文本
               [weakSelf.viewModel shareTextToPlatformType:platformType withModel:self.model];
           }else {
               //其他平台分享网页
               [weakSelf.viewModel shareWebPageToPlatformType:platformType withModel:self.model];
           }
    }];
    
}

#pragma mark UITextfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.replyView.messageField) {
        [self jumpToFollowTieZiPage];
    }
    return YES;
}

#pragma  mark UI布局

- (void)setAllUILayout {
    self.replyView.mas_key = @"replyView";
    
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view.mas_bottom).priorityLow();
        make.left.equalTo(self.view.mas_left).priorityHigh();
        make.right.equalTo(self.view.mas_right).priorityHigh();
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化楼主数据
    [self.tieZiReplyArr addObject:self.model];
    
    [self.view addSubview:self.detailTableView];
    [self.view addSubview:self.replyView];
    
    __weak DetailController *weakSelf = self;
    self.detailTableView.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
    self.detailTableView.mj_footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    [self setAllUILayout];

    [self.detailTableView.mj_header beginRefreshing];
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

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear: animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //监听键盘frame改变事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
     //监听键盘消失事件
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(didHiddenKeyboard:)
                                                  name:UIKeyboardDidHideNotification
                                                object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willHiddKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

#pragma mark 禁止pop手势
- (void)stopSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = YES;
}

#pragma mark 开启pop手势
- (void)openSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = NO;
}


//键盘弹出后调用
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
    
    //获取键盘的frame
    CGRect endFrame  = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    //获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];

    //修改底部视图高度
    CGFloat bottom   = endFrame.origin.y != SCREEN_HEIGHT ? endFrame.origin.y:0;

    CGFloat originY;
    
    if (bottom == 0) {
        originY = SCREEN_HEIGHT;
    }
    else
    {
        originY = bottom - self.navgationBarHeight - 44 ;

    }
    // 约束动画
    [UIView animateWithDuration:duration
                     animations:^{
        
        self.commentView.frame = CGRectMake(0,
                                            originY,
                                            SCREEN_WIDTH,
                                            45);
    }];
    
}

- (void)didHiddenKeyboard:(NSNotification *) notes{
    
    self.commentView = nil;

}

- (void)willHiddKeyboard:(NSNotification *) notes{
    
    self.detailTableView.frame = self.view.bounds;
}

- (void)loadTieziDetail {
    NSDictionary *parameter = @{@"post_id":@(self.push_post_id)};

    //必须要加载cookie，否则无法请求
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    /*
    [self.viewModel requestDetailWithUrl:TIEZI_DETAIL
                             parameters:parameter
                                success:^(TieZi *tieZi) {
                                    
                                    self.model = tieZi;
                                    
    }                           failure:^(NSString *error) {
        
    }];*/
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
               //     NSLog(@"tieZiList.count:%lu",(unsigned long)tieZiList.count);
                 //   NSLog(@"self.tieZiReplyArr.count:%lu",(unsigned long)self.tieZiReplyArr.count);
                }
                else {
                    [self.tieZiReplyArr removeAllObjects];
                    [self.tieZiReplyArr addObject:self.model];
                    [self.tieZiReplyArr addObjectsFromArray:tieZiList];

                }
            }
            
            [self.detailTableView.mj_header endRefreshing];
            [self.detailTableView reloadData];
            
        }
        else if (type == FooterReoladDataModel) {
            
            if (tieZiList != nil) {
                
                [self.detailTableView.mj_footer resetNoMoreData];
                [self.tieZiReplyArr addObjectsFromArray:tieZiList];
                [self.detailTableView.mj_footer endRefreshing];
                [self.detailTableView reloadData];
            }else {
                [self.detailTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        if (tieZiList.count != 0) {
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            TieZiReply *lastObject           = [tieZiList objectAtIndex:tieZiList.count-1];
            self.requestEntity.start_id      = lastObject.reply_id;

        }
        
//        [self.detailTableView.mj_footer endRefreshingWithNoMoreData];
        
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
    [self hiddenKeyboard];
}

#pragma mark TTTAttributedLabelDelegate
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {

    
    YWWebViewController *webVc = [[YWWebViewController alloc] initWithURL:url];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark YWDetailTabeleViewDelegate

- (void)didSeletedImageView:(UIImageView *)seletedImageView {
    
    [self covertImageView:seletedImageView];
}

- (void)didSelectCommentView:(YWCommentView *)commentView {
    
    [self.view addSubview:self.commentView];
    //评论的评论
    self.commentType                               = CommentedModel;

    self.selectCommentView                         = commentView;

    //  获取点击的cell
    self.commentCell                               = (YWDetailReplyCell *)commentView.superview.superview.superview.superview;
    //评论所需参数
    self.commetparameter[@"post_reply_id"]        = @(commentView.post_reply_id);
    self.commetparameter[@"post_comment_id"]      = @(commentView.post_comment_id);
    self.commetparameter[@"post_comment_user_id"] = @(commentView.post_comment_user_id);
    self.commentView.messageTextView.placeholder   = [NSString stringWithFormat:@"回复 %@:",commentView.user_name];

    [self.commentView.messageTextView becomeFirstResponder];
    
    
    //获取相对self.view的坐标
    CGRect commentViewFrame = [commentView convertRect:commentView.frame
                                     toView:self.view];
    //如果键盘遮挡住了评论的view，需要上移
    if (commentViewFrame.origin.y > self.commentView.frame.origin.y) {
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             
                             self.detailTableView.frame = CGRectMake(0,
                                                                     -(SCREEN_HEIGHT-commentViewFrame.origin.y+44),
                                                                     SCREEN_WIDTH,
                                                                     SCREEN_HEIGHT);
                             
                         }];
 
    }
    
    
}

/**
 *  坐标转换
 *
 *  @param imageView
 */
- (void)covertImageView:(UIImageView *)imageView {
    
//    NSLog(@"%@", NSStringFromCGRect(imageView.frame));
    UIImageView *newImageView = [[UIImageView alloc] init];
    newImageView.frame        = [imageView.superview convertRect:imageView.frame toView:self.view];
//    NSLog(@"%@", NSStringFromCGRect(newImageView.frame));
    newImageView.image        = imageView.image;
    newImageView.y            += self.navgationBarHeight;
    newImageView.tag          = imageView.tag;
    newImageView.clipsToBounds = YES;

    //
    if ([imageView.superview.superview.superview.superview isKindOfClass:[YWDetailTableViewCell class]]) {
       // [self showImageView:newImageView];
    }else {
        [self showReplyImageView:newImageView];
    }
    
    
}
/**
 *  展示图片
 *
 *  @param imageView
 */
/*
- (void)showImageView:(UIImageView *)imageView {
    
    NSMutableArray *imageViewArr = [NSMutableArray arrayWithCapacity:self.model.imageUrlArrEntity.count];
    
    ImageViewEntity *lastEntity = [self.model.imageUrlArrEntity lastObject];
    
    if (lastEntity.isDownload == YES) {
        for (int i = 0; i < self.model.imageUrlArrEntity.count; i++) {
            ImageViewEntity *entity = [self.model.imageUrlArrEntity objectAtIndex:i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:entity.imageName]];
            [imageViewArr addObject:imageView];
        }
    }else {
        for (int i = 0; i < self.model.imageUrlArrEntity.count; i++) {
            [imageViewArr addObject:imageView];
        }
    }
   
    [self.galleryView setImageViews:imageViewArr
              withImageUrlArrEntity:self.model.imageUrlArrEntity
                        showAtIndex:imageView.tag - 1];
    
    [self.navigationController.view addSubview:self.galleryView];
    
}
*/
/**
  *  展示回复视图图片
  *
  *  @param imageView
  */
- (void)showReplyImageView:(UIImageView *)imageView {
    
    [self stopSystemPopGestureRecognizer];
    
    NSMutableArray *imageViewArr = [NSMutableArray arrayWithCapacity:self.replyModel.imageUrlEntityArr.count];
    
    for (int i = 0; i < self.replyModel.imageUrlEntityArr.count; i++) {
        [imageViewArr addObject:imageView];
    }
    
//    [self.galleryView setImageViews:imageViewArr
//              withImageUrlArrEntity:self.replyModel.imageUrlArrEntity
//                        showAtIndex:imageView.tag - 1];
//    
    [self.navigationController.view addSubview:self.galleryView];
    
}


#pragma mark - GalleryView Delegate

//- (void)galleryView:(GalleryView *)galleryView didShowPageAtIndex:(NSInteger)pageIndex
//{
//}
//
//- (void)galleryView:(GalleryView *)galleryView didSelectPageAtIndex:(NSInteger)pageIndex
//{
//    [self.galleryView removeImageView];
//}
//
//- (void)galleryView:(GalleryView *)galleryView removePageAtIndex:(NSInteger)pageIndex {
//    self.galleryView = nil;
//    
//    //开启滑动手势
//    [self openSystemPopGestureRecognizer];
//}

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
    
    [self.homeViewModel setLikeSuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
            
            [weakself setReplyLikeCountWithModel:model countLabel:favour saveWithId:replyId];
            
        }
        
        
    } likeFailureBlock:^(id likeFailureBlock) {
        
    }];
    
    RequestEntity *requestEntity = [[RequestEntity alloc] init];
    requestEntity.URLString = TIEZI_REPLY_LIKE;
    requestEntity.parameter = parameter;
    
    [self.homeViewModel requestForLikeTieZiWithRequest:requestEntity];
    
}

- (void)setReplyLikeCountWithModel:(Boolean)model countLabel:(UILabel *)label saveWithId:(int)postId{
    
    int count       = [label.text intValue];
    
    if (model == YES) {
        count ++;
        [self.homeViewModel saveLikeCookieWithReplyId:[NSNumber numberWithInt:postId]];
    }
    else
    {
        count --;
        [self.homeViewModel deleteLikeCookieWithReplyId:[NSNumber numberWithInt:postId]];
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
    
    [self.view addSubview:self.commentView];
    
    self.commentType                        = TieZiCommentModel;
    
    self.commetparameter[@"post_reply_id"] = @(post_id);

    //获得被评论的cell
    self.commentCell                        = (YWDetailReplyCell *)view.superview.superview;

    [self.commentView.messageTextView becomeFirstResponder];

}

#pragma mark YWKeyboardToolViewProtocol

- (void)didSelectedEmoji {
    
    [self.commentView.messageTextView becomeFirstResponder];
        
    ISEmojiView *emojiView = [[ISEmojiView alloc] initWithTextField:self.commentView.messageTextView
                                                           delegate:self];
    
    self.commentView.messageTextView.internalTextView.inputView = emojiView;
    [self.commentView.messageTextView.internalTextView reloadInputViews];
}

- (void)didSelectedKeyboard {
    
    [self.commentView.messageTextView becomeFirstResponder];
    
    //先去除表情包的所占的inputView，否则弹不出键盘
    self.commentView.messageTextView.internalTextView.inputView = nil;
    
    self.commentView.messageTextView.internalTextView.keyboardType = UIKeyboardTypeDefault;
    [self.commentView.messageTextView.internalTextView reloadInputViews];
    
}

#pragma mark ISEmojiViewDelegate

-(void)emojiView:(ISEmojiView *)emojiView didSelectEmoji:(NSString *)emoji{
    NSRange insertRange = self.commentView.messageTextView.selectedRange;
    self.commentView.messageTextView.text = [self.commentView.messageTextView.text stringByReplacingCharactersInRange:insertRange withString:emoji];
    //插入后光标仍在插入后的位置
    self.commentView.messageTextView.selectedRange = NSMakeRange(insertRange.location + emoji.length, 0);

}

-(void)emojiView:(ISEmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton{
    if (self.commentView.messageTextView.text.length > 0) {
        NSRange lastRange = [self.commentView.messageTextView.text rangeOfComposedCharacterSequenceAtIndex:self.commentView.messageTextView.text.length-1];
        self.commentView.messageTextView.text = [self.commentView.messageTextView.text substringToIndex:lastRange.location];
    }
}

#pragma mark HPGrowingTextViewDelegate

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView {
    
    //没有内容不让发送
    if ([Validate validateIsEmpty:self.commentView.messageTextView.text]) {
    
        [SVProgressHUD showErrorStatus:@"请填写内容～" afterDelay:HUD_DELAY];
    }
    else
    {
        [self commentTieZi];
    }
    
    
    return YES;
}

#pragma mark HPGrowingTextViewDelegate

-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{

//    NSLog(@"growingTextViewheight:%f",growingTextView.height);
//    NSLog(@"width:%f",height);
//
    if (height != 0 && growingTextView.height != 0) {
        
        //growingTextView 比height要高1
        CGFloat diff                           = growingTextView.height+1 - height;
        
        //改变growingTextView的高度这里默认为三行高度
        growingTextView.height                 -= diff;
        self.commentView.backgroundView.height -= diff;
        
        
        self.commentView.frame                = CGRectMake(0,
                                                           self.commentView.y+diff,
                                                           self.commentView.width,
                                                           self.commentView.height-diff);

    }

    
}

#pragma mark segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //进入话题详情页面
    if ([segue.destinationViewController isKindOfClass:[TopicController class]]) {
        if ([segue.identifier isEqualToString:@"topic"]) {
            TopicController *topicVc = segue.destinationViewController;
            topicVc.topic_id = self.tap_topic_id;
        }
    }
    //进入TA的主页
    else if ([segue.destinationViewController isKindOfClass:[TAController class]]) {
        if ([segue.identifier isEqualToString:@"ta"]) {
            TAController *taVc = segue.destinationViewController;
            taVc.ta_id         = self.tap_ta_id;
        }
    }
}

#pragma mark YWLabelDelegate

- (void)didSelectLabel:(YWTitle *)label {
    
    self.tap_topic_id = label.topic_id;
    [self performSegueWithIdentifier:@"topic" sender:self];
}

#pragma mark YWMasterDelegate
-(void)didSelectMaster:(YWDetailMasterView *)masterView {

    self.tap_ta_id = masterView.user_id;
    [self performSegueWithIdentifier:@"ta" sender:self];
}

#pragma private method

/**
 *  贴子评论、评论的评论
 */
- (void)commentTieZi {
    
    self.commetparameter[@"content"] = self.commentView.messageTextView.text;
    
    [self.viewModel postCommentWithUrl:TIEZI_COMMENT_URL
                            parameter:self.commetparameter
                               success:^(StatusEntity *status) {
        
                                   if (status.status == YES) {
                                       [self hiddenKeyboard];
                                       [self addCommentOnReplyTieZi];
                                   }
    } failure:^(NSString *error) {
        
    }];

}


/**
 *  页面上添加评论
 */
- (void)addCommentOnReplyTieZi {
    
    NSIndexPath *indexPath  = [self.detailTableView indexPathForCell:self.commentCell];
    
    TieZiReply *replyEntity = [self.tieZiReplyArr objectAtIndex:indexPath.row];
    
    NSDictionary *parameter = @{@"post_reply_id":@(replyEntity.reply_id)};
    
    [self.viewModel requestForCommentWithUrl:TIEZI_COMMENT_LIST_URL
                                  parameter:parameter
                                     success:^(NSArray *commentArr) {
                                         [SVProgressHUD showSuccessStatus:@"评论成功" afterDelay:HUD_DELAY];
                                         
                                         replyEntity.commentArr = [commentArr mutableCopy];
                                         //替换新的评论
                                         [self.tieZiReplyArr replaceObjectAtIndex:indexPath.row
                                                                       withObject:replyEntity];
                                         //更新cell，更新评论
                                         [self.detailTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil]
                                                                     withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSString *error) {
        
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

#pragma mark 收起键盘
- (void)hiddenKeyboard {
    
    self.commetparameter      = nil;
    self.selectCommentView     = nil;
    self.detailTableView.frame = self.view.bounds;

    [self.commentView.messageTextView resignFirstResponder];
    
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
