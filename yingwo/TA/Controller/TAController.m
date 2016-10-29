//
//  TAController.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TAController.h"

#import "YWTaHeaderView.h"
#import "YWTaTopicView.h"
#import "YWTaTieziView.h"


@interface TAController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView              *taScrollView;
@property (nonatomic, strong) YWTaHeaderView            *taHeaderView;
@property (nonatomic, strong) YWTaTopicView             *taTopicView;
@property (nonatomic, strong) YWTaTieziView             *taTieziView;
@property (nonatomic, strong) UIView                    *taNavigationBar;

@property (nonatomic, strong) TaViewModel               *viewModel;

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
        _taTopicView.backgroundColor        = [UIColor redColor];
        _taTopicView.layer.masksToBounds    = YES;
        _taTopicView.layer.cornerRadius     = 5;
        
    }
    return _taTopicView;
}

-(YWTaTieziView *)taTieziView {
    if(_taTieziView == nil) {
        _taTieziView                        = [[YWTaTieziView alloc] init];
        _taTieziView.backgroundColor        = [UIColor orangeColor];
        _taTieziView.layer.masksToBounds    = YES;
        _taTieziView.layer.cornerRadius     = 5;
    }
    return _taTieziView;
}

-(TaViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TaViewModel alloc] init];
    }
    return _viewModel;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.taScrollView addSubview:self.taHeaderView];
    [self.taScrollView addSubview:self.taTopicView];
    [self.taScrollView addSubview:self.taTieziView];
    
    [self.view addSubview:self.taScrollView];
    [self.view addSubview:self.taNavigationBar];

    [self setUILayout];
    
    [self loadTaInfoWith:self.ta_id];


}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController.navigationBar hideNavigationBarBottomLine];
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0 alpha:0];
    
    self.navigationItem.leftBarButtonItem  = self.leftBarItem;

}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:THEME_COLOR_1];

}

- (void)loadTaInfoWith:(int)taId {
    
    NSDictionary *paramters = @{@"user_id":@(taId)};
    
    [self.viewModel requestTaDetailInfoWithUrl:TA_INFO_URL
                                    paramaters:paramters
                                       success:^(TaEntity *ta) {
                                           [self fillTaHeaderViewWith:ta];
                                           
                                       }
                                         error:^(NSURLSessionDataTask * task, NSError *error) {
                                             
                                         }];
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
        make.height.equalTo(@300);
    }];

}

#pragma mark - private methods

- (void)backFarword {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)fillTaHeaderViewWith:(TaEntity *)ta {
    self.taHeaderView.userName.text                 = ta.name;
    self.taHeaderView.signature.text                = ta.signature;
    self.taHeaderView.numberOfFollow.text           = [NSString stringWithFormat:@"%@关注",ta.like_cnt];
    self.taHeaderView.numberOfFans.text             = [NSString stringWithFormat:@"| %@粉丝",ta.liked_cnt];
    
    NSString *taHeadImageUrl                        = [NSString selectCorrectUrlWithAppendUrl:ta.face_img];
    
    UIImage *defaultHead                            = [UIImage imageNamed:@"defaultHead"];
    
    [self.taHeaderView.headerView sd_setImageWithURL:[NSURL URLWithString:taHeadImageUrl]
                                    placeholderImage:defaultHead];
    
    self.taHeaderView.bgImageView.image = [UIImage imageNamed:@"TabgImage"];
    
    
    
}


@end
