//
//  ReplyDetailController.m
//  yingwo
//
//  Created by apple on 2017/1/30.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//
#import "ReplyDetailController.h"
#import "TopicController.h"
#import "ReplyViewModel.h"

#import "UMSocialUIManager.h"

#import "MessageEntity.h"

@interface ReplyDetailController ()<UITableViewDelegate,UITableViewDataSource,YWDetailTabeleViewDelegate,YWGalleryViewDelegate,UITextFieldDelegate,YWKeyboardToolViewProtocol,ISEmojiViewDelegate,HPGrowingTextViewDelegate,YWDetailCellBottomViewDelegate,YWSpringButtonDelegate,YWAlertButtonProtocol, YWTitleDelegate,TTTAttributedLabelDelegate,YWMasterDelegate>

@property (nonatomic, strong) UITableView         *tableView;

@property (nonatomic, strong) ReplyViewModel      *viewModel;

@property (nonatomic, strong) UIAlertController   *alertView;
@property (nonatomic, strong) UIAlertController   *compliantAlertView;

@property (nonatomic, strong) NSIndexPath         *indexPath;

@property (nonatomic, strong) YWDetailBottomView  *replyView;
@property (nonatomic, strong) YWDetailCommentView *commentView;

@property (nonatomic, strong) RequestEntity       *requestEntity;
@property (nonatomic, strong) TieZiComment        *commentEntity;

@property (nonatomic, strong) YWCommentView       *selectCommentView;

@property (nonatomic, assign) CGFloat             navgationBarHeight;

@property (nonatomic, strong) NSMutableArray      *tieZiReplyArr;
@property (nonatomic, strong) NSMutableDictionary *commetparameter;

@property (nonatomic,assign ) int                 comment_reply_id;

@property (nonatomic, assign) CGFloat             keyboardHeight;

@end

@implementation ReplyDetailController

static NSString *replyCellIdentifier = @"replyCell";

- (instancetype)initWithReplyModel:(TieZiReply *)model shouldShowKeyBoard:(BOOL)yesOrNo {
    
    self = [super init];
    if (self) {
        
        self.model = model;
        self.shouldShowKeyboard = yesOrNo;


    }
    
    return self;
    
}

#pragma mark 懒加载

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView                 = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.contentInset    = UIEdgeInsetsMake(0, 0, 80, 0);
        [_tableView registerClass:[YWReplyCell class] forCellReuseIdentifier:replyCellIdentifier];
        
    }
    return _tableView;
}

- (ReplyViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel                 = [[ReplyViewModel alloc] init];
        
    }
    return _viewModel;
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
        
        _replyView.messageField.placeholder = [NSString stringWithFormat:@"%d个评论 %@个赞",
                                               self.model.comment_cnt,
                                               self.model.like_cnt];
    }
    return _replyView;
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
    
    //判断删除跟帖
    if ([more.superview.superview.superview isKindOfClass:[YWDetailReplyCell class]]) {
        
        //获取当前选中的cell的reply_id
        YWDetailReplyCell *selectedCell = (YWDetailReplyCell *)more.superview.superview.superview;
        NSIndexPath *indexPath          = [self.tableView indexPathForCell:selectedCell];
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
    
    [self.viewModel setDeleteSuccessBlock:^(StatusEntity *statusEntity) {
        
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
    
    [self.viewModel deleteTieZiWithRequest:request];
    
    
}

- (void)deleteReplyTieZiWithRequest:(RequestEntity *)request indexPath:(NSIndexPath *)indexPath{
    
    WeakSelf(self);
    
    [self.viewModel setDeleteSuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
                        
            [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:1.0];
            
            [weakself.navigationController popViewControllerAnimated:YES];

        }else if (statusEntity.status == NO){
            
            [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:1.0];
        }
        
        
    } failureBlock:^(id deleteFailureBlock) {
        
    }];
    
    [self.viewModel deleteTieZiWithRequest:request];
    
    
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

#pragma mark UITextfieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.replyView.messageField) {
        [self commentOnReplyView:textField];
    }
    return YES;
}

#pragma  mark UI布局

- (void)layoutSubviews {
    

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.replyView];
    
    [self.tableView.mj_header beginRefreshing];
    
    [self.replyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.view.mas_bottom).priorityLow();
        make.left.equalTo(self.view.mas_left).priorityHigh();
        make.right.equalTo(self.view.mas_right).priorityHigh();
    }];
    
    WeakSelf(self);
    self.tableView.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.model.floor == 0) {
        self.title = @"评论详情";
    }
    else {
        
        self.title = [NSString stringWithFormat:@"%d楼",self.model.floor];

    }
    self.navigationItem.leftBarButtonItem  = self.leftBarItem;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //监听键盘frame改变事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    //监听键盘frame改变事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hadChangeKeyboard:)
                                                 name:UIKeyboardDidChangeFrameNotification
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
    
    if (self.shouldShowKeyboard) {
        
        [self.replyView.messageField becomeFirstResponder];
        
        self.commetparameter[@"post_reply_id"]        = @(self.model.reply_id);
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


//键盘弹出后调用
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
    [self.commentView.messageTextView becomeFirstResponder] ;

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
        originY = bottom - self.navgationBarHeight - 44 - 60;
        
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

- (void)hadChangeKeyboard:(NSNotification *) notes {
    
    [self.commentView.messageTextView becomeFirstResponder] ;

}

- (void)didHiddenKeyboard:(NSNotification *) notes{
    
    self.commentView = nil;
    
}

- (void)willHiddKeyboard:(NSNotification *) notes{
    
    self.tableView.frame = self.view.bounds;
}

/**
 *  下拉刷新
 */
- (void)loadData {
    
    self.requestEntity.URLString = TIEZI_RELPY_URL;

    self.requestEntity.parameter = @{@"post_id":@(self.model.post_id),
                                     @"post_reply_id":@(self.model.reply_id)};
    
    DLog(@"parameter:%@",self.requestEntity.parameter);
    [self loadForType:HeaderReloadDataModel];
    
}

- (void)loadForType:(ReloadModel)type{
    
    @weakify(self);
    [[self.viewModel.fetchReplyEntityCommand execute:self.requestEntity] subscribeNext:^(NSArray *replyArr) {
        @strongify(self);
        
        if (type == HeaderReloadDataModel) {
            
            if (replyArr.count != 0) {
                
                self.tieZiReplyArr = [replyArr mutableCopy];
                [self.tableView reloadData];
                
            }
        }
        
        
        [self.tableView.mj_header endRefreshing];

    }error:^(NSError *error) {
        //错误的情况下停止刷新（网络错误）
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#define mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tieZiReplyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    YWReplyCell *cell   = [tableView dequeueReusableCellWithIdentifier:replyCellIdentifier
                                                                      forIndexPath:indexPath];
    self.indexPath      = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate       = self;
    
    [self.viewModel setupModelOfCell:cell
                               model:self.tieZiReplyArr[indexPath.row]];
    
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
    
    return [tableView fd_heightForCellWithIdentifier:replyCellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(id cell) {
                                           
                                           [self.viewModel setupModelOfCell:cell
                                                                      model:self.tieZiReplyArr[indexPath.row]];
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
    
    
    MyWebViewController *webVc = [[MyWebViewController alloc] initWithURL:url];
    
    [self.navigationController pushViewController:webVc animated:YES];
}

#pragma mark YWDetailTabeleViewDelegate

- (void)didSelectCommentView:(YWCommentView *)commentView {
    
    [self.view addSubview:self.commentView];
    //评论的评论
    self.commentType                               = CommentedModel;
    
    self.selectCommentView                         = commentView;
    
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
                             
                             self.tableView.frame = CGRectMake(0,
                                                                     -(commentViewFrame.origin.y-self.commentView.frame.origin.y),
                                                                     SCREEN_WIDTH,
                                                                     SCREEN_HEIGHT);
                             
                         }];
        
    }
    
    
}

- (void)didSelectCommentViewLeftNameWithUserId:(int)userId {
    
    [self jumpToTaPageWithUserId:userId];
    
}

#pragma mark - GalleryView Delegate

- (void)galleryView:(YWGalleryView *)galleryView removePageAtIndex:(NSInteger)pageIndex {
    galleryView = nil;
}

#pragma YWSpringButtonDelegate

- (void)didSelectReplySpringButtonOnView:(UIView *)view replyId:(int)replyId model:(int)model {
    
    //点赞数量的改变，这里要注意的是，无论是否可以网络请求，本地数据都要显示改变
    UILabel *favour = [view viewWithTag:ReplyFavorSpringButtonTag];
    
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
    
    [self.view addSubview:self.commentView];
    
    self.commentType                        = TieZiCommentModel;
    
    self.commetparameter[@"post_reply_id"] = @(post_id);
    
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

#pragma mark YWLabelDelegate

- (void)didSelectLabel:(YWTitle *)label {
    
    
    TopicController *topicVc = [[TopicController alloc] initWithTopicId:label.topic_id];
    
    [self.navigationController pushViewController:topicVc animated:YES];
    
}

#pragma mark YWMasterDelegate
-(void)didSelectMaster:(YWDetailMasterView *)masterView {
    
    
    [self jumpToTaPageWithUserId:masterView.user_id];
    
}

#pragma mark private method

- (void)commentOnReplyView:(UIView *)view {
    
    [self.view addSubview:self.commentView];
    
    self.commentType                        = TieZiCommentModel;
    
    self.commetparameter[@"post_reply_id"] = @(self.model.post_id);
    
    [self.commentView.messageTextView becomeFirstResponder];
}

/**
 *  贴子评论、评论的评论
 */
- (void)commentTieZi {
    
    [SVProgressHUD showLoadingStatusWith:@""];
    
    WeakSelf(self);
    [self.viewModel setCommentReplySuccessBlock:^(StatusEntity *status) {
        
        if (status.status == YES) {
            [weakself hiddenKeyboard];
            [weakself addCommentOnReplyTieZi];
        }
        
    } failure:^(id commentReplyFailureBlock) {
        
    }];
    
    self.commetparameter[@"content"] = self.commentView.messageTextView.text;
    
    RequestEntity *request           = [[RequestEntity alloc] init];
    request.URLString                = TIEZI_COMMENT_URL;
    request.parameter                = self.commetparameter;
    
    [self.viewModel postCommentWithRequest:request];
    
    
}


/**
 *  页面上添加评论
 */
- (void)addCommentOnReplyTieZi {
    
    TieZiReply *replyEntity = [self.tieZiReplyArr objectAtIndex:self.indexPath.row];
    
    WeakSelf(self);

    [SVProgressHUD showSuccessStatus:@"评论成功" afterDelay:HUD_DELAY];
    
    [self.viewModel setCommentListSuccessBlock:^(NSArray *commentArr) {
        
        replyEntity.commentArr = [commentArr mutableCopy];
        //替换新的评论
        [weakself.tieZiReplyArr replaceObjectAtIndex:weakself.indexPath.row
                                          withObject:replyEntity];
        //更新cell，更新评论
        [weakself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:weakself.indexPath,nil]
                                  withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(id commentListFailureBlock) {
        
    }];
    
    RequestEntity *request           = [[RequestEntity alloc] init];
    request.URLString                = TIEZI_COMMENT_LIST_URL;
    request.parameter                = @{@"post_reply_id":@(self.model.reply_id)};
    
    [weakself.viewModel requestCommentWithRequest:request];
    
}


- (void)jumpToTaPageWithUserId:(int)userId {
    
    TAController *taVc = [[TAController alloc] initWithUserId:userId];
    [self.navigationController pushViewController:taVc animated:YES];
}


#pragma mark 收起键盘
- (void)hiddenKeyboard {
    
    self.commetparameter      = nil;
    self.selectCommentView     = nil;
    self.tableView.frame = self.view.bounds;
    
    [self.commentView.messageTextView resignFirstResponder];
    [self.replyView.messageField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
