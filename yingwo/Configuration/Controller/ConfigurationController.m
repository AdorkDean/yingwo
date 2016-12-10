//
//  ConfigurationController.m
//  yingwo
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//
/** 缓存路径 */
#define YWCacheFile [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"default"]

#import "ConfigurationController.h"
#import "YWConfigurationCell.h"
#import "ClauseViewController.h"
#import "AboutUsController.h"
#import "MessagePushController.h"

@interface ConfigurationController ()

@property (nonatomic, strong) YWConfigurationCell *phoneBindedCell;
@property (nonatomic, strong) YWConfigurationCell *modifyPasswordCell;
@property (nonatomic, strong) YWConfigurationCell *messagePushCell;
@property (nonatomic, strong) YWConfigurationCell *cleanCacheCell;
@property (nonatomic, strong) YWConfigurationCell *userDelegateCell;
@property (nonatomic, strong) YWConfigurationCell *adviceCell;
@property (nonatomic, strong) YWConfigurationCell *pointCell;
@property (nonatomic, strong) YWConfigurationCell *aboutUsCell;
@property (nonatomic, strong) UIButton            *exitAccountBtn;
@property (nonatomic, strong) UIScrollView        *backgroundSrcView;
@end

@implementation ConfigurationController

#pragma mark 懒加载
- (YWConfigurationCell *)phoneBindedCell {
    if (_phoneBindedCell == nil) {
        _phoneBindedCell = [[YWConfigurationCell alloc] initWithLeftLabel:@"手机绑定" isHasRightView:YES];
        [_phoneBindedCell setBackgroundImage:[UIImage imageNamed:@"input_top"] forState:UIControlStateNormal];
        [_phoneBindedCell setBackgroundImage:[UIImage imageNamed:@"input_top_selected"] forState:UIControlStateHighlighted];
    }
    return _phoneBindedCell;
}

- (YWConfigurationCell *)modifyPasswordCell {
    if (_modifyPasswordCell == nil) {
        _modifyPasswordCell = [[YWConfigurationCell alloc] initWithLeftLabel:@"修改密码" isHasRightView:YES];
        [_modifyPasswordCell setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_modifyPasswordCell setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];
    }
    return _modifyPasswordCell;
}

- (YWConfigurationCell *)messagePushCell {
    if (_messagePushCell == nil) {
        _messagePushCell = [[YWConfigurationCell alloc] initWithLeftLabel:@"消息推送" isHasRightView:YES];
        [_messagePushCell setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_messagePushCell setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];

    }
    return _messagePushCell;
}

- (YWConfigurationCell *)cleanCacheCell {
    if (_cleanCacheCell == nil) {
        _cleanCacheCell = [[YWConfigurationCell alloc] initWithLeftLabel:@"清除缓存" isHasRightView:NO];
        [_cleanCacheCell setBackgroundImage:[UIImage imageNamed:@"input_col"] forState:UIControlStateNormal];
        [_cleanCacheCell setBackgroundImage:[UIImage imageNamed:@"input_col_selected"] forState:UIControlStateHighlighted];

    }
    return _cleanCacheCell;
}

- (YWConfigurationCell *)userDelegateCell {
    if (_userDelegateCell == nil) {
        _userDelegateCell = [[YWConfigurationCell alloc] initWithLeftLabel:@"用户协议" isHasRightView:YES];
        [_userDelegateCell setBackgroundImage:[UIImage imageNamed:@"input_top"] forState:UIControlStateNormal];
        [_userDelegateCell setBackgroundImage:[UIImage imageNamed:@"input_top_selected"] forState:UIControlStateHighlighted];
    }
    return _userDelegateCell;
}

- (YWConfigurationCell *)adviceCell {
    if (_adviceCell == nil) {
        _adviceCell = [[YWConfigurationCell alloc] initWithLeftLabel:@"意见反馈" isHasRightView:YES];
        [_adviceCell setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_adviceCell setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];
    }
    return _adviceCell;
}

- (YWConfigurationCell *)pointCell {
    if (_pointCell == nil) {
        _pointCell = [[YWConfigurationCell alloc] initWithLeftLabel:@"给APP评分" isHasRightView:YES];
        [_pointCell setBackgroundImage:[UIImage imageNamed:@"input_mid"] forState:UIControlStateNormal];
        [_pointCell setBackgroundImage:[UIImage imageNamed:@"input_mid_selected"] forState:UIControlStateHighlighted];
    }
    return _pointCell;
}

- (YWConfigurationCell *)aboutUsCell {
    if (_aboutUsCell == nil) {
        _aboutUsCell = [[YWConfigurationCell alloc] initWithLeftLabel:@"关于我们" isHasRightView:YES];
        [_aboutUsCell setBackgroundImage:[UIImage imageNamed:@"input_col"] forState:UIControlStateNormal];
        [_aboutUsCell setBackgroundImage:[UIImage imageNamed:@"input_col_selected"] forState:UIControlStateHighlighted];
    }
    return _aboutUsCell;
}

- (UIButton *)exitAccountBtn {
    if (_exitAccountBtn == nil) {
        _exitAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exitAccountBtn setTitle:@"退出帐号" forState:UIControlStateNormal];
        _exitAccountBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_exitAccountBtn setTitleColor:[UIColor colorWithHexString:RED_COLOR] forState:UIControlStateNormal];
        [_exitAccountBtn setBackgroundImage:[UIImage imageNamed:@"input_text"] forState:UIControlStateNormal];
    }
    return _exitAccountBtn;
}

- (UIScrollView *)backgroundSrcView {
    if (_backgroundSrcView == nil) {
        
        _backgroundSrcView = [[UIScrollView alloc] init];
        _backgroundSrcView.frame = [self.view bounds];
        _backgroundSrcView.center = self.view.center;
        _backgroundSrcView.showsHorizontalScrollIndicator = NO;
        _backgroundSrcView.showsVerticalScrollIndicator = NO;
        
        //iphone 5需要扩张长度，否则屏幕不够用😢，布局太长了
        if (IS_IPHONE_5) {
            _backgroundSrcView.contentSize= CGSizeMake(320, 650);
            
        }
    }
    return _backgroundSrcView;
}

#pragma mark 本地数据加载
- (void)loadDataFromLocalForCustomer {
    
    Customer *customer = [User findCustomer];
    [self dispalyPhone:customer.mobile];
    
}

- (void)dispalyPhone:(NSString *)phone {
    
    NSString *fourStars = @"****";
    NSString *frontPart = [phone substringToIndex:3];
    NSString *tailPart  = [phone substringFromIndex:7];
    NSString *newPhone  = [NSString stringWithFormat:@"%@%@%@",frontPart,fourStars,tailPart];
    
    self.phoneBindedCell.rightLabel.text = newPhone;
}

#pragma mark - 加载显示缓存大小
- (void)loadCachesToDisplay {
    
    // 禁止点击事件
    self.cleanCacheCell.userInteractionEnabled = NO;

    // 计算大小
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        
        // 计算缓存大小
        NSInteger size = YWCacheFile.fileSize;
        CGFloat unit = 1000.0;
        NSString *sizeText = nil;
        if (size >= unit * unit * unit) { // >= 1GB
            sizeText = [NSString stringWithFormat:@"%.1fGB", size / unit / unit / unit];
        } else if (size >= unit * unit) { // >= 1MB
            sizeText = [NSString stringWithFormat:@"%.1fMB", size / unit / unit];
        } else if (size >= unit) { // >= 1KB
            sizeText = [NSString stringWithFormat:@"%.1fKB", size / unit];
        } else { // >= 0B
            sizeText = [NSString stringWithFormat:@"%zdB", size];
        }
        NSString *text = [NSString stringWithFormat:@"%@", sizeText];
        
        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.cleanCacheCell.rightLabel.text = text;
            
            // 允许点击事件
            self.cleanCacheCell.userInteractionEnabled = YES;
        }];
    }];

}

#pragma mark UI布局
- (void)setAllUILayout {
    
    [self.phoneBindedCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundSrcView.mas_top).offset(15);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    [self.modifyPasswordCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneBindedCell.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);

    }];
    
    [self.messagePushCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modifyPasswordCell.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);

    }];
    
    [self.cleanCacheCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messagePushCell.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);

    }];
    
    [self.userDelegateCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cleanCacheCell.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);

    }];
    
    [self.adviceCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userDelegateCell.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);

    }];
    
    [self.pointCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adviceCell.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);

    }];
    
    [self.aboutUsCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointCell.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);

    }];
    
    [self.exitAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aboutUsCell.mas_bottom).offset(15);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);

    }];
    
}

#pragma mark set all cell's action in here

- (void)setAllAction {
    [self.modifyPasswordCell addTarget:self action:@selector(jumpToModifyPasswordPage) forControlEvents:UIControlEventTouchUpInside];
    [self.exitAccountBtn addTarget:self action:@selector(exitAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.cleanCacheCell addTarget:self action:@selector(cleanCacheAlret) forControlEvents:UIControlEventTouchUpInside];
    [self.userDelegateCell addTarget:self action:@selector(jumpToClausePage) forControlEvents:UIControlEventTouchUpInside];
    [self.adviceCell addTarget:self action:@selector(jumpToAdvicePage) forControlEvents:UIControlEventTouchUpInside];
    [self.pointCell addTarget:self action:@selector(jumpToPointPage) forControlEvents:UIControlEventTouchUpInside];
    [self.aboutUsCell addTarget:self action:@selector(jumpToAboutUsPage) forControlEvents:UIControlEventTouchUpInside];
    [self.messagePushCell addTarget:self action:@selector(jumpToMessagePushPage) forControlEvents:UIControlEventTouchUpInside];
}

//清除缓存警告视图
- (void)cleanCacheAlret {
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"警告" message:@"确定清除缓存？" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //清除缓存
        [self cleanCache];
    }]];
    
    [self presentViewController:alertView animated:true completion:nil];

}

- (void)cleanCache {
    
    [SVProgressHUD showWithStatus:@"正在清除缓存"];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        [[NSFileManager defaultManager] removeItemAtPath:YWCacheFile error:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [SVProgressHUD showSuccessStatus:@"清除成功" afterDelay:1.0];
            self.cleanCacheCell.rightLabel.text = @"";
            
            // 禁止点击事件
            self.cleanCacheCell.userInteractionEnabled = NO;
        }];
    }];
}

//正在开发中
- (void)developing {
    [SVProgressHUD showInfoStatus:@"功能开发中···" afterDelay:1.5];
}

- (void)jumpToMessagePushPage {
    MessagePushController *messagePush = [[MessagePushController alloc] init];
    [self.navigationController pushViewController:messagePush animated:YES];

}

- (void)jumpToPointPage {
    NSString * url = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",@"1106325073"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)jumpToAdvicePage {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ying-wo-xiao-yuan/id1106325073?mt=8"]];
}

- (void)jumpToClausePage {
    ClauseViewController *clause = [[ClauseViewController alloc] init];
    [self.navigationController pushViewController:clause animated:YES];
}

- (void)jumpToAboutUsPage {
    AboutUsController *aboutUs = [[AboutUsController alloc] init];
    [self.navigationController pushViewController:aboutUs animated:YES];
}

- (void)jumpToModifyPasswordPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_RESET sender:self];
}

- (void)jumpToLoginPage {
    LoginController *loginVC  = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_LOGINVC_IDENTIFIER];
    [self.navigationController pushViewController:loginVC animated:YES];
}

//退出帐号，返回登录界面
- (void)exitAccount {
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"是否确定退出帐号？"
                                                                preferredStyle:UIAlertControllerStyleAlert];

    [alertView addAction:[UIAlertAction actionWithTitle:@"确定"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
        
                                                    [User deleteCustoer];
                                                    [User deleteLoginInformation];
                                                    [self jumpToLoginPage];
     
    }]];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"取消"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * _Nonnull action) {
                                                    
                                                }]];
    
    [self presentViewController:alertView animated:true completion:nil];
    
}

//返回个人中心界面
- (void)backToPersonCenterView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backgroundSrcView];
    [self.backgroundSrcView addSubview:self.phoneBindedCell];
    [self.backgroundSrcView addSubview:self.modifyPasswordCell];
    [self.backgroundSrcView addSubview:self.messagePushCell];
    [self.backgroundSrcView addSubview:self.cleanCacheCell];
    [self.backgroundSrcView addSubview:self.userDelegateCell];
    [self.backgroundSrcView addSubview:self.adviceCell];
    [self.backgroundSrcView addSubview:self.pointCell];
    [self.backgroundSrcView addSubview:self.aboutUsCell];
    [self.backgroundSrcView addSubview:self.exitAccountBtn];

    [self setAllUILayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title                              = @"设置";
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(backToPersonCenterView)];
    
    [self loadDataFromLocalForCustomer];
    [self setAllAction];
    [self loadCachesToDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
