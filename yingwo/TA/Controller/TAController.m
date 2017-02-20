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
#import "TopicController.h"
#import "MyRelationshipBaseController.h"

#import "ChatController.h"

#import "YWTaHeaderView.h"
#import "YWTaTopicView.h"
#import "YWTaFollowView.h"
#import "YWTaTieziView.h"

@interface TAController ()<UIScrollViewDelegate,YWTaTopicViewDelegate>

@property (nonatomic, strong) UIScrollView              *taScrollView;
@property (nonatomic, strong) YWTaHeaderView            *taHeaderView;
@property (nonatomic, strong) YWTaTopicView             *taTopicView;
@property (nonatomic, strong) YWTaTieziView             *taTieziView;
@property (nonatomic, strong) YWTaFollowView            *taFollowView;

@property (nonatomic, strong) TaViewModel               *viewModel;
@property (nonatomic, strong) TaEntity                  *taEntity;

@property (nonatomic, strong) UIView                    *taNavigationBar;

@property (nonatomic, assign) CGFloat                   navgationBarHeight;

@property (nonatomic, assign) int                       topic_id;
//关系类型 1我的好友 2我的关注 3我的粉丝 4我的访客 5Ta的关注 6Ta的粉丝
@property (nonatomic, assign) int                       relationType;


@end

static CGFloat HeadViewHeight = 250;


@implementation TAController

- (instancetype)initWithUserId:(int)userId {
    
    self = [super init];
    if (self) {
        self.ta_id = userId;
    }
    
    return self;
}

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

- (YWTaTieziView *)taTieziView {
    
    if (_taTieziView == nil) {
        _taTieziView = [[YWTaTieziView alloc] init];
        [_taTieziView addTapAction:@selector(jumpToTaTieziListPage) target:self];
        
    }
    return _taTieziView;
}

-(YWTaTopicView *)taTopicView {
    if (_taTopicView == nil) {
        _taTopicView                        = [[YWTaTopicView alloc] init];
//        _taTopicView.frame                  = CGRectMake(10, 260, SCREEN_WIDTH - 20, 170);
        _taTopicView.backgroundColor        = [UIColor whiteColor];
        _taTopicView.layer.masksToBounds    = YES;
        _taTopicView.layer.cornerRadius     = 5;
        _taTopicView.delegate               = self;
    }
    return _taTopicView;
}

-(YWTaFollowView *)taFollowView {
    if (_taFollowView == nil) {
        _taFollowView                       = [[YWTaFollowView alloc] init];
//        _taFollowView.backgroundColor       = [UIColor colorWithHexString:@"DCDCDC" alpha:1.0];
        _taFollowView.layer.masksToBounds   = YES;
        _taFollowView.layer.cornerRadius    = SCREEN_WIDTH / 375 * 22;
        [_taFollowView.chatBtn addTarget:self
                                  action:@selector(jumpToChatWithTa)
                        forControlEvents:UIControlEventTouchUpInside];
    }
    return _taFollowView;
}

-(TaViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TaViewModel alloc] init];
        _viewModel.userId = self.ta_id;
    }
    return _viewModel;
}

-(TaEntity *)taEntity {
    if (_taEntity == nil) {
        _taEntity = [[TaEntity alloc] init];
    }
    return _taEntity;
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

- (void)initDataSourceBlock {
    
    WeakSelf(self);
    [self.viewModel setHeaderImageSuccessBlock:^(NSString *imageURL) {
        
        [weakself.taHeaderView.bgImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                                             placeholderImage:[UIImage imageNamed:@"ying"]];
        
    } headerImageFailureBlock:^(id headerImageFailureBlock) {
        
        weakself.taHeaderView.bgImageView.image         = [UIImage imageNamed:@"TabgImage1"];

    }];
    
    [self.viewModel requestForHeaderImageWithURL:TA_USER_BACKGROUND_URL];
    
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
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:THEME_COLOR_1];

}

- (void)setUILayout {
    
    [self.taTieziView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taHeaderView.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    [self.taTopicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taTieziView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(SCREEN_HEIGHT / 667 * 170);
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

#pragma mark - YWTaTopicViewDelegate
- (void)didSelectTopicWith:(int)topicId {
   
    TopicController *topicVc = [[TopicController alloc] initWithTopicId:topicId];
    [self.navigationController pushViewController:topicVc animated:YES];
}

#pragma mark - action

- (void)setAllAction {
    [self.taHeaderView.headerView addTapAction:@selector(showHeadImage) target:self];
    [self.taHeaderView.numberOfFollow addTapAction:@selector(jumpToTaFollowPage) target:self];
    [self.taHeaderView.numberOfFans addTapAction:@selector(jumpToTaFansPage) target:self];
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


- (void)showHeadImage {
    //点击头像显示大图
    
    UIView *bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    bgView.backgroundColor = [UIColor blackColor];
        
    [bgView addTapAction:@selector(disappear:) target:self];
    
    
    UIImageView *newImageView = [[UIImageView alloc] init];
    newImageView.image        = self.taHeaderView.headerView.image;
    newImageView.frame       = CGRectMake(0, (SCREEN_HEIGHT-SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH);
    
    [bgView addSubview:newImageView];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:bgView];
    
}

- (void)disappear:(UIGestureRecognizer *)gesture {
    
    __block UIView *bgView = gesture.view;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        bgView.alpha = 0;

    } completion:^(BOOL finished) {
        
        [bgView removeFromSuperview];
        bgView = nil;

    }];
    
    
    
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
        [self.taFollowView.followBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1]
                                          forState:UIControlStateNormal];

        
    }
    else
    {
        
        [self.taFollowView.followBtn addTarget:self
                                        action:@selector(cancelLike:)
                              forControlEvents:UIControlEventTouchUpInside];
        
        [self.taFollowView.followBtn setImage:[UIImage imageNamed:@"guanzhuzhong"]
                                     forState:UIControlStateNormal];
        [self.taFollowView.followBtn setTitle:@"关注中"
                                     forState:UIControlStateNormal];
        [self.taFollowView.followBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_4]
                                          forState:UIControlStateNormal];

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
                                            
                                            [sender setImage:[UIImage imageNamed:@"guanzhuzhong"]
                                                              forState:UIControlStateNormal];
                                            [sender setTitle:@"关注中" forState:UIControlStateNormal];
                                            [sender setTitleColor:[UIColor colorWithHexString:THEME_COLOR_4]
                                                         forState:UIControlStateNormal];

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

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消关注Ta吗？"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *imageAction = [UIAlertAction actionWithTitle:@""
                                                          style:UIAlertActionStyleDefault
                                                        handler:nil];
    UIImage *accessoryImage = self.taHeaderView.headerView.image;

    accessoryImage = [UIImage scaleImageToSize:CGSizeMake(40, 40) withImage:accessoryImage];
    accessoryImage = [UIImage circlewithImage:accessoryImage];
    accessoryImage = [accessoryImage imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, - SCREEN_WIDTH / 2 + 40, 0, 0)];
    accessoryImage = [accessoryImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [imageAction setValue:accessoryImage forKey:@"image"];
    
    [alertController addAction:imageAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                          NSDictionary *paramater = @{@"user_id":@(self.ta_id),
                                                                                      @"value":@(0)};
                                                          
                                                          [self.viewModel requestUserLikeWithUrl:TA_USER_LIKE_URL
                                                                                      paramaters:paramater
                                                                                         success:^(StatusEntity *status) {
                                                                                             if (status.status == YES) {
                                                                                                 [sender setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
                                                                                                 [sender setTitle:@"关注" forState:UIControlStateNormal];
                                                                                                 [sender setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1]
                                                                                                                                   forState:UIControlStateNormal];

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
                                                          
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    alertController.view.tintColor = [UIColor blackColor];
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alertController
                                     animated:YES
                                   completion:nil];
}


- (void)jumpToTaTopicListPage {
    
    MyTopicController *taTopicVc = [[MyTopicController alloc] initWithUserId:self.ta_id title:@"TA的话题"];
    taTopicVc.isMyTopic = YES;
    [self.navigationController pushViewController:taTopicVc animated:YES];
    
}

- (void)jumpToTaTieziListPage {
    
    
    MyTieZiController *userTieZi = [[MyTieZiController alloc] initWithUserId:self.ta_id title:@"TA的贴子"];
    [self.navigationController pushViewController:userTieZi animated:YES];
    
}

- (void)jumpToTaFollowPage {
    MyRelationshipBaseController *relationVc = [[MyRelationshipBaseController alloc] initWithRelationType:HisRelationShip];
    
    relationVc.requestEntity.user_id         = self.ta_id;
    relationVc.followCnt                     = [self.taEntity.like_cnt intValue];
    relationVc.fansCnt                       = [self.taEntity.liked_cnt intValue];

    [self.navigationController pushViewController:relationVc animated:YES];
}

- (void)jumpToTaFansPage {
    MyRelationshipBaseController *relationVc = [[MyRelationshipBaseController alloc] initWithRelationType:HisFansRelationShip];
    
    relationVc.requestEntity.user_id         = self.ta_id;
    relationVc.followCnt                     = [self.taEntity.like_cnt intValue];
    relationVc.fansCnt                       = [self.taEntity.liked_cnt intValue];

    [self.navigationController pushViewController:relationVc animated:YES];}

- (void)jumpToChatWithTa {
    
    ChatController *chatVc = [[ChatController alloc] initWithConversationType:ConversationType_PRIVATE
                                                                     targetId:[NSString stringWithFormat:@"%d",self.ta_id]];
    chatVc.title = self.taHeaderView.userName.text;
    [self.navigationController pushViewController:chatVc animated:YES];
    
}

@end
