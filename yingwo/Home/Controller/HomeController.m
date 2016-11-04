//
//  HomeController.m
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "HomeController.h"
#import "DetailController.h"
#import "TopicController.h"
#import "TAController.h"
#import "YWTabBarController.h"

#import "TieZi.h"
#import "TieZiViewModel.h"
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

@interface HomeController ()<UITableViewDataSource,UITableViewDelegate,YWDropDownViewDelegate,YWHomeCellMiddleViewBaseProtocol,GalleryViewDelegate,YWAlertButtonProtocol,YWSpringButtonDelegate,YWLabelDelegate, YWHomeCellBottomViewDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIBarButtonItem   *rightBarItem;
@property (nonatomic, strong) UIBarButtonItem   *leftBarItem;
@property (nonatomic, strong) UIAlertController *alertView;
@property (nonatomic, strong) UIAlertController *compliantAlertView;
@property (nonatomic, strong) TieZi             *model;
@property (nonatomic, strong) TieZiViewModel    *viewModel;

//点击查看话题内容
@property (nonatomic, assign) int               tap_topic_id;
//点击查看用户详情
@property (nonatomic, assign) int               tap_ta_id;

@property (nonatomic, assign) int               badgeCount;

@property (nonatomic, strong) RequestEntity     *requestEntity;

@property (nonatomic, strong) YWDropDownView    *drorDownView;
@property (nonatomic, strong) YWPhotoCotentView *contentView;

@property (nonatomic, strong) NSMutableArray    *tieZiList;
@property (nonatomic,strong ) NSArray           *images;


@property (nonatomic, strong) GalleryView       *galleryView;

//avatarImageView
//保存首页的小图的数组(UIImageView数组)
@property (nonatomic, strong) NSMutableArray    *cellNewImageArr;

@property (nonatomic,assign ) CGFloat           navgationBarHeight;

@end

@implementation HomeController

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
        _requestEntity.requestUrl = HOME_URL;
        //请求的事新鲜事
        _requestEntity.filter     = AllThingModel;
        //偏移量开始为0
        _requestEntity.start_id   = start_id;
    }
    return _requestEntity;
}

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"screen"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(showDropDownView:)];
    }
    return _leftBarItem;
}

- (UIBarButtonItem *)rightBarItem {
    if (_rightBarItem == nil) {
        _rightBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"magni"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:nil];
    }
    return _rightBarItem;
}

- (YWDropDownView *)drorDownView {
    if (_drorDownView == nil) {
        
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:4];
        [titles addObject:@"全部"];
        [titles addObject:@"新鲜事"];
        [titles addObject:@"关注的话题"];
//        [titles addObject:@"好友动态"];
        
//        _drorDownView          = [[YWDropDownView alloc] initWithTitlesArr:titles
//                                                                    height:120
//                                                                     width:100];
        
        _drorDownView          = [[YWDropDownView alloc] initWithTitlesArr:titles
                                                                    height:90
                                                                     width:100];
        _drorDownView.delegate = self;
    }
    return _drorDownView;
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

#pragma mark button action

- (void)showDropDownView:(UIBarButtonItem *)sender {
    
    if (self.drorDownView.isPopDropDownView == NO) {
        
        [self.drorDownView showDropDownView];
        self.drorDownView.isPopDropDownView = YES;
        
    }else {
        
        [self.drorDownView hideDropDownView];
        self.drorDownView.isPopDropDownView = NO;
        
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
 *  删除警告
 */
- (void)showDeleteAlertView:(UIButton *)more {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告"
                                                                             message:@"确认删除？"
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
    UIPasteboard *pasteboard              = [UIPasteboard generalPasteboard];
    //复制内容 获取帖子文字内容
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)more.superview.superview.superview.superview;
    NSString *copyString                  = selectedCell.contentText.text;
    //复制到剪切板
    pasteboard.string                     = copyString;
    
    [SVProgressHUD showSuccessStatus:@"已复制" afterDelay:HUD_DELAY];

}



- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self.tabBar selectTabAtIndex:self.index];
    
    NSLog(@"%@",NSHomeDirectory());
    
    __weak HomeController *weakSelf = self;
    self.homeTableview.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //偏移量开始为0
        self.requestEntity.start_id  = start_id;

        [weakSelf loadDataWithRequestEntity:self.requestEntity];
    }];

    self.homeTableview.mj_footer    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];
    
    self.homeTableview.mj_footer.ignoredScrollViewContentInsetBottom = -65;
    
    //进入app不刷新
//    [self.homeTableview.mj_header beginRefreshing];
    
    [self.view addSubview:self.homeTableview];
    
    //下拉列表
    [self.navigationController.view addSubview:self.drorDownView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"南京工业大学";
    self.navigationItem.leftBarButtonItem  = self.leftBarItem;
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    
    //导航栏＋状态栏高度
    [self judgeNetworkStatus];
    
    [self stopSystemPopGestureRecognizer];
    
    [self showTabBar:YES animated:YES];
}

//跳转到完善信息
- (void)jumpToPerfectInfoPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_PERFECTINFO sender:self];
}

#pragma mark 禁止pop手势
- (void)stopSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = YES;
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
    
    [self requestNewTieziCount];
    [self loadForType:1 RequestEntity:requestEntity];
    
    [self.homeTableview.mj_footer resetNoMoreData];
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
    [[self.viewModel.fecthTieZiEntityCommand execute:requestEntity] subscribeNext:^(NSArray *tieZis) {
        @strongify(self);
        
        //这里是倒序获取前10个
        if (tieZis.count > 0) {
            
            if (type == 1) {
                //   NSLog(@"tiezi:%@",tieZis);
                self.tieZiList = [tieZis mutableCopy];
                [self.homeTableview.mj_header endRefreshing];
                [self.homeTableview reloadData];
                
                //刷新后清除小红点
                [self.tabBar.homeBtn clearBadge];
                //显示新帖子View
                [self showNewTieziCount:self.badgeCount];

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
                //显示新帖子View
                [self showNewTieziCount:self.badgeCount];

            }
            
            [self.homeTableview.mj_footer endRefreshingWithNoMoreData];
        }
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

//获取新帖子数
- (void)requestNewTieziCount {
    NSDictionary *paramaters;
    [self.viewModel requestForBadgeWithUrl:HOME_INDEX_CNT_URL
                                paramaters:paramaters
                                   success:^(int badgeCount) {
                                       self.badgeCount = badgeCount;
                         }
                         failure:^(NSString *error) {
                             NSLog(@"error:%@",error);
                         }];
    
}

//显示新帖子View
- (void)showNewTieziCount:(int)count{
    
    UILabel *newTieziLabel = [[UILabel alloc] init];
    newTieziLabel.font = [UIFont systemFontOfSize:12];
    
    if (count > 0) {
        if(count > 35) {
            newTieziLabel.text = @"超过35条新的帖子";
        } else {
            newTieziLabel.text = [NSString stringWithFormat:@"%d条新的帖子", count];
        }
    } else {
        newTieziLabel.text = @"没有新的帖子";
    }
    
    newTieziLabel.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_1 alpha:0.6];
    newTieziLabel.textAlignment   = NSTextAlignmentCenter;
    newTieziLabel.textColor       = [UIColor whiteColor];
    
    newTieziLabel.width           = self.view.width;
    newTieziLabel.height          = 35;
    newTieziLabel.x               = 0;
    newTieziLabel.y               = CGRectGetMaxY([self.navigationController navigationBar].frame) - newTieziLabel.height;
    
    //添加到导航栏控制器的view
    [self.navigationController.view insertSubview:newTieziLabel belowSubview:self.navigationController.navigationBar];
    
    //动画
    CGFloat duration = 2.0;
    [UIView animateWithDuration:duration
                     animations:^{
                         newTieziLabel.transform = CGAffineTransformMakeTranslation(0, newTieziLabel.height);
                     }
                     completion:^(BOOL finished) {
                         
                         CGFloat delay = 1.0;
                         [UIView animateWithDuration:delay
                                          animations:^{
                                              newTieziLabel.transform = CGAffineTransformIdentity;
                                          }
                                          completion:^(BOOL finished) {
                                              //移除控件
                                              [newTieziLabel removeFromSuperview];
                                          }];
                         
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
    cell.contentText.delegate       = self;
    cell.bottemView.more.delegate   = self;
    cell.bottemView.favour.delegate = self;
    cell.bottemView.delegate        = self;
    
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

#pragma mark -- UIScrollViewDelegate

//tabar隐藏滑动距离设置
//滑动100pt后隐藏TabBar
CGFloat scrollHiddenSpace = 5;
CGFloat lastPosition = -4;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.homeTableview) {
        
        CGFloat currentPosition = scrollView.contentOffset.y;
        if (currentPosition > -400 && currentPosition < 0) {
            
            [self showTabBar:YES animated:YES];
            
        }else if ( currentPosition - lastPosition > scrollHiddenSpace ) {
            
            lastPosition = currentPosition;
            [self hidesTabBar:YES animated:YES];
            
        }else if(lastPosition - currentPosition > scrollHiddenSpace){
            
            lastPosition = currentPosition;
            [self showTabBar:YES animated:YES];
            
        }
    }

}


#pragma mark ---- DropDownViewDelegate
- (void)seletedDropDownViewAtIndex:(NSInteger)index {
    self.requestEntity.filter = (int)index;
    [self.homeTableview.mj_header beginRefreshing];
}

- (void)hidesTabBar:(BOOL)yesOrNo animated:(BOOL)animated {
    
    //动画隐藏
    if (animated == yesOrNo) {
        if (yesOrNo == YES) {
            
            [UIView animateWithDuration:0.3 animations:^{
                self.tabBar.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT);
            }];
            
        }
    }else {
        if (yesOrNo == YES)
        {
            self.tabBar.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT);

        }

    }
}

- (void)showTabBar:(BOOL)yesOrNo animated:(BOOL)animated {
    
    //动画隐藏
    if (animated == yesOrNo) {
        if (yesOrNo == YES) {

            [UIView animateWithDuration:0.3 animations:^{
                
                self.tabBar.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT-self.tabBar.height*2+4);
            }];
            
        }
    }else {
        if (yesOrNo == YES)
        {
            self.tabBar.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT-self.tabBar.height*2+4);

        }
        
    }

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

    }else if ([segue.destinationViewController isKindOfClass:[TAController class]])
    {
        if ([segue.identifier isEqualToString:@"ta"]) {
            TAController *taVc = segue.destinationViewController;
            taVc.ta_id         = self.tap_ta_id;
        }
    }
}

#pragma mark AvatarImageView

- (void)showImage:(UIImageView *)avatarImageView WithImageViewArr:(NSArray *)imageViewArr{
    
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
}

- (void)requestForImageByImageUrls:(NSArray *)imageUrls
                     showImageView:(UIImageView *)showImageView
                       oldImageArr:(NSMutableArray *)oldImageArr{
}


#pragma mark YWLabelDelegate

- (void)didSelectLabel:(YWLabel *)label {
 
    
        self.tap_topic_id = label.topic_id;
        
        [self performSegueWithIdentifier:@"topic" sender:self];

    
}

//富文本
#pragma mark TTTAttributedLabelDelegate
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    
    YWWebViewController *webVc = [[YWWebViewController alloc] initWithURL:url];
    
    [self.navigationController pushViewController:webVc animated:YES];
    
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

#pragma mark YWHomeCellBottomViewDelegate
- (void)didSelecteMessageWithBtn:(UIButton *)message {
    
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)message.superview.superview.superview.superview;
    NSIndexPath *indexPath                = [self.homeTableview indexPathForCell:selectedCell];
    self.model                            = self.tieZiList[indexPath.row];
    
    [self performSegueWithIdentifier:@"detail" sender:self];

}

- (void)didSelectHomeBottomView:(YWHomeCellBottomView *)bottomView {
    
    self.tap_ta_id = bottomView.user_id;
    [self performSegueWithIdentifier:@"ta" sender:self];
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

//- (void)didSelectedAvatarImageViewOfMiddleView:(UIImageView *)imageView imageArr:(NSMutableArray *)imageArr {
//
//    if (imageView.image == nil) {
//        return;
//    }
//
//    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)imageView.superview.superview.superview.superview;
//    NSIndexPath *indexPath                = [self.homeTableview indexPathForCell:selectedCell];
//    TieZi *selectedModel                  = self.tieZiList[indexPath.row];
//
//    [self.cellNewImageArr removeAllObjects];
//
//    [self requestForImageByImageUrls:selectedModel.imageUrlArrEntity showImageView:imageView oldImageArr:imageArr];
//
//
//
//}

#pragma mark avatarImageView 下面全是点击图片方法过程的方法函数
/**
 *  坐标转换
 *
 *  @param imageArr    旧数组存放的是UImageView
 *  @param newImageArr 新数组存放的是UImage
 */
//- (void)covertRectForOldImageArr:(NSArray *)imageArr FromNewImageArr:(NSMutableArray *)newImageArr{
//
//    for (int i = 0; i < imageArr.count; i ++) {
//
//        //保存imageView在cell上的位置
//        UIImageView *oldImageView = [imageArr objectAtIndex:i];
//
//        //oldImageView有可能是空的，只是个占位imageView
//        if (oldImageView.image == nil) {
//            return;
//        }
//        UIImageView *newImageView = [[UIImageView alloc] init];
//        UIImage *newImage         = [newImageArr objectAtIndex:i];
//        newImageView.image        = newImage;
//        newImageView.tag          = oldImageView.tag;
//        newImageView.frame        = [oldImageView.superview convertRect:oldImageView.frame toView:self.view];
//        newImageView.y            += self.navgationBarHeight;
//        [self.cellNewImageArr addObject:newImageView];
//
//    }
//}
//

//- (void)requestForImageByImageUrls:(NSArray *)imageUrls
//                     showImageView:(UIImageView *)showImageView
//                       oldImageArr:(NSMutableArray *)oldImageArr{
//
//    MBProgressHUD *hud =  [MBProgressHUD showProgressViewToView:self.view animated:YES];
//
//    [self.viewModel downloadCompletedImageViewByUrls:imageUrls progress:^(CGFloat progress) {
//
//        //进度显示
//        hud.progress = progress;
//
//        //下载完成
//        if (hud.progress == 1.0) {
//            [hud hide:YES];
//        }
//
//    } success:^(NSMutableArray *imageArr) {
//
//        [self covertRectForOldImageArr:oldImageArr FromNewImageArr:imageArr];
//        [self showImage:self.cellNewImageArr[showImageView.tag-1] WithImageViewArr:self.cellNewImageArr];
//
//    } failure:^(NSString *failure) {
//        //图片下载失败
//        [hud hide:YES];
//        [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"图片加载失败" animated:YES afterDelay:2];
//    }];
//}


/*
 **
 *  坐标转换
 *
 *  @param imageArr 图片数组
 *
- (void)covertRectForImageArr:(NSMutableArray *)imageArr {
    
    for (int i = 0; i < imageArr.count; i ++) {
        
        //保存imageView在cell上的位置
        UIImageView *oldImageView = [imageArr objectAtIndex:i];
        
        if (oldImageView.image == nil) {
            return;
        }
        
        UIImageView *newImageView           = [[UIImageView alloc] init];
        newImageView.image                  = oldImageView.image;
        newImageView.tag                    = oldImageView.tag;
        newImageView.frame                  = [oldImageView.superview convertRect:oldImageView.frame toView:self.view];
        
        [self.cellNewImageArr addObject:newImageView];
        
        //        NSLog(@"%d:newframe.x%f",i,newImageView.frame.origin.x);
        //        NSLog(@"%d:newframe.y%f",i,newImageView.frame.origin.y);
        //        NSLog(@"%d:oldframe.x%f",i,oldImageView.frame.origin.x);
        //        NSLog(@"%d:oldframe.y%f",i,oldImageView.frame.origin.y);
        
    }
}
 
 static NSInteger avatarImageViewOldTag;
 *
 *  图片展示
 *
 *  @param avatarImageView 选中的图图片
 *  @param imageArr        同一个帖子中所有的图片
 */
/*
 - (void)showImage:(UIImageView *)avatarImageView WithImageViewArr:(NSArray *)imageArr{
 
 //avatarImageViewTag tag从1开始的，所以这里要减1，从0开始计算
 avatarImageViewOldTag        = avatarImageView.tag;
 self.avatarPage              = (int)avatarImageView.tag;
 NSInteger avatarImageViewTag = avatarImageView.tag - 1;
 
 [self.avatarImageArr removeAllObjects];
 
 //页数
 _avatarPageLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
 _avatarPageLabel.center          = CGPointMake(self.view.center.x, 30);
 _avatarPageLabel.textColor       = [UIColor whiteColor];
 _avatarPageLabel.textAlignment   = NSTextAlignmentCenter;
 _avatarPageLabel.text            = [NSString stringWithFormat:@"%d/%d",(int)avatarImageViewOldTag,(int)imageArr.count];
 
 //背景滑动
 _avatarSrcllView                 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
 _avatarSrcllView.pagingEnabled   = YES;
 //_avatarSrcllView 的初始位置
 _avatarSrcllView.contentSize     = CGSizeMake(imageArr.count*SCREEN_WIDTH, SCREEN_HEIGHT);
 _avatarSrcllView.contentOffset   = CGPointMake(SCREEN_WIDTH*avatarImageViewTag, _avatarSrcllView.contentOffset.y);
 _avatarSrcllView.backgroundColor = [UIColor blackColor] ;
 _avatarSrcllView.alpha           = 1;
 _avatarSrcllView.delegate        = self;
 
 //   UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*avatarImageViewTag, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
 
 UIImageView *oldImageView = [self.cellOldImageArr objectAtIndex:avatarImageViewTag];
 //创建新的ImageView代替点击的avatarImageView,这里一定要设置好初始位置！！！
 //由于控制器含有UINavigationController，需要加上导航栏和状态栏的高度navgationBarHeight
 UIImageView *avatarNewImageView           = [[UIImageView alloc] initWithFrame:CGRectMake(avatarImageView.x+SCREEN_WIDTH*avatarImageViewTag, avatarImageView.y+self.navgationBarHeight, oldImageView.width, oldImageView.height)];
 avatarNewImageView.image                  = avatarImageView.image;
 avatarNewImageView.tag                    = avatarImageViewOldTag;
 avatarNewImageView.userInteractionEnabled = YES;
 avatarNewImageView.clipsToBounds          = YES;
 //添加缩放手势
 [self addGestureToImageView:avatarNewImageView];
 
 [_avatarSrcllView addSubview:avatarNewImageView];
 [self.navigationController.view addSubview:_avatarSrcllView];
 [self.navigationController.view addSubview:_avatarPageLabel];
 
 //点击后的缩放动画
 POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
 anim.toValue             = [NSValue valueWithCGRect:CGRectMake((SCREEN_WIDTH - avatarImageView.width)/2+SCREEN_WIDTH*avatarImageViewTag,(SCREEN_HEIGHT-avatarImageView.height)/2, avatarImageView.width, avatarImageView.height)];
 
 anim.springBounciness    = 8;
 anim.springSpeed         = 12;
 [avatarNewImageView pop_addAnimation:anim forKey:@"Center"];
 anim.completionBlock = ^(POPAnimation *anim, BOOL finished)  {
 
 if (finished) {
 
 for (int i = 0; i < imageArr.count; i++) {
 
 //这个位置已经被avatarImageView占有
 if (i == avatarImageViewTag) {
 
 //这个saveImageView，只用来记录avatarScrllView上的图片的大小，不显示
 UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:avatarNewImageView.frame];
 [self.avatarImageArr addObject:saveImageView];
 
 continue;
 }
 
 UIImageView *newimageView        = [imageArr objectAtIndex:i];
 UIImageView *imageView           = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, newimageView.width, newimageView.height)];
 
 imageView.image                  = newimageView.image;
 imageView.tag                    = i + 1;
 imageView.center                 = CGPointMake((SCREEN_WIDTH/2 + SCREEN_WIDTH*i), SCREEN_HEIGHT/2);
 imageView.userInteractionEnabled = YES;
 imageView.clipsToBounds          = YES;
 //添加缩放手势
 [self addGestureToImageView:imageView];
 [_avatarSrcllView addSubview:imageView];
 
 //这个saveImageView，只用来记录avatarScrllView上的图片的大小，不显示
 UIImageView *saveImageView = [[UIImageView alloc] initWithFrame:imageView.frame];
 [self.avatarImageArr addObject:saveImageView];
 
 }
 }
 
 };
 
 UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
 [_avatarSrcllView addGestureRecognizer: tap];
 }
 

 *  隐藏图片
 *
 *  @param tap 手势

- (void)hideImage:(UITapGestureRecognizer*)tap{
    
    //_avatarPageLabel 不能使用clearColor，否则消失不同步，只能选择移除
    [_avatarPageLabel removeFromSuperview];
    _avatarSrcllView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView           = [self.avatarSrcllView viewWithTag:self.avatarPage];
    UIImageView *newImageView        = self.cellNewImageArr[self.avatarPage-1];
    UIImageView *oldImageView        = self.cellOldImageArr[self.avatarPage-1];
    
    POPSpringAnimation *anim         = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    anim.toValue                     = [NSValue valueWithCGRect:CGRectMake(SCREEN_WIDTH * (self.avatarPage -1)+newImageView.x, newImageView.y+self.navgationBarHeight, oldImageView.width, oldImageView.height)];
    anim.springBounciness            = 8;
    anim.springSpeed                 = 12;
    
    [imageView pop_addAnimation:anim forKey:@"AnimationHide"];
    
    anim.completionBlock = ^(POPAnimation *anim, BOOL finished){
        if (finished) {
            
            [_avatarSrcllView removeFromSuperview];
            
        }
    };
}

 */

@end
