//
//  MessagePushController.m
//  yingwo
//
//  Created by 王世杰 on 2016/12/10.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MessagePushController.h"
#import "YWConfigurationCell.h"

@interface MessagePushController ()

@property (nonatomic, strong) YWConfigurationCell *messagePushcell;
@property (nonatomic, strong) UILabel             *remindLabel;

@end

@implementation MessagePushController

-(YWConfigurationCell *)messagePushcell {
    if (_messagePushcell == nil) {
        _messagePushcell = [[YWConfigurationCell alloc] initWithLeftLabel:@"新消息通知" isHasRightView:NO];
        [_messagePushcell setBackgroundImage:[UIImage imageNamed:@"input_top"] forState:UIControlStateNormal];
        [_messagePushcell setBackgroundImage:[UIImage imageNamed:@"input_top_selected"] forState:UIControlStateHighlighted];
    }
    return _messagePushcell;
}

-(UILabel *)remindLabel {
    if (_remindLabel == nil) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.textColor                = [UIColor colorWithHexString:THEME_COLOR_4];
        _remindLabel.font                     = [UIFont systemFontOfSize:13];
        _remindLabel.textAlignment            = NSTextAlignmentLeft;

    }
    return _remindLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.messagePushcell];
    [self.view addSubview:self.remindLabel];
    
    [self setNotiState];
    
    [self setAllUILayout];
}


#pragma mark UI布局
- (void)setAllUILayout {
    [self.messagePushcell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];

    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messagePushcell.mas_bottom).offset(10);
        make.left.right.equalTo(self.messagePushcell);
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title               = @"消息推送";
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(backToConfigurationView)];
}

//获取开关状态
-(void)setNotiState {
    self.messagePushcell.rightLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_4];
    self.messagePushcell.rightLabel.font      = [UIFont systemFontOfSize:14];
    self.messagePushcell.rightLabel.text      = [self isAllowedNotification] ? @"已开启":@"已关闭";
    
    self.remindLabel.text                     = @"请在iPhone的“设置”-“通知”中进行修改。";
}

//判断用户是否允许推送
- (BOOL)isAllowedNotification {
    
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (setting.types != UIUserNotificationTypeNone) {
        return YES;
    }
    return NO;
}


- (void)backToConfigurationView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
