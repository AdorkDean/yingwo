//
//  ResetPasswordController.m
//  yingwo
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ResetPasswordController.h"

@interface ResetPasswordController ()

@property (nonatomic, strong) InputTextField *verificationText;
@property (nonatomic, strong) InputTextField *passwordText;
@property (nonatomic, strong) UIButton       *retransmitBtn;
@property (nonatomic, strong) UIButton       *finishedBtn;
@property (nonatomic, strong) UIImageView    *eyesView;
@property (nonatomic, strong) UILabel        *hintLabel;
@property (nonatomic, strong) UILabel        *phoneLabel;
@property (nonatomic, strong) NSTimer        *countDownTimer;
@property (nonatomic,assign ) int            timeCount;

@end

@implementation ResetPasswordController

#define mark -------懒加载
- (InputTextField *)verificationText {
    if (_verificationText == nil) {
        _verificationText = [[InputTextField alloc] initWithLeftLabel:@"验证码" rightPlace:@"请输入验证码"];
        _verificationText.image = [UIImage imageNamed:@"input_textfield_1"];
    }
    return _verificationText;
}

- (InputTextField *)passwordText {
    if (_passwordText == nil) {
        _passwordText = [[InputTextField alloc] initWithLeftLabel:@"密码" rightPlace:@"请设置新登录密码"];
        _passwordText.rightTextField.secureTextEntry = YES;
        _passwordText.image = [UIImage imageNamed:@"input_textfield_2"];
    }
    return _passwordText;
}

- (UIButton *)retransmitBtn {
    if (_retransmitBtn == nil) {
        _retransmitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 72, 35)];
        [_retransmitBtn setBackgroundImage:[UIImage imageNamed:@"retrans"] forState:UIControlStateNormal];
        [_retransmitBtn setTitle:@"重发" forState:UIControlStateNormal];
        _retransmitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_retransmitBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    }
    return  _retransmitBtn;
}

- (UIButton *)finishedBtn {
    if (_finishedBtn == nil) {
        _finishedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 40)];
        [_finishedBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [_finishedBtn setTitle:@"完成" forState:UIControlStateNormal];
        _finishedBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_finishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _finishedBtn;
}

- (UILabel *)hintLabel {
    if (_hintLabel == nil) {
        _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 14)];
        _hintLabel.font = [UIFont systemFontOfSize:14.0];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_3];
        _hintLabel.text = [NSString stringWithFormat:@"我们已经给                          发送验证码"];
    }
    return _hintLabel;
}

- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 15)];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        //_phoneLabel.text = @"15295732669";
        _phoneLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_1];
    }
    return _phoneLabel;
}

- (UIImageView *)eyesView {
    if (_eyesView == nil) {
        _eyesView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"eye_open"]];
        //  _eyesView.frame
    }
    return _eyesView;
}
#pragma mark -----初始化UI布局
- (void)setUILayout {
    
    [self.verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(68);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.width.equalTo(self.finishedBtn);
        make.height.equalTo(self.finishedBtn);
    }];
    
    [self.retransmitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.verificationText).offset(-15);
        make.centerY.equalTo(self.verificationText);
    }];
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationText.mas_bottom).offset(0);
        make.left.mas_equalTo(self.verificationText.mas_left);
        make.right.mas_equalTo(self.verificationText.mas_right);
        make.width.equalTo(self.finishedBtn);
        make.height.equalTo(self.finishedBtn);
    }];
    
    [self.eyesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.passwordText).offset(-15-18);
        make.centerY.equalTo(self.passwordText);
    }];
    
    [self.finishedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordText).offset(20+40);
        make.left.equalTo(self.verificationText);
        make.right.equalTo(self.verificationText);
    }];
    
}

#pragma mark ----------输入框验证
- (void)validateFinishedBtn {
    
    RAC(self.finishedBtn,enabled) = [RACSignal combineLatest:@[self.passwordText.rightTextField.rac_textSignal,self.verificationText.rightTextField.rac_textSignal] reduce:^id(NSString *password, NSString *verification){
        return @([Validate validatePassword:password] && [Validate validateVerification:verification]);
    }];
    
}

- (void)validatePasswordText {
    
    @weakify(self)
    [[self.passwordText.rightTextField.rac_textSignal map:^id(NSString *pass) {
        return @([Validate validatePassword:pass]);
    }]subscribeNext:^(NSNumber *correct) {
        @strongify(self)
        if ([correct  isEqual: @1]) {
            self.eyesView.image = [UIImage imageNamed:@"eye_close"];
        }else {
            self.eyesView.image = [UIImage imageNamed:@"eye_open"];
        }
    }];
    
}

#pragma mark 所有按钮的的action
- (void) setAllAction {
    [self.retransmitBtn addTarget:self action:@selector(setCountDownTimer) forControlEvents:UIControlEventTouchUpInside];
}

//一下重发按钮的事件处理函数
- (void)setCountDownTimer {
    
    [self unableFinishedBtn];
    
    _countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_countDownTimer forMode:NSDefaultRunLoopMode];
    
}

- (void)enableFinishedBtn {
    
    self.retransmitBtn.enabled = YES;
    [_retransmitBtn setTitle:@"重发" forState:UIControlStateNormal];
    [self.retransmitBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [self removeHintLabel];
}

- (void)unableFinishedBtn {
    
    self.retransmitBtn.enabled = NO;
    _timeCount = COUNT_DOWN_TIME;
    [self.retransmitBtn setTitle:[NSString stringWithFormat:@"%d秒",_timeCount] forState:UIControlStateNormal];
    [self.retransmitBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_4] forState:UIControlStateNormal];
    [self dispalyHintLabel];
}

- (void)countDown {
    
    _timeCount --;
    
    [self.retransmitBtn setTitle:[NSString stringWithFormat:@"%d秒",_timeCount] forState:UIControlStateNormal];
    
    if (_timeCount == 0) {
        [_countDownTimer invalidate];
        [self enableFinishedBtn];
    }
    
}

//导航栏返回按钮事件
- (void)backToRegister {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) dispalyHintLabel {
    
    [self.view addSubview:self.hintLabel];
    [self.view addSubview:self.phoneLabel];
    self.phoneLabel.text = self.phone;
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(25);
        make.centerX.equalTo(self.view);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hintLabel);
        make.left.equalTo(self.hintLabel).offset(71);
    }];
}

- (void)removeHintLabel {
    [self.hintLabel removeFromSuperview];
    [self.phoneLabel removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.verificationText];
    [self.view addSubview:self.passwordText];
    [self.verificationText addSubview:self.retransmitBtn];
    [self.passwordText addSubview:self.eyesView];
    [self.view addSubview:self.finishedBtn];
    
    [self setUILayout];
    [self setAllAction];
    [self validatePasswordText];
    [self validateFinishedBtn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"重置密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nva_con"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRegister)];
    //去除导航栏下的一条横线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
