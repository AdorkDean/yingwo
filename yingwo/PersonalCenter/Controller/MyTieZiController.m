//
//  MyTieZiController.m
//  yingwo
//
//  Created by apple on 16/10/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyTieZiController.h"
#import "DetailController.h"
#import "TopicController.h"

#import "TieZi.h"
#import "YWDropDownView.h"
#import "YWPhotoCotentView.h"

#import "YWHomeTableViewCellNoImage.h"
#import "YWHomeTableViewCellOneImage.h"
#import "YWHomeTableViewCellTwoImage.h"
#import "YWHomeTableViewCellThreeImage.h"
#import "YWHomeTableViewCellFourImage.h"
#import "YWHomeTableViewCellSixImage.h"
#import "YWHomeTableViewCellNineImage.h"
#import "YWHomeTableViewCellMoreNineImage.h"
@protocol  YWHomeCellMiddleViewBaseProtocol;

//刷新的初始值
static int start_id = 0;

@interface MyTieZiController ()<UITableViewDataSource,UITableViewDelegate,YWHomeCellMiddleViewBaseProtocol,GalleryViewDelegate,YWAlertButtonProtocol,YWSpringButtonDelegate,YWLabelDelegate, YWHomeCellBottomViewDelegate,TTTAttributedLabelDelegate>

@property (nonatomic, strong) UITableView       *homeTableview;
@property (nonatomic, strong) UIAlertController *alertView;
@property (nonatomic, strong) TieZi             *model;

//点击查看话题内容
@property (nonatomic, assign) int               tap_topic_id;

@property (nonatomic, strong) RequestEntity     *requestEntity;

@property (nonatomic, strong) YWPhotoCotentView *contentView;

@property (nonatomic, strong) NSMutableArray    *tieZiList;
@property (nonatomic,strong ) NSArray           *images;

@property (nonatomic, strong) UIAlertController *compliantAlertView;

@property (nonatomic, strong) GalleryView       *galleryView;

//avatarImageView
//保存首页的小图的数组(UIImageView数组)
@property (nonatomic, strong) NSMutableArray    *cellNewImageArr;

@property (nonatomic,assign ) CGFloat           navgationBarHeight;

@end

@implementation MyTieZiController

/**
 *  cell identifier
 */
static NSString *YWHomeCellNoImageIdentifier       = @"noImageCell";
static NSString *YWHomeCellOneImageIdentifier      = @"oneImageCell";
static NSString *YWHomeCellTwoImageIdentifier      = @"twoImageCell";
static NSString *YWHomeCellThreeImageIdentifier    = @"threeImageCell";
static NSString *YWHomeCellFourImageIdentifier     = @"fourImageCell";
static NSString *YWHomeCellSixImageIdentifier      = @"sixImageCell";
static NSString *YWHomeCellNineImageIdentifier     = @"nineImageCell";
static NSString *YWHomeCellMoreNineImageIdentifier = @"moreNineImageCell";


#pragma mark 懒加载

- (UITableView *)homeTableview {
    if (_homeTableview == nil) {
        _homeTableview                 = [[UITableView alloc] initWithFrame:self.view.bounds
                                                                      style:UITableViewStyleGrouped];
        _homeTableview.delegate        = self;
        _homeTableview.dataSource      = self;
        _homeTableview.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _homeTableview.backgroundColor = [UIColor clearColor];
        _homeTableview.sectionFooterHeight = 50;
        //  _homeTableview.fd_debugLogEnabled = YES;
        
        [_homeTableview registerClass:[YWHomeTableViewCellNoImage class]
               forCellReuseIdentifier:YWHomeCellNoImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellOneImage class]
               forCellReuseIdentifier:YWHomeCellOneImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellTwoImage class]
               forCellReuseIdentifier:YWHomeCellTwoImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellThreeImage class]
               forCellReuseIdentifier:YWHomeCellThreeImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellFourImage class]
               forCellReuseIdentifier:YWHomeCellFourImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellSixImage class]
               forCellReuseIdentifier:YWHomeCellSixImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellNineImage class]
               forCellReuseIdentifier:YWHomeCellNineImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellMoreNineImage class]
               forCellReuseIdentifier:YWHomeCellMoreNineImageIdentifier];
        
    }
    return _homeTableview;
}

- (TieZi *)model {
    if (_model == nil) {
        
        _model = [[TieZi alloc] init];
    }
    return _model;
}

- (TieZiViewModel *)viewModel {
    if (_viewModel == nil) {
        
        _viewModel = [[TieZiViewModel alloc] init];
        
    }
    return _viewModel;
}

- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.requestUrl = MY_TIEZI_URL;
        //请求的事新鲜事
        _requestEntity.topic_id   = AllThingModel;
        //偏移量开始为0
        _requestEntity.start_id  = start_id;
    }
    return _requestEntity;
}

- (NSMutableArray *)tieZiList {
    if (_tieZiList == nil) {
        _tieZiList = [[NSMutableArray alloc] init];
    }
    return _tieZiList;
}

- (NSMutableArray *)cellNewImageArr {
    if (_cellNewImageArr == nil) {
        _cellNewImageArr = [[NSMutableArray alloc] init];
    }
    return _cellNewImageArr;
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


- (GalleryView *)galleryView {
    if (_galleryView == nil) {
        _galleryView                 = [[GalleryView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _galleryView.backgroundColor = [UIColor blackColor];
        _galleryView.delegate        = self;
    }
    return _galleryView;
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
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    alertController.view.tintColor = [UIColor blackColor];
    
    [self.view.window.rootViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];

}

/**
 *  删除帖子
 */
- (void)deleteTieZi:(UIButton *)more {
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)more.superview.superview.superview.superview;
    NSIndexPath *indexPath                = [self.homeTableview indexPathForCell:selectedCell];
    TieZi *selectedModel                  = self.tieZiList[indexPath.row];

    int postId = selectedModel.tieZi_id;
    //网络请求
    NSDictionary *paramaters = @{@"post_id":@(postId)};
    
    //必须要加载cookie，否则无法请求
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [self.viewModel deleteTieZiWithUrl:TIEZI_DEL_URL
                            paramaters:paramaters
                               success:^(StatusEntity *statusEntity) {
                                   
                                   if (statusEntity.status == YES) {
                                       //删除该行数据源
                                       [self.tieZiList removeObjectAtIndex:indexPath.row];
                                       //将该行从视图中移除
                                       [self.homeTableview deleteRowsAtIndexPaths:@[indexPath]
                                                                 withRowAnimation:UITableViewRowAnimationFade];
                                       [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:1.0];
                                   }else if (statusEntity.status == NO){
                                       [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:1.0];
                                   }
                                   
                               } failure:^(NSString *error) {
                                   NSLog(@"error:%@",error);
                               }];
    
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
    
    [SVProgressHUD showSuccessStatus:@"已复制" afterDelay:HUD_DELAY];

}



#pragma mark button action

/**
 *  举报弹出框
 */
- (void)showCompliantAlertView {
    [self.view.window.rootViewController presentViewController:self.compliantAlertView
                                                      animated:YES
                                                    completion:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSLog(@"%@",NSHomeDirectory());
    
    __weak MyTieZiController *weakSelf = self;
    self.homeTableview.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //偏移量开始为0
        self.requestEntity.start_id  = start_id;
        
        [weakSelf loadDataWithRequestEntity:self.requestEntity];
    }];
    
    self.homeTableview.mj_footer    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];
    
    self.homeTableview.mj_footer.ignoredScrollViewContentInsetBottom = -65;
    
    
    [self.homeTableview.mj_header beginRefreshing];
    
    [self.view addSubview:self.homeTableview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    Customer *user = [User findCustomer];
    if (self.viewModel.user_id != [user.userId intValue]) {
        self.title = @"TA的贴子";
    }else {
        self.title = @"我的贴子";
    }

    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(backToPersonCenterView)];
    
    //导航栏＋状态栏高度
    [self judgeNetworkStatus];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

#pragma mark 禁止pop手势
- (void)stopSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = YES;
}


#pragma mark 开启pop手势
- (void)openSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = NO;
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

#pragma YWSpringButtonDelegate

- (void)didSelectSpringButtonOnView:(UIView *)view postId:(int)postId model:(int)model {
    
    
    //点赞数量的改变，这里要注意的是，无论是否可以网络请求，本地数据都要显示改变
    UILabel *favour = [view viewWithTag:101];
    __block int count       = [favour.text intValue];
    
    //网络请求
    NSDictionary *paramaters = @{@"post_id":@(postId),@"value":@(model)};
    
    [self.viewModel postTieZiLIkeWithUrl:TIEZI_LIKE_URL
                              paramaters:paramaters
                                 success:^(StatusEntity *statusEntity) {
                                     
                                     if (statusEntity.status == YES) {
                                         
                                         if (model == YES) {
                                             count ++;
                                             [self.viewModel saveLikeCookieWithPostId:[NSNumber numberWithInt:postId]];
                                         }
                                         else
                                         {
                                             count --;
                                             [self.viewModel deleteLikeCookieWithPostId:[NSNumber numberWithInt:postId]];
                                         }
                                         if (count >= 0) {
                                             favour.text = [NSString stringWithFormat:@"%d",count];
                                         }else {
                                             favour.text = [NSString stringWithFormat:@"%d",0];
                                         }

                                     }
                                     
                                 } failure:^(NSString *error) {
                                     
                                 }];
    
}

/**
 *  下拉刷新
 */
- (void)loadDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    //网络连接错误的情况下停止刷新
    if ([YWNetworkTools networkStauts] == NO) {
        [self.homeTableview.mj_header endRefreshing];
    }

    [self loadForType:1 RequestEntity:requestEntity];
    
    [self.homeTableview.mj_footer resetNoMoreData];
}

/**
 *  上拉刷新
 */
- (void)loadMoreDataWithRequestEntity:(RequestEntity *)requestEntity {
    //网络连接错误的情况下停止刷新
    if ([YWNetworkTools networkStauts] == NO) {
        [self.homeTableview.mj_footer endRefreshing];
    }
    
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
    [[self.viewModel.fecthTieZiEntityCommand execute:requestEntity] subscribeNext:^(NSArray *tieZis) {
        @strongify(self);
        
        //这里是倒序获取前10个
        if (tieZis.count > 0) {
            
            if (type == 1) {
                //   NSLog(@"tiezi:%@",tieZis);
                self.tieZiList = [tieZis mutableCopy];
                [self.homeTableview.mj_header endRefreshing];
                [self.homeTableview reloadData];
            }else {
                
                [self.tieZiList addObjectsFromArray:tieZis];
                [self.homeTableview.mj_footer endRefreshing];
                [self.homeTableview reloadData];
            }
            
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            TieZi *lastObject           = [tieZis objectAtIndex:tieZis.count-1];
            self.requestEntity.start_id = lastObject.tieZi_id;
            
        }
        else
        {
            //没有任何数据
            if (tieZis.count == 0 && requestEntity.start_id == 0) {
                
                self.tieZiList = nil;
                [self.homeTableview.mj_header endRefreshing];
                [self.homeTableview reloadData];
                
            }
            
            [self.homeTableview.mj_footer endRefreshingWithNoMoreData];
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

#pragma mark UITableViewDataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tieZiList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.model                      = [self.tieZiList objectAtIndex:indexPath.row];
    NSString *cellIdentifier        = [self.viewModel idForRowByModel:self.model];
    YWHomeTableViewCellBase *cell   = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                      forIndexPath:indexPath];
    cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    
    cell.labelView.title.delegate   = self;
    cell.middleView.delegate        = self;
    cell.bottemView.more.delegate   = self;
    cell.bottemView.favour.delegate = self;
    cell.bottemView.delegate        = self;
    cell.contentText.delegate       = self;
    
    [self.viewModel setupModelOfCell:cell model:self.model];
    
    return cell;
}

#pragma mark UITableViewDelegate 自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.model               = [self.tieZiList objectAtIndex:indexPath.row];
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.model];
    
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(id cell) {
                                           
                                           [self.viewModel setupModelOfCell:cell
                                                                      model:self.model];
                                       }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.model = [self.tieZiList objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"detail" sender:self];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //查看贴子详情
    if ([segue.destinationViewController isKindOfClass:[DetailController class]])
    {
        
        if ([segue.identifier isEqualToString:@"detail"]) {
            DetailController *detailVc = segue.destinationViewController;
            detailVc.model             = self.model;
        }
    }
    
    //查看所有话题
    else if ([segue.destinationViewController isKindOfClass:[TopicController class]])
    {
        if ([segue.identifier isEqualToString:@"topic"]) {
            TopicController *topicVc = segue.destinationViewController;
            topicVc.topic_id         = self.tap_topic_id;
            
        }
        
    }
}

#pragma mark YWHomeCellBottomViewDelegate
- (void)didSelecteMessageWithBtn:(UIButton *)message {
    
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)message.superview.superview.superview.superview;
    NSIndexPath *indexPath                = [self.homeTableview indexPathForCell:selectedCell];
    self.model                            = self.tieZiList[indexPath.row];
    
    //点击跳转到详情里面
    [self performSegueWithIdentifier:@"detail" sender:self];
}

#pragma mark AvatarImageView

- (void)showImage:(UIImageView *)avatarImageView WithImageViewArr:(NSArray *)imageViewArr{
    
    //禁止后面的MyTieZiController的滑动手势
    //这里不禁止的话，会造成点击看图片，然后左滑动的时候MyTieZiController pop 回PersonalCenterController中
    
    [self stopSystemPopGestureRecognizer];
    
    
    [self.galleryView setImages:self.cellNewImageArr showAtIndex:avatarImageView.tag-1];
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

#pragma mark TTTAttributedLabelDelegate
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    
    YWWebViewController *webVc = [[YWWebViewController alloc] initWithURL:url];
    
    [self.navigationController pushViewController:webVc animated:YES];
}


#pragma mark YWLabelDelegate

- (void)didSelectLabel:(YWLabel *)label {
    
    if (label.topic_id != 0) {
        
        self.tap_topic_id = label.topic_id;
        
        [self performSegueWithIdentifier:@"topic" sender:self];
        
    }
    
}


#define mark - YWHomeCellMiddleViewBaseProtocol

- (void)didSelectedAvatarImageViewOfMiddleView:(UIImageView *)imageView imageArr:(NSMutableArray *)imageViewArr {
    
    if (imageView.image == nil) {
        return;
    }
    
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)imageView.superview.superview.superview.superview;
    NSIndexPath *indexPath                = [self.homeTableview indexPathForCell:selectedCell];
    TieZi *selectedModel                  = self.tieZiList[indexPath.row];
    
    [self.cellNewImageArr removeAllObjects];
    
    [self covertRectFromOldImageViewArr:imageViewArr];
    
    [self.galleryView setImageViews:self.cellNewImageArr
              withImageUrlArrEntity:selectedModel.imageUrlArrEntity
                        showAtIndex:imageView.tag-1];
    
    [self.navigationController.view addSubview:self.galleryView];
    
    
}

- (void)covertRectFromOldImageViewArr:(NSArray *)imageViewArr{
    
    for (int i = 0; i < imageViewArr.count; i ++) {
        
        //保存imageView在cell上的位置
        UIImageView *oldImageView = [imageViewArr objectAtIndex:i];
        
        //oldImageView有可能是空的，只是个占位imageView
        if (oldImageView.image == nil) {
            return;
        }
        UIImageView *newImageView = [[UIImageView alloc] init];
        newImageView.image        = oldImageView.image;
        newImageView.tag          = oldImageView.tag;
        newImageView.frame        = [oldImageView.superview convertRect:oldImageView.frame toView:self.view];
        newImageView.y            += self.navgationBarHeight;
        [self.cellNewImageArr addObject:newImageView];
        
    }
}

#pragma mark private method
- (void)backToPersonCenterView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 网络监测
/**
 *  网路监测
 */
- (void)judgeNetworkStatus {
    [YWNetworkTools networkStauts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
