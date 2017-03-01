//
//  PersonalCenterController.m
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "PersonalCenterController.h"
#import "PerfectInfoController.h"
#import "MyTopicController.h"
#import "MyTieZiController.h"
#import "MyRelationshipBaseController.h"
#import "MyLikeController.h"
#import "MyCommentController.h"

#import "YWCustomerCell.h"
#import "YWPersonCenterTopView.h"
#import "YWPersonCenterMidCell.h"

#import "PersonViewModel.h"

@interface PersonalCenterController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) YWPersonCenterTopView *headView;
@property (nonatomic, strong) YWPersonCenterMidCell *midView;
@property (nonatomic, strong) YWCustomerCell        *cellView1;
@property (nonatomic, strong) YWCustomerCell        *cellView2;
@property (nonatomic, strong) YWCustomerCell        *cellView3;
@property (nonatomic, strong) YWCustomerCell        *cellView4;
@property (nonatomic, strong) UIBarButtonItem       *rightBarItem;

@property (nonatomic, strong) TaEntity              *taEntity;

@property (nonatomic, assign) int                   relationType;

@property (nonatomic, strong) Customer                  *user;

@end

@implementation PersonalCenterController

#pragma mark 懒加载

- (Customer *)user {
    if (_user == nil) {
        _user = [User findCustomer];
    }
    return _user;
}

- (YWPersonCenterTopView *)headView {
    if (_headView == nil) {
        _headView = [[YWPersonCenterTopView alloc] initWithHeadPortrait:[UIImage imageNamed:@"defaultHead"]
                                                               username:@"张三"
                                                              signature:@"nice day"
                                                                 gender:@"male"];
        
        [_headView setBackgroundImage:[UIImage imageNamed:@"WBG"]
                             forState:UIControlStateNormal];
        [_headView setBackgroundImage:[UIImage imageNamed:@"WBG_selected"]
                             forState:UIControlStateHighlighted];
        _headView.genderImageView.image = [UIImage imageNamed:@"man"];
    }
    return _headView;
}

- (YWPersonCenterMidCell *)midView {
    if (_midView == nil) {
        _midView = [[YWPersonCenterMidCell alloc] initWithFriends:@"-" attentions:@"-" fans:@"-" visitors:@"-"];
        _midView.image = [UIImage imageNamed:@"input_text"];
    }
    return _midView;
}

- (YWCustomerCell *)cellView1 {
    if (_cellView1 == nil) {
        _cellView1 = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"#"] labelText:@"我的话题"];
        [_cellView1 setBackgroundImage:[UIImage imageNamed:@"input_top"] forState:UIControlStateNormal];
        [_cellView1 setBackgroundImage:[UIImage imageNamed:@"input_top_selected"] forState:UIControlStateHighlighted];
    }
    return _cellView1;
}


- (YWCustomerCell *)cellView2 {
    if (_cellView2 == nil) {
        _cellView2 = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"note"] labelText:@"我的贴子"];
        [_cellView2 setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_cellView2 setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];

    }
    return _cellView2;
}

- (YWCustomerCell *)cellView3 {
    if (_cellView3 == nil) {
        _cellView3 = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"mes"] labelText:@"我的评论"];
        [_cellView3 setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_cellView3 setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];
    }
    return _cellView3;
}

- (YWCustomerCell *)cellView4 {
    if (_cellView4 == nil) {
        _cellView4 = [[YWCustomerCell alloc] initWithLeftImage:[UIImage imageNamed:@"heart"] labelText:@"我的点赞"];
        [_cellView4 setBackgroundImage:[UIImage imageNamed:@"input_col"] forState:UIControlStateNormal];
        [_cellView4 setBackgroundImage:[UIImage imageNamed:@"input_col_selected"] forState:UIControlStateHighlighted];
    }
    return _cellView4;
}

- (TaEntity *)taEntity {
    if (_taEntity == nil) {
        _taEntity = [[TaEntity alloc] init];
    }
    return _taEntity;
}

- (UIBarButtonItem *)rightBarItem {
    if (_rightBarItem == nil) {
        _rightBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"gear"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToConfigurationPage)];
    }
    return _rightBarItem;
}

-(PersonViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[PersonViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark UI布局
- (void)setUILayout {
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
    }];
    
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    [self.cellView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    [self.cellView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellView1.mas_bottom);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    [self.cellView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellView2.mas_bottom);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    [self.cellView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellView3.mas_bottom);
        make.centerX.equalTo(self.view);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
}

#pragma mark 本地数据加载
- (void)loadDataFromLocalForCustomer {
    
    Customer *customer = [User findCustomer];
    if (customer != nil) {
        
        self.headView.usernameLabel.text  = customer.name;
        self.headView.signatureLabel.text = customer.signature;
        NSString *imagePath               = [YWSandBoxTool getHeadPortraitPathFromCache];
        
        //有网的情况下图片都是从服务器上获取
        if ([YWNetworkTools networkStauts]) {
            
            NSString *imageUrl = [NSString selectCorrectUrlWithAppendUrl:customer.face_img];
            
            [self.headView.headPortraitImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        }
        else
        {
            if (imagePath != nil) {
                
                self.headView.headPortraitImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                
            }
        }

        if ([customer.sex isEqualToString:@"2"]) {
            self.headView.genderImageView.image = [UIImage imageNamed:@"woman"];
        }else {
            self.headView.genderImageView.image = [UIImage imageNamed:@"man"];
        }

    }
    
}

#pragma mark action

- (void)setAllAction {
    [self.headView addTarget:self
                      action:@selector(jumpToBaseInfoPage)
            forControlEvents:UIControlEventTouchUpInside];
    
    [self.cellView1 addTarget:self
                       action:@selector(jumpToMyTopicPage)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.cellView2 addTarget:self
                       action:@selector(jumpToMyTieZiPage)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.cellView3 addTarget:self
                       action:@selector(jumpToMyCommentPage)
             forControlEvents:UIControlEventTouchUpInside];
    
    [self.cellView4 addTarget:self
                       action:@selector(jumpToMyLikePage)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.midView.friends addTapAction:@selector(jumpToMyFriendsPage) target:self];
    
    [self.midView.attentions addTapAction:@selector(jumpToMyFollowPage) target:self];
    
    [self.midView.fans addTapAction:@selector(jumpToMyFansPage) target:self];
    
    [self.midView.friendLabel addTapAction:@selector(jumpToMyFriendsPage) target:self];
    
    [self.midView.attentionLabel addTapAction:@selector(jumpToMyFollowPage) target:self];
    
    [self.midView.fansLabel addTapAction:@selector(jumpToMyFansPage) target:self];
    
}

//跳转到完善信息的界面
- (void)jumpToBaseInfoPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_PERFECTINFO sender:self];
}

- (void)jumpToConfigurationPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_CONFIGURATION sender:self];
}

- (void)jumpToMyTopicPage {
    
    MyTopicController *topicVc = [[MyTopicController alloc] initWithUserId:[self.user.userId intValue] title:@"我的话题"];
    
    [self.navigationController pushViewController:topicVc animated:YES];
}
//正在开发中
- (void)developing {
    [SVProgressHUD showInfoStatus:@"功能开发中···" afterDelay:1.5];
}

- (void)jumpToMyTieZiPage {
    MyTieZiController *myTieZiVc = [[MyTieZiController alloc] initWithUserId:[self.user.userId intValue] title:@"我的贴子"];
    [self.navigationController pushViewController:myTieZiVc animated:YES];
    
}

- (void)jumpToMyLikePage {
    
    MyLikeController *likeVc = [[MyLikeController alloc] init];
    
    [self.navigationController pushViewController:likeVc animated:YES];
}

- (void)jumpToMyCommentPage {
    
    MyCommentController *commentVc = [[MyCommentController alloc] init];
    [self.navigationController pushViewController:commentVc animated:YES];

}

- (void)jumpToMyFriendsPage {

    [self jumpToRelationWithRelationType:FriendRelationShip];
}

- (void)jumpToMyFollowPage {

    [self jumpToRelationWithRelationType:ConcernRelationShip];

}

- (void)jumpToMyFansPage {
    self.relationType = 3;
    [self jumpToRelationWithRelationType:FansRelationShip];
}

- (void)jumpToRelationWithRelationType:(RelationType)type {
    
    MyRelationshipBaseController *relationVc = [[MyRelationshipBaseController alloc] initWithRelationType:HisRelationShip];
    
    relationVc.requestEntity.user_id         = [self.user.userId intValue];
    relationVc.followCnt                     = [self.taEntity.like_cnt intValue];
    relationVc.fansCnt                       = [self.taEntity.liked_cnt intValue];
    relationVc.relationType                  = type;
    
    [self.navigationController pushViewController:relationVc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headView];
    [self.view addSubview:self.midView];
    [self.view addSubview:self.cellView1];
    [self.view addSubview:self.cellView2];
    [self.view addSubview:self.cellView3];
    [self.view addSubview:self.cellView4];
    
    [self setUILayout];
    [self setAllAction];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"我的";
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    //获取显示在关系cell中的数据
    [self loadPersonInfo];
    
    [self loadDataFromLocalForCustomer];

    [self judgeNetworkStatus];
}

- (void)loadPersonInfo {
    //加载用户信息
    int taId = [[User findCustomer].userId intValue];
    NSDictionary *paramters = @{@"user_id":@(taId)};
    
    [self.viewModel requestTaDetailInfoWithUrl:TA_INFO_URL
                                    paramaters:paramters
                                       success:^(TaEntity *ta) {
                                           self.taEntity                = ta;
                                           self.midView.friends.text    = ta.friend_cnt;
                                           self.midView.attentions.text = ta.like_cnt;
                                           self.midView.fans.text       = ta.liked_cnt;
                                       }
                                         error:^(NSURLSessionDataTask * task, NSError *error) {
                                             
                                         }];

}
/**
 *  网路监测
 */
- (void)judgeNetworkStatus {
    [YWNetworkTools networkStauts];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PerfectInfoController class]]) {
        
        if ([segue.identifier isEqualToString: SEGUE_IDENTIFY_PERFECTINFO]) {
            PerfectInfoController *perfectInfo = segue.destinationViewController;
            Customer *user                     = [User findCustomer];
            perfectInfo.signature              = user.signature;
            perfectInfo.name                   = user.name;
            perfectInfo.academy_id             = user.academy_id;
            perfectInfo.school_id              = user.school_id;
            perfectInfo.school                 = user.school_name;
            perfectInfo.academy                = user.academy_name;
            perfectInfo.gender                 = user.sex;
            perfectInfo.grade                  = user.grade;
            perfectInfo.headImagePath          = [YWSandBoxTool getHeadPortraitPathFromCache];
            perfectInfo.isModfiyInfo           = YES;
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
