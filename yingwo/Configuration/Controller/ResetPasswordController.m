//
//  ResetPasswordController.m
//  yingwo
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ResetPasswordController.h"
#import "RegisterModel.h"
#import "SmsMessage.h"

@interface ResetPasswordController ()

@property (nonatomic, strong) InputTextField *verificationText;
@property (nonatomic, strong) InputTextField *passwordText;
@property (nonatomic, strong) UIButton       *retransmitBtn;
@property (nonatomic, strong) UIButton       *finishedBtn;
@property (nonatomic, strong) UIButton       *eyesView;
@property (nonatomic, strong) UILabel        *hintLabel;
@property (nonatomic, strong) UILabel        *phoneLabel;
@property (nonatomic, strong) NSTimer        *countDownTimer;
@property (nonatomic,assign ) int            timeCount;
@property (nonatomic, assign) BOOL           isOpenEye;


@property (nonatomic, strong) RegisterModel *regisetrModel;
@property (nonatomic, strong) SmsMessage    *sms;


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
- (void)validateFinishedBtn {
    
    RAC(self.finishedBtn,enabled) = [RACSignal combineLatest:@[self.passwordText.rightTextField.rac_textSignal,self.verificationText.rightTextField.rac_textSignal] reduce:^id(NSString *password, NSString *verification){
        return @([Validate validatePassword:password] && [Validate validateVerification:verification]);
    }];
    
}

- (void)validatePasswordText {
    
//    @weakify(self)
//    [[self.passwordText.rightTextField.rac_textSignal map:^id(NSString *pass) {
//        return @([Validate validatePassword:pass]);
//    }]subscribeNext:^(NSNumber *correct) {
//        @strongify(self)
//        if ([correct  isEqual: @1]) {
//            self.eyesView.image = [UIImage imageNamed:@"eye_close"];
//        }else {
//            self.eyesView.image = [UIImage imageNamed:@"eye_open"];
//        }
//    }];
    
}

#pragma mark 所有按钮的的action
- (void) setAllAction {
    [self.retransmitBtn addTarget:self
                           action:@selector(setCountDownTimer)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.finishedBtn addTarget:self
                         action:@selector(finishedUpdate)
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
 *  除了手机号，还有生成的本地签名
 */
- (void)sendSmsRequest {
    
    long int number = [self getRandomNumber:1000000000 to:9999999999];
    NSString *rn = [NSString stringWithFormat:@"%ld", number];
    
    NSLog(@"%@", rn);
    
    NSString *rnMd5 = [MD5 getMd5WithString:rn];
    
    NSString *signString = [rnMd5 stringByAppendingString:self.phone];
    
    NSString *sign = [MD5 getSha1WithString:signString];
    
    NSLog(@"%@", sign);
    
    NSDictionary *paramaters = @{MOBILE:self.phone,
                                 RN:rn,
                                 SIGN:sign};
    [self requestSmsWithUrl:SMS_URL paramaters:paramaters];

    
}

-(long int)getRandomNumber:(long int)from to:(long int)to
{
    return (long int)(from + (arc4random() % (to - from + 1)));
}

/**
 *  点击完成更新密码
 */
- (void)finishedUpdate {
    
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
                                                       //完成更新密码
                                                       [self requestForUpdate];
                                                       
                                                   }else if (sms.status == NO) {
                                                       //验证码错误
                                                       [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"验证码输入错误" animated:YES afterDelay:1.5];
                                                       
                                                   }
                                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                   [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"网络错误" animated:YES afterDelay:1];
                                               }];
}

/**
 *  完成更新
 */
- (void)requestForUpdate {
    
    NSDictionary *paramaters = @{PASSWORD:self.passwordText.rightTextField.text};
    
    [self.regisetrModel requestForUpdatePwdWithUrl:UPDATE_INFO_URL
                                       parameters:paramaters
                                          success:^(UpdatePwdEntity *update) {
                                              
                                              if (update.status == YES) {
                                                  
                                                  //必须要加载cookie，否则无法请求
                                                  [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
                                                  
                                                  [SVProgressHUD showSuccessStatus:@"密码更新成功，请重新登录。"
                                                                        afterDelay:HUD_DELAY];
                                                  //更新成功后跳转
                                                  [self jumpToLoginPage];
                                              }else if (update.status == NO) {
                                                  [SVProgressHUD showErrorStatus:@"更新失败" afterDelay:HUD_DELAY];
                                              }
                                          } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                              NSLog(@"error:%@",error);
                                              [SVProgressHUD showErrorStatus:@"网络错误" afterDelay:HUD_DELAY];
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

//返回登录页面
- (void)jumpToLoginPage {
    [User deleteCustoer];
    [User deleteLoginInformation];
    LoginController *loginVC  = [self.storyboard instantiateViewControllerWithIdentifier:CONTROLLER_OF_LOGINVC_IDENTIFIER];
    [self.navigationController pushViewController:loginVC animated:YES];
}


//导航栏返回按钮事件
- (void)backToReset {
    [self.navigationController popViewControllerAnimated:YES];
}



/**
 *  显示提示信息，如验证码已发送给152xxxxx32669
 */
- (void) dispalyHintLabel {
    
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
 *  初始化导航栏
 */
- (void)initNavigationBar {
    self.title = @"重置密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nva_con"] style:UIBarButtonItemStylePlain target:self action:@selector(backToReset)];
    //去除导航栏下的一条横线
    [self.navigationController.navigationBar hideNavigationBarBottomLine];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
