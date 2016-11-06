//
//  TAController.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TAController.h"
#import "MyTopicController.h"
#import "MyTieZiController.h"

#import "YWTaHeaderView.h"
#import "YWTaTopicView.h"
#import "YWTaTieziView.h"
#import "YWTaFollowView.h"

@interface TAController ()<UIScrollViewDelegate,GalleryViewDelegate>

@property (nonatomic, strong) UIScrollView              *taScrollView;
@property (nonatomic, strong) YWTaHeaderView            *taHeaderView;
@property (nonatomic, strong) YWTaTopicView             *taTopicView;
@property (nonatomic, strong) YWTaTieziView             *taTieziView;
@property (nonatomic, strong) YWTaFollowView            *taFollowView;
@property (nonatomic, strong) GalleryView               *galleryView;
@property (nonatomic, strong) UIView                    *taNavigationBar;

@property (nonatomic, strong) TaViewModel               *viewModel;
@property (nonatomic, strong) TaEntity                  *taEntity;

@property (nonatomic, strong) UIBarButtonItem           *leftBarItem;

@property (nonatomic, assign) CGFloat                   navgationBarHeight;


@end

static CGFloat HeadViewHeight = 250;


@implementation TAController

-(UIScrollView *)taScrollView {
    if (_taScrollView == nil) {
        _taScrollView                                       = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                       -self.navgationBarHeight,
                                                                       SCREEN_WIDTH,
                                                                       SCREEN_HEIGHT + self.navgationBarHeight)];
        _taScrollView.contentSize                           = CGSizeMake(SCREEN_WIDTH,
                                                                         SCREEN_HEIGHT + self.navgationBarHeight);
//        _taScrollView.contentOffset                         = CGPointMake(0, 0);
        _taScrollView.backgroundColor                       = [UIColor clearColor];
        _taScrollView.delegate                              = self;
        _taScrollView.showsVerticalScrollIndicator          = YES;
    }
    return _taScrollView;
}

#define TaHeaderViewFrame CGRectMake(0,0,SCREEN_WIDTH,HeadViewHeight)

-(YWTaHeaderView *)taHeaderView {
    if (_taHeaderView == nil) {
        _taHeaderView                               = [[YWTaHeaderView alloc] initWithFrame:TaHeaderViewFrame];
        _taHeaderView.loopScroll                    = NO;
        _taHeaderView.showPageIndicator             = YES;
    }
    return _taHeaderView;
}

-(YWTaTopicView *)taTopicView {
    if (_taTopicView == nil) {
        _taTopicView                        = [[YWTaTopicView alloc] init];
//        _taTopicView.frame                  = CGRectMake(10, 260, SCREEN_WIDTH - 20, 170);
        _taTopicView.backgroundColor        = [UIColor whiteColor];
        _taTopicView.layer.masksToBounds    = YES;
        _taTopicView.layer.cornerRadius     = 5;
    }
    return _taTopicView;
}

-(YWTaTieziView *)taTieziView {
    if(_taTieziView == nil) {
        _taTieziView                        = [[YWTaTieziView alloc] init];
        _taTieziView.backgroundColor        = [UIColor whiteColor];
        _taTieziView.layer.masksToBounds    = YES;
        _taTieziView.layer.cornerRadius     = 5;
        _taTieziView.viewModel.user_id      = self.ta_id;
    }
    return _taTieziView;
}

-(YWTaFollowView *)taFollowView {
    if (_taFollowView == nil) {
        _taFollowView                       = [[YWTaFollowView alloc] init];
        _taFollowView.backgroundColor       = [UIColor colorWithHexString:@"D6D6D9" alpha:0.9];
        _taFollowView.layer.masksToBounds   = YES;
        _taFollowView.layer.cornerRadius    = 22;
    }
    return _taFollowView;
}

-(TaViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TaViewModel alloc] init];
    }
    return _viewModel;
}

-(TaEntity *)taEntity {
    if (_taEntity == nil) {
        _taEntity = [[TaEntity alloc] init];
    }
    return _taEntity;
}

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem           = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(backFarword)];
        _leftBarItem.tintColor = [UIColor whiteColor];
        
    }
    return _leftBarItem;
}

- (CGFloat)navgationBarHeight {
    //导航栏＋状态栏高度
    return  self.navigationController.navigationBar.height+20;
}

-(UIView *)taNavigationBar {
    if (_taNavigationBar == nil) {
        _taNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   SCREEN_WIDTH,
                                                                    64)];
        _taNavigationBar.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_1 alpha:0];
    }
    return _taNavigationBar;
}

-(GalleryView *)galleryView {
    if (_galleryView == nil) {
        _galleryView                        = [[GalleryView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _galleryView.backgroundColor        = [UIColor blackColor];
        _galleryView.delegate               = self;
    }
    return _galleryView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.taScrollView addSubview:self.taHeaderView];
    [self.taScrollView addSubview:self.taTopicView];
    [self.taScrollView addSubview:self.taTieziView];
    
    [self.view addSubview:self.taScrollView];
    [self.view addSubview:self.taNavigationBar];
    
    //用户本人不显示关注和聊天视图
    if (self.ta_id != [[User findCustomer].userId intValue]) {
        [self.view addSubview:self.taFollowView];
    }
    
    [self loadTaInfoWith:self.ta_id];
    [self loadTaTopicWith:self.ta_id];
    
    [self setUILayout];
    
    [self setAllAction];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar hideNavigationBarBottomLine];
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0 alpha:0];
    
    self.navigationItem.leftBarButtonItem  = self.leftBarItem;

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reSetUILayout];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:THEME_COLOR_1];

}

- (void)reSetUILayout {
    //获取帖子行高，计算出taTieziView高度
    CGFloat rowHeight;
    for (int i = 0; i < self.taTieziView.rowHeightArr.count; i++) {
        rowHeight += [[self.taTieziView.rowHeightArr objectAtIndex:i] floatValue];
    }
    
    CGFloat taTieziViewHeight = rowHeight + 50;
    [self.taTieziView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taTopicView.mas_bottom).offset(10);
        make.left.right.equalTo(self.taTopicView);
        make.height.mas_equalTo(taTieziViewHeight);
    }];
    
    self.taScrollView.contentSize = CGSizeMake(SCREEN_WIDTH,HeadViewHeight + 170 + self.navgationBarHeight + taTieziViewHeight);
}
- (void)setUILayout {
    
    [self.taTopicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taHeaderView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@170);
    }];
    
    [self.taTieziView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taTopicView.mas_bottom).offset(10);
        make.left.right.equalTo(self.taTopicView);
        make.height.equalTo(@1200);
    }];
    
    if (self.ta_id != [[User findCustomer].userId intValue]) {
        [self.taFollowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(SCREEN_WIDTH / 375 * 75);
            make.right.mas_equalTo(self.view).offset(-SCREEN_WIDTH / 375 * 75);
            make.height.mas_equalTo(SCREEN_HEIGHT / (667 / 44));
            make.bottom.equalTo(self.view).offset(-10);
        }];
    }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //查看Ta的话题详情
    if ([segue.destinationViewController isKindOfClass:[MyTopicController class]])
    {
        if ([segue.identifier isEqualToString:SEGUE_IDENTIFY_MYTOPIC]) {
            MyTopicController *taTopicVc = segue.destinationViewController;
            taTopicVc.oneFieldVc.viewModel.user_id   = self.ta_id;
            taTopicVc.twoFieldVc.viewModel.user_id   = self.ta_id;
            taTopicVc.threeFieldVc.viewModel.user_id = self.ta_id;
            
        }
    } else if ([segue.destinationViewController isKindOfClass:[MyTieZiController class]])
    {
        if ([segue.identifier isEqualToString:SEGUE_IDENTIFY_MYTIEZI]) {
            MyTieZiController *taTieziVc = segue.destinationViewController;
            taTieziVc.viewModel.user_id  = self.ta_id;
        }
    }
    
}

#define NAVBAR_CHANGE_POINT 50

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y + 64;
    CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + HeadViewHeight - offsetY) / HeadViewHeight));
    
    if (offsetY >= HeadViewHeight-self.navgationBarHeight) {
        //上滑显示导航栏动画
        self.taNavigationBar.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_1 alpha:1];
        self.title                           = self.taEntity.name;
    }
    else
    {
        self.taNavigationBar.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_1 alpha:alpha];
        self.title                           = @"";
    }
    
    //缩放
    if (offsetY < 0) {
        
        CGRect headerViewFrame      = TaHeaderViewFrame;
        CGFloat delta               = 0.0f;
        delta                       = fabs(MIN(0.0f, offsetY));
        headerViewFrame.origin.y    -= delta;
        headerViewFrame.size.height += delta;
        headerViewFrame.size.width  += delta;
        self.taHeaderView.frame     = headerViewFrame;
        self.taHeaderView.center    = CGPointMake(SCREEN_WIDTH/2, self.taHeaderView.center.y);
        
    }

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


#pragma mark - action

- (void)setAllAction {
    [self.taHeaderView.headerView addTapAction:@selector(ShowHeadImage) target:self];
    [self.taTopicView addTapAction:@selector(jumpToTaTopicListPage) target:self];
    [self.taTieziView addTapAction:@selector(jumpToTaTieziListPage) target:self];
}

#pragma mark - private methods

//
- (void)loadTaInfoWith:(int)taId {
    
    NSDictionary *paramters = @{@"user_id":@(taId)};
    
    [self.viewModel requestTaDetailInfoWithUrl:TA_INFO_URL
                                    paramaters:paramters
                                       success:^(TaEntity *ta) {
                                           self.taEntity = ta;
                                           [self fillTaHeaderViewWith:ta];
                                           
                                       }
                                         error:^(NSURLSessionDataTask * task, NSError *error) {
                                             
                                         }];
}

- (void)loadTaTopicWith:(int)taId {
    
    //获取用户（我和TA）关注的话题
    NSDictionary *parameters = @{@"field_id":@(1),
                                 @"user_id":@(taId)};
    
    [self.viewModel requestTopicLikeListWithUrl:TOPIC_LIKE_LIST_URL
                                     paramaters:parameters
                                        success:^(NSArray *topicArr) {
                                            //将返回的用户关注列表添加到用户当前视图
                                            [self.taTopicView addTopicListViewBy:topicArr];
                                        }
                                        failure:^(NSString *error) {
                                            NSLog(@"获取用户列表失败");
                                        }];
    
    
}


- (void)ShowHeadImage {
    //点击头像显示大图
    NSMutableArray *imagesArr = [NSMutableArray array];
    [imagesArr addObject:self.taHeaderView.headerView];
    
    [self.galleryView setImages:imagesArr showAtIndex:0];
    self.galleryView.pageLabel.text = @"";
    [self.navigationController.view addSubview:self.galleryView];
}


- (void)backFarword {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fillTaHeaderViewWith:(TaEntity *)ta {
    
    if ([ta.sex integerValue] == 1) {
        self.taHeaderView.userName.text             = [NSString stringWithFormat:@"%@ ♂",ta.name];
    }else if ([ta.sex integerValue] == 2) {
        self.taHeaderView.userName.text             = [NSString stringWithFormat:@"%@ ♀",ta.name];
    }
    self.taHeaderView.signature.text                = ta.signature;
    self.taHeaderView.numberOfFollow.text           = [NSString stringWithFormat:@"%@关注",ta.like_cnt];
    self.taHeaderView.numberOfFans.text             = [NSString stringWithFormat:@"| %@粉丝",ta.liked_cnt];
    
    NSString *taHeadImageUrl                        = [NSString selectCorrectUrlWithAppendUrl:ta.face_img];
    
    UIImage *defaultHead                            = [UIImage imageNamed:@"defaultHead"];
    
    [self.taHeaderView.headerView sd_setImageWithURL:[NSURL URLWithString:taHeadImageUrl]
                                    placeholderImage:defaultHead];
    
    //这里注意未关注前user_like的初始值为为null，关注后才为1，取消后为0
    if (ta.like != nil && [ta.like intValue] == 0) {
        
        [self.taFollowView.followBtn addTarget:self
                                        action:@selector(addLike:)
                              forControlEvents:UIControlEventTouchUpInside];
        [self.taFollowView.followBtn setImage:[UIImage imageNamed:@"guanzhu"]
                                     forState:UIControlStateNormal];
        [self.taFollowView.followBtn setTitle:@"关注"
                                     forState:UIControlStateNormal];
        
    }
    else
    {
        
        [self.taFollowView.followBtn addTarget:self
                                        action:@selector(cancelLike:)
                              forControlEvents:UIControlEventTouchUpInside];
        
        [self.taFollowView.followBtn setImage:[UIImage imageNamed:@"tongzhi"]
                                     forState:UIControlStateNormal];
        [self.taFollowView.followBtn setTitle:@"关注中"
                                     forState:UIControlStateNormal];
        
    }
    
    //用户背景图
    int nowHour = [[NSDate getNowHour] intValue];
    if (nowHour <= 4 && nowHour >=0) { //凌晨
        self.taHeaderView.bgImageView.image         = [UIImage imageNamed:@"TabgImage1"];
    }else if (nowHour <= 8 && nowHour >=5) { //早上
        self.taHeaderView.bgImageView.image         = [UIImage imageNamed:@"TabgImage5"];
    }else if (nowHour <= 11 && nowHour >= 9) { //上午
        self.taHeaderView.bgImageView.image         = [UIImage imageNamed:@"TabgImage2"];
    }else if (nowHour <= 14 && nowHour >= 12) { //中午
        self.taHeaderView.bgImageView.image         = [UIImage imageNamed:@"TabgImage2"];
    }else if (nowHour <= 17 && nowHour >= 13) { //下午
        self.taHeaderView.bgImageView.image         = [UIImage imageNamed:@"TabgImage3"];
    }else { //晚上
        self.taHeaderView.bgImageView.image         = [UIImage imageNamed:@"TabgImage1"];
    }
    
}


//关注TA
- (void)addLike:(UIButton *)sender {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@""];
    
    NSDictionary *paramater = @{@"user_id":@(self.ta_id),
                                @"value":@1};
    
    [self.viewModel requestUserLikeWithUrl:TA_USER_LIKE_URL
                                paramaters:paramater
                                   success:^(StatusEntity *status) {
                                        
                                        if (status.status == YES) {
                                            
                                            [sender setImage:[UIImage imageNamed:@"tongzhi"]
                                                              forState:UIControlStateNormal];
                                            [sender setTitle:@"关注中" forState:UIControlStateNormal];
                                            //先移除之前已经添加的action，再添加新的action
                                            [sender removeTarget:self
                                                          action:@selector(addLike:)
                                                forControlEvents:UIControlEventTouchUpInside];
                                            [sender addTarget:self
                                                       action:@selector(cancelLike:)
                                             forControlEvents:UIControlEventTouchUpInside];
                                            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                                            [SVProgressHUD showSuccessStatus:@"关注成功" afterDelay:HUD_DELAY];
                                            //个人信息显示的粉丝人数+1
                                            self.taHeaderView.numberOfFans.text = [NSString stringWithFormat:@"| %d粉丝",[self.taEntity.liked_cnt intValue] + 1];
                                            self.taEntity.liked_cnt = [NSString stringWithFormat:@"%d",[self.taEntity.liked_cnt intValue] + 1];
                                            
                                        }
                                        else
                                        {
                                            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                                            [SVProgressHUD showErrorStatus:@"关注失败" afterDelay:HUD_DELAY];
                                        }
                                    } failure:^(NSString *error) {
                                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                                        [SVProgressHUD showErrorStatus:@"关注失败" afterDelay:HUD_DELAY];
                                        
                                    }];
    
    
}

//取关TA
- (void)cancelLike:(UIButton *)sender {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@""];

    NSDictionary *paramater = @{@"user_id":@(self.ta_id),
                                @"value":@(0)};
    
    [self.viewModel requestUserLikeWithUrl:TA_USER_LIKE_URL
                                paramaters:paramater
                                   success:^(StatusEntity *status) {
                                       if (status.status == YES) {
                                           [sender setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
                                           [sender setTitle:@"关注" forState:UIControlStateNormal];
                                           //先移除之前已经添加的action，再添加新的action
                                           [sender removeTarget:self
                                                         action:@selector(cancelLike:)
                                               forControlEvents:UIControlEventTouchUpInside];
                                           [sender addTarget:self
                                                      action:@selector(addLike:)
                                            forControlEvents:UIControlEventTouchUpInside];
                                           
                                           [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                                           [SVProgressHUD showSuccessStatus:@"已取消关注" afterDelay:HUD_DELAY];
                                           //个人信息显示的粉丝人数-1
                                           self.taHeaderView.numberOfFans.text = [NSString stringWithFormat:@"| %d粉丝",[self.taEntity.liked_cnt intValue] - 1];
                                           self.taEntity.liked_cnt = [NSString stringWithFormat:@"%d",[self.taEntity.liked_cnt intValue] - 1];

                                       }else {
                                           [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                                           [SVProgressHUD showErrorStatus:@"取消关注失败" afterDelay:HUD_DELAY];
                                       }
                                   }
                                   failure:^(NSString *error) {
                                       [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                                       [SVProgressHUD showErrorStatus:@"取消关注失败" afterDelay:HUD_DELAY];
                                   }];
}

- (void)jumpToTaTopicListPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_MYTOPIC sender:self];
}

- (void)jumpToTaTieziListPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_MYTIEZI sender:self];
}
@end
