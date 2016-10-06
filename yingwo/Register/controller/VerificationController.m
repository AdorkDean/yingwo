//
//  VerificationController.m
//  yingwo
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "VerificationController.h"
#import "RegisterModel.h"
#import "SmsMessage.h"

@interface VerificationController ()

@property (nonatomic, strong ) InputTextField *verificationText;
@property (nonatomic, strong ) InputTextField *passwordText;
@property (nonatomic, strong ) UIButton       *retransmitBtn;
@property (nonatomic, strong ) UIButton       *finishedBtn;
@property (nonatomic, strong ) UIButton       *eyesView;
@property (nonatomic, strong ) UILabel        *hintLabel;
@property (nonatomic, strong ) UILabel        *phoneLabel;
@property (nonatomic, strong ) NSTimer        *countDownTimer;
@property (nonatomic, assign ) int            timeCount;
@property (nonatomic, assign ) BOOL           isOpenEye;

@property (nonatomic, strong) RegisterModel *regisetrModel;
@property (nonatomic, strong) SmsMessage    *sms;

@end


@implementation VerificationController

#define mark -------懒加载
- (InputTextField *)verificationText {
    if (_verificationText == nil) {
        _verificationText = [[InputTextField alloc] initWithLeftLabel:@"验证码" rightPlace:@"请输入验证码"];
        _verificationText.leftLabel.textAlignment = NSTextAlignmentLeft;
        _verificationText.image = [UIImage imageNamed:@"input_textfield_1"];
    }
    return _verificationText;
}

- (InputTextField *)passwordText {
    if (_passwordText == nil) {
        _passwordText = [[InputTextField alloc] initWithLeftLabel:@"密码" rightPlace:@"请设置登录密码，最少6位"];
        _passwordText.rightTextField.secureTextEntry = YES;
        _passwordText.image = [UIImage imageNamed:@"input_textfield_2"];
    }
    return _passwordText;
}

- (UIButton *)retransmitBtn {
    if (_retransmitBtn == nil) {
        _retransmitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_retransmitBtn setBackgroundImage:[UIImage imageNamed:@"retrans"] forState:UIControlStateNormal];
        [_retransmitBtn setTitle:@"重发" forState:UIControlStateNormal];
        _retransmitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_retransmitBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    }
    return  _retransmitBtn;
}

- (UIButton *)finishedBtn {
    if (_finishedBtn == nil) {
        _finishedBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_finishedBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [_finishedBtn setTitle:@"完成" forState:UIControlStateNormal];
        _finishedBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_finishedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _finishedBtn;
}

- (UILabel *)hintLabel {
    if (_hintLabel == nil) {
        _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        _hintLabel.font = [UIFont systemFontOfSize:14.0];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_3];
        _hintLabel.text = [NSString stringWithFormat:@"我们已经给                          发送验证码"];
    }
    return _hintLabel;
}

- (UILabel *)phoneLabel {
    if (_phoneLabel == nil) {
        _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
        //_phoneLabel.text = @"15295732669";
        _phoneLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_1];
    }
    return _phoneLabel;
}

- (UIButton *)eyesView {
    if (_eyesView == nil) {
        _eyesView = [UIButton buttonWithType:UIButtonTypeSystem];
        [_eyesView setBackgroundImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
    }
    return _eyesView;
}


- (RegisterModel *)regisetrModel {
    if (_regisetrModel == nil) {
        _regisetrModel = [[RegisterModel alloc] init];
    }
    return _regisetrModel;
}

- (SmsMessage *)sms {
    if (_sms == nil) {
        _sms = [[SmsMessage alloc] init];
    }
    return _sms;
}

#pragma mark -----初始化UI布局
- (void)setUILayout {
    
    [self.verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(79);
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
        make.height.equalTo(@10);
    }];
    
    [self.finishedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordText.mas_bottom).offset(20);
        make.left.equalTo(self.verificationText);
        make.right.equalTo(self.verificationText);
    }];
    
}

#pragma mark ----------输入框验证
//按钮验证
- (void)validateFinishedBtn {
    
    RAC(self.finishedBtn,enabled) = [RACSignal combineLatest:@[self.passwordText.rightTextField.rac_textSignal,self.verificationText.rightTextField.rac_textSignal] reduce:^id(NSString *password, NSString *verification){
        return @([Validate validateVerification:verification] && [Validate validatePassword:password]);
    }];
    
}

//密码验证
- (void)validatePasswordText {
    
}

#pragma mark 所有按钮的的action
- (void) setAllAction {
    
    [self.retransmitBtn addTarget:self
                           action:@selector(sendSmsRequest)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.finishedBtn addTarget:self
                         action:@selector(finishedRegister)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.eyesView addTarget:self
                      action:@selector(shouldShowPassword)
            forControlEvents:UIControlEventTouchUpInside];

}

/**
 *  触发定时器
 */
- (void)setCountDownTimer {
    
    [self unableFinishedBtn];
    
    _countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:_countDownTimer forMode:NSDefaultRunLoopMode];

}

//重发按钮可点
- (void)enableFinishedBtn {
    
    self.retransmitBtn.enabled = YES;
    [_retransmitBtn setTitle:@"重发" forState:UIControlStateNormal];
    [self.retransmitBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    [self removeHintLabel];
}

//重发按钮不可点
- (void)unableFinishedBtn {
    
    self.retransmitBtn.enabled = NO;
    _timeCount = COUNT_DOWN_TIME;
    [self.retransmitBtn setTitle:[NSString stringWithFormat:@"%d秒",_timeCount] forState:UIControlStateNormal];
    [self.retransmitBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_4] forState:UIControlStateNormal];
    [self dispalyHintLabel];
}

/**
 *  定时器计时  60秒
 */
- (void)countDown {
    
    _timeCount --;
    
    [self.retransmitBtn setTitle:[NSString stringWithFormat:@"%d秒",_timeCount] forState:UIControlStateNormal];
    
    if (_timeCount == 0) {
        [_countDownTimer invalidate];
        [self enableFinishedBtn];
    }
    
}

/**
 *  发送短信验证
 */
- (void)sendSmsRequest {

    NSDictionary *paramaters = @{MOBILE:self.phone};
    [self requestSmsWithUrl:SMS_URL paramaters:paramaters];
    
}

/**
 *  点击注册
 */
- (void)finishedRegister {
    
    //先验证手机号、验证码
    [self checkSMS:self.verificationText.rightTextField.text moblie:self.phone];
}

/**
 *  短信验证请求
 *
 *  @param url        关键url
 *  @param paramaters 参数
 */
- (void)requestSmsWithUrl:(NSString *)url paramaters:(id)paramaters {
    
    [self.regisetrModel requestForSMSWithUrl:url paramaters:paramaters success:^(SmsMessage *sms) {
      
        if (sms.status == YES) {
            //开启定时器
            [self setCountDownTimer];
            
        }else if(sms.status == NO){
            
            [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"验证码获取失败" animated:YES afterDelay:2];
        }else {
            [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"请查看网络" animated:YES afterDelay:2];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"请查看网络" animated:YES afterDelay:0.7];

    }];
    
}

/**
 *  短信验证
 *
 *  @param sms    验证码
 *  @param mobile 手机号
 */
- (void)checkSMS:(NSString *)sms moblie:(NSString *)mobile{
    
    NSDictionary *paramaters = @{SMS_CODE:sms,MOBILE:self.phone};
    
    [self.regisetrModel requestSMSForCheckMobleWithUrl:SMS_CHECK
                                            paramaters:paramaters
                                               success:^(SmsMessage *sms) {
                                                   
                                                   if (sms.status == YES) {
                                                       //验证码正确
                                                       //完成注册
                                                       [self requestForRegister];
                                                       
                                                   }else if (sms.status == NO) {
                                                       //验证码错误
                                                       [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"验证码输入错误" animated:YES afterDelay:1.5];
                                                       
                                                   }
                                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                   [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"网络错误" animated:YES afterDelay:1];
                                               }];
}

/**
 *  完成注册
 */
- (void)requestForRegister {
    
    NSDictionary *paramaters = @{PASSWORD:self.passwordText.rightTextField.text,MOBILE:self.phone};
    
    [self.regisetrModel requestForRegisterWithUrl:REGISTER_URL
                                       parameters:paramaters
                                          success:^(Register *reg) {
                                              
                                              if (reg.status == YES) {
                                                  //保存cookie,注册后服务器自动登录一次
                                                  [YWNetworkTools cookiesValueWithKey:LOGIN_COOKIE];
                                                  //保存注册的手机号和密码
                                                  [User saveLoginInformationWithUsernmae:self.phone
                                                                                password:self.passwordText.rightTextField.text];
                                                  
                                                  
                                                  [SVProgressHUD showSuccessStatus:@"注册成功,请完善信息"
                                                                        afterDelay:HUD_DELAY];
                                                  
                                                  //注册成功后跳转到完善信息页面
                                                  [self jumpToPerfectInfoPage];
                                                  
                                              }else if (reg.status == NO) {
                                                  
                                                  [SVProgressHUD showErrorStatus:@"注册失败"
                                                                      afterDelay:HUD_DELAY];
                                                  
                                              }
                                          } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                              NSLog(@"error:%@",error);
                                              
                                              [SVProgressHUD showErrorStatus:@"注册失败,请检查网络"
                                                                  afterDelay:HUD_DELAY];
                                              
                                          }];
}

//密码查看
- (void)shouldShowPassword {
    if (_isOpenEye) {
        [self.eyesView setBackgroundImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
        self.passwordText.rightTextField.secureTextEntry = YES;
        _isOpenEye = NO;
    }else {
        [self.eyesView setBackgroundImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateNormal];
        self.passwordText.rightTextField.secureTextEntry = NO;
        _isOpenEye = YES;
    }
}

//密码合法性检测
- (BOOL)checkPasswordIsReasonable {
    if ([Validate validatePassword:self.passwordText.rightTextField.text]) {
        return YES;
    }else {
        return NO;
    }
}

//跳转到完善信息
- (void)jumpToPerfectInfoPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_PERFECTINFO sender:self];
}

//导航栏返回按钮事件
- (void)backToRegister {
    if ([self checkPasswordIsReasonable]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [MBProgressHUD showHUDToAddToView:self.view labelText:@"密码格式不正确" animated:YES afterDelay:3 success:^{
            
        }];
    }
}

/**
 *  显示提示信息，如验证码已发送给152xxxxx32669
 */
- (void)dispalyHintLabel {
    
    [self.view addSubview:self.hintLabel];
    [self.view addSubview:self.phoneLabel];
    self.phoneLabel.text = self.phone;
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(40);
        make.centerX.equalTo(self.view);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hintLabel);
        make.left.equalTo(self.hintLabel).offset(71);
    }];
}

/**
 *  移除提示信息
 */
- (void)removeHintLabel {
    [self.hintLabel removeFromSuperview];
    [self.phoneLabel removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.verificationText];
    [self.view addSubview:self.passwordText];
    [self.view addSubview:self.retransmitBtn];
    [self.view addSubview:self.eyesView];
    [self.view addSubview:self.finishedBtn];

    [self setUILayout];
    [self setAllAction];
    [self validatePasswordText];
    [self validateFinishedBtn];
    [self dispalyHintLabel];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initNavigationBar];
    [self sendSmsRequest];  //进入页面后直接发送验证码
}

/**
 *  初始化导航栏3
 */
- (void)initNavigationBar {
    self.title = @"注册";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nva_con"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRegister2)];
    //去除导航栏下的一条横线
    [self.navigationController.navigationBar hideNavigationBarBottomLine];
}

//导航栏返回按钮事件
- (void)backToRegister2 {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
