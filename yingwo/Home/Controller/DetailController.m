//
//  DetailController.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DetailController.h"
#import "AnnounceController.h"
#import "MainNavController.h"

#import "YWDetailTableViewCell.h"
#import "YWDetailBaseTableViewCell.h"
#import "YWDetailReplyCell.h"

#import "DetailViewModel.h"
#import "TieZiViewModel.h"

#import "YWDetailBottomView.h"
#import "YWDetailCommentView.h"
#import "YWCommentView.h"

#import "TieZiComment.h"

#import "YWAlertButton.h"

@interface DetailController ()<UITableViewDelegate,UITableViewDataSource,YWDetailTabeleViewDelegate,GalleryViewDelegate,UITextFieldDelegate,YWKeyboardToolViewProtocol,ISEmojiViewDelegate,HPGrowingTextViewDelegate,YWDetailCellBottomViewDelegate,YWSpringButtonDelegate,YWAlertButtonProtocol>

@property (nonatomic, strong) UITableView         *detailTableView;
@property (nonatomic, strong) UIBarButtonItem     *leftBarItem;
@property (nonatomic, strong) UIBarButtonItem     *rightBarItem;
@property (nonatomic, strong) UIAlertController   *alertView;
@property (nonatomic, strong) UIAlertController   *compliantAlertView;

@property (nonatomic, strong) YWDetailReplyCell   *commentCell;

@property (nonatomic, strong) YWDetailBottomView  *replyView;
@property (nonatomic, strong) YWDetailCommentView *commentView;
@property (nonatomic, strong) GalleryView         *galleryView;

@property (nonatomic, strong) DetailViewModel     *viewModel;
@property (nonatomic, strong) TieZiViewModel      *homeViewModel;

@property (nonatomic, strong) RequestEntity       *requestEntity;
@property (nonatomic, strong) TieZiComment        *commentEntity;

@property (nonatomic, strong) YWCommentView       *selectCommentView;

@property (nonatomic,assign ) CGFloat             navgationBarHeight;

@property (nonatomic, strong) NSMutableArray      *tieZiReplyArr;
@property (nonatomic, strong) NSMutableDictionary *commetParamaters;

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
        _detailTableView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);
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

- (TieZiViewModel *)homeViewModel {
    if (_homeViewModel == nil) {
        _homeViewModel = [[TieZiViewModel alloc] init];
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

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToHomePage)];
    }
    return _leftBarItem;
}

- (UIBarButtonItem *)rightBarItem {
    if (_rightBarItem == nil) {
        _rightBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:nil];
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
        if ( [self.homeViewModel isLikedTieZiWithTieZiId:[NSNumber numberWithInt:self.model.tieZi_id]]) {
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

- (GalleryView *)galleryView {
    if (_galleryView == nil) {
        _galleryView                 = [[GalleryView alloc] initWithFrame:[UIScreen mainScreen].bounds];
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

- (NSMutableDictionary *)commetParamaters {
    if (_commetParamaters == nil) {
        _commetParamaters = [[NSMutableDictionary alloc] init];
    }
    return _commetParamaters;
}

- (CGFloat)navgationBarHeight {
    //导航栏＋状态栏高度
    return  self.navigationController.navigationBar.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
}

#pragma mark YWAlertButtonProtocol
- (void)seletedAlertView:(UIAlertController *)alertView onMoreBtn:(UIButton *)more atIndex:(NSInteger)index{
    if (index == 0) {
        [self copyTiZiText:more];
        
    }else if (index == 1) {
        self.alertView = alertView;
        [self showCompliantAlertView];
        
    }
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
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)more.superview.superview.superview.superview;
    NSString *copyString = selectedCell.contentText.text;
    //复制到剪切板
    pasteboard.string = copyString;
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
    MainNavController *mainNav = [[MainNavController alloc] initWithRootViewController:announceVC];

    [self presentViewController:mainNav
                       animated:YES
                     completion:nil];
}

//跳转传参，这里是跟帖，需要贴子的id
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[AnnounceController class]]) {
        if ([segue.identifier isEqualToString:SEGUE_IDENTIFY_FOLLOW_TIEZI]) {
            AnnounceController *announceVC = segue.destinationViewController;
            announceVC.isFollowTieZi       = YES;
            announceVC.post_id             = self.model.tieZi_id;
        }
    }
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
    
    self.detailTableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
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

/**
 *  下拉刷新
 */
- (void)loadData {
    
    TieZi *tieZi                  = [self.tieZiReplyArr objectAtIndex:0];
    self.requestEntity.requestUrl = TIEZI_RELPY_URL;
    self.requestEntity.paramaters = @{@"post_id":@(tieZi.tieZi_id)};

    [self loadForType:HeaderReloadDataModel];
    
}

/**
 *  上拉加载
 */
- (void)loadMoreData {
    
    TieZi *tieZi                  = [self.tieZiReplyArr objectAtIndex:0];
    self.requestEntity.requestUrl = TIEZI_RELPY_URL;
    self.requestEntity.paramaters = @{@"post_id":@(tieZi.tieZi_id)};

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
            
            [self.tieZiReplyArr addObjectsFromArray:tieZiList];
            [self.detailTableView.mj_footer endRefreshing];
            [self.detailTableView reloadData];
            
        }
        
        //获得最后一个帖子的id,有了这个id才能向前继续获取model
        TieZi *lastObject           = [tieZiList objectAtIndex:tieZiList.count-1];
        self.requestEntity.start_id = lastObject.tieZi_id;

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

    YWDetailBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    cell.delegate                   = self;

    [self.viewModel setupModelOfCell:cell
                               model:replyModel
                           indexPath:indexPath];
    
    //这里的赋值必须在setupModelOfCell下面！！！因为bottomView的创建延迟到了viewModel中
    cell.bottomView.delegate        = self;

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
    self.commetParamaters[@"post_reply_id"]        = @(commentView.post_reply_id);
    self.commetParamaters[@"post_comment_id"]      = @(commentView.post_comment_id);
    self.commetParamaters[@"post_comment_user_id"] = @(commentView.post_comment_user_id);
    self.commentView.messageTextView.placeholder   = [NSString stringWithFormat:@"回复%@:",commentView.user_name];

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
    
    UIImageView *newImageView = [[UIImageView alloc] init];
    newImageView.frame        = [imageView.superview convertRect:imageView.frame toView:self.view];
    newImageView.image        = imageView.image;
    newImageView.y            += self.navgationBarHeight;
    newImageView.tag          = 1;

    [self showImageView:newImageView];
    
}
/**
 *  展示图片
 *
 *  @param imageView
 */
- (void)showImageView:(UIImageView *)imageView {
    
    //禁止后面的DetailController的滑动手势
    //这里不禁止的话，会造成点击看图片，然后左滑动的时候DetailController pop 回HomeController中
    
    [self stopSystemPopGestureRecognizer];

    
    NSMutableArray *imageViewArr = [NSMutableArray arrayWithCapacity:1];
    [imageViewArr addObject:imageView];
    
    [self.galleryView setImages:imageViewArr showAtIndex:0];
    [self.navigationController.view addSubview:self.galleryView];

}

#pragma mark - GalleryView Delegate

- (void)galleryView:(GalleryView *)galleryView didShowPageAtIndex:(NSInteger)pageIndex
{
}

- (void)galleryView:(GalleryView *)galleryView didSelectPageAtIndex:(NSInteger)pageIndex
{
    [self.galleryView removeImageView];
}

- (void)galleryView:(GalleryView *)galleryView removePageAtIndex:(NSInteger)pageIndex {
    self.galleryView = nil;
    
    //开启滑动手势
    [self openSystemPopGestureRecognizer];
}

#pragma YWSpringButtonDelegate

- (void)didSelectSpringButtonOnView:(UIView *)view postId:(int)postId model:(int)model {
    
    //网络请求
    NSDictionary *paramaters = @{@"post_id":@(postId),@"value":@(model)};
    
    [self.homeViewModel postTieZiLIkeWithUrl:TIEZI_LIKE_URL
                                  paramaters:paramaters
                                     success:^(StatusEntity *statusEntity) {
                                     
                                     if (statusEntity.status == YES) {
                                         
                                         if (model == YES) {
                                             
                                             [self.homeViewModel saveLikeCookieWithPostId:[NSNumber numberWithInt:postId]];
                                         }
                                         else
                                         {
                                             [self.homeViewModel deleteLikeCookieWithPostId:[NSNumber numberWithInt:postId]];
                                         }
                                     }
                                     
                                 } failure:^(NSString *error) {
                                     
                                 }];
    
}



#pragma mark YWDetailCellBottomViewDelegate

//点击跟贴上的气泡，跳转到跟贴界面
//原理是监听弹出的键盘事件，再弹出跟贴界面

- (void)didSelectMessageWith:(NSInteger)post_id onSuperview:(UIView *)view{
    
    [self.view addSubview:self.commentView];
    
    self.commentType                        = TieZiCommentModel;
    
    self.commetParamaters[@"post_reply_id"] = @(post_id);

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
    self.commentView.messageTextView.text = [self.commentView.messageTextView.text stringByAppendingString:emoji];
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

#pragma private method

/**
 *  贴子评论、评论的评论
 */
- (void)commentTieZi {
    
    self.commetParamaters[@"content"] = self.commentView.messageTextView.text;
    
    [self.viewModel postCommentWithUrl:TIEZI_COMMENT_URL
                            paramaters:self.commetParamaters
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
    
    NSDictionary *paramaters = @{@"post_reply_id":@(replyEntity.reply_id)};
    
    [self.viewModel requestForCommentWithUrl:TIEZI_COMMENT_LIST_URL
                                  paramaters:paramaters
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
- (void)addReplyViewAtLast {
    
    NSUInteger lastIndex = self.tieZiReplyArr.count;
    
    //获取刚才发布的跟贴
    
    //将跟帖添加到self.tieZiReplyArr数组中
    
    
    //通过initWithIndex获取需要添加的所在位置 （count－1）
    
    
    //通过insertSections将数据插入到tableview的制定数组中
}

#pragma mark 收起键盘
- (void)hiddenKeyboard {
    
    self.commetParamaters      = nil;
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
