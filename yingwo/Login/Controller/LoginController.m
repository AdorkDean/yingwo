//
//  LoginController.m
//  yingwo
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "LoginController.h"
#import "InputTextField.h"
#import "RegisterController.h"
#import "LoginModel.h"

#import "Test.h"

@interface LoginController ()

@property (nonatomic, strong) UIImageView    *headImage;
@property (nonatomic, strong) InputTextField *phoneText;
@property (nonatomic, strong) InputTextField *passwordText;
@property (nonatomic, strong) UIButton       *loginBtn;
@property (nonatomic, strong) UIButton       *registerBtn;
@property (nonatomic, strong) UIButton       *forgetBtn;
@property (nonatomic, strong) LoginModel     *model;
@property (nonatomic, strong) MBProgressHUD  *hud;
@end

@implementation LoginController

#define mark -------懒加载
- (UIImageView *)headImage {
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        _headImage.frame = CGRectMake(0, 0, 140, 140);
    }
    return _headImage;
}

- (InputTextField *)phoneText {
    if (_phoneText == nil) {
        _phoneText = [[InputTextField alloc] initWithLeftLabel:@"手机号" rightPlace:@"请输入手机号"];
        _phoneText.image = [UIImage imageNamed:@"input_textfield_1"];
    }
    return _phoneText;
}

- (InputTextField *)passwordText {
    if (_passwordText == nil) {
        _passwordText = [[InputTextField alloc] initWithLeftLabel:@"密码" rightPlace:@"请输入密码"];
        _passwordText.rightTextField.secureTextEntry = YES;
        _passwordText.image = [UIImage imageNamed:@"input_textfield_2"];
    }
    return _passwordText;
}

- (UIButton *)loginBtn {
    
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width-30, 40)];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_loginBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    }
    return  _loginBtn;
}

- (UIButton *)registerBtn {
    
    if (_registerBtn == nil) {
        _registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_registerBtn setTitle:@"我要注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_4] forState:UIControlStateNormal];
        
    }
    return _registerBtn;
}

- (UIButton *)forgetBtn {
    if (_forgetBtn == nil) {
        _forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
        _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_4] forState:UIControlStateNormal];
        
    }
    return _forgetBtn;
}

- (LoginModel *)model {
    if (_model == nil) {
        _model = [[LoginModel alloc] init];
    }
    return _model;
}

- (MBProgressHUD *)hud {
    if (_hud == nil) {
        _hud = [MBProgressHUD showActivityIndicatorToView:self.view animated:YES];
    }
    return _hud;
}

#pragma mark -----初始化UI布局
- (void)setUILayout {
    
    //UI 布局
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(62);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
   
    
    [self.phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImage.mas_bottom).offset(40);
        make.height.equalTo(self.loginBtn);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneText.mas_bottom).offset(-0.3); //这里理论上应该是0
        make.height.equalTo(self.phoneText);
        make.left.mas_equalTo(self.phoneText.mas_left);
        make.right.mas_equalTo(self.phoneText.mas_right);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.passwordText.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];

    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.loginBtn.mas_left);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(20);
    }];
    
    [self.forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.loginBtn.mas_right);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(20);
    }];
    
}

#pragma mark ----------输入框验证
- (void)validateFinishedBtn {
    
    RAC(self.loginBtn,enabled) = [RACSignal combineLatest:@[self.phoneText.rightTextField.rac_textSignal,self.passwordText.rightTextField.rac_textSignal] reduce:^id(NSString *phoneText, NSString *passwordText){
        return @([Validate validateMobile:phoneText] && [Validate validatePassword:passwordText]);
    }];

}

#pragma mark 所有按钮的的action
- (void) setAllAction {
    [self.registerBtn addTarget:self action:@selector(jumpToRegisterPage) forControlEvents:UIControlEventTouchUpInside];
    [self.forgetBtn addTarget:self action:@selector(jumpToForgetPage) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn addTarget:self action:@selector(sendLoginRequest) forControlEvents:UIControlEventTouchUpInside];

}

/**
 *  segue跳转
 */
- (void)jumpToRegisterPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_REGISTER sender:self];
}

- (void)jumpToForgetPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_RESET sender:self];
}

- (void)jumpToMainPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_LOGIN sender:self];
}

/**
 *  登录
 */
- (void)sendLoginRequest {
    
    /**
     *  登录参数分为
     *  username
     *  password
     */
    
    [self.view addSubview:self.hud];
    
    NSString *mobile                = self.phoneText.rightTextField.text;
    NSString *password              = self.passwordText.rightTextField.text;

    NSMutableDictionary *paramaters = [NSMutableDictionary dictionary];

    paramaters[MOBILE]              = mobile;
    paramaters[PASSWORD]            = password;
    
    [self requestForLoginWithUrl:LOGIN_URL paramaters:paramaters];
    
}
//登录网路请求
- (void)requestForLoginWithUrl:(NSString *)url paramaters:(id)paramaters {
    
    [self.model requestForLoginWithUrl:url
                            parameters:paramaters
                               success:^(User *user) {
                                   
        if (user != nil) {
            
            //登录成功后保存cookie
            [YWNetworkTools cookiesValueWithKey:LOGIN_COOKIE];
            
            //登录后本地保存数据
            //首先改变face_img的形式
            user.face_img = [NSString selectCorrectUrlWithAppendUrl:user.face_img];
            
            [self saveDataAfterSuccessLogin:user];
            //头像
            [self requestForHeadImageWithUrl:user.face_img];
            
        }else{
            [self.hud hide:YES];
            [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"账号或密码错误" animated:YES afterDelay:1];

        }
//        NSLog(@"%d",log.status);
//        NSLog(@"%@",log.customer.userId);
//        NSLog(@"%@",log.customer.username);

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.hud hide:YES];
        [MBProgressHUD showErrorHUDToAddToView:self.view labelText:@"账号或密码错误" animated:YES afterDelay:1];
    }];
}

/**
 *  下载头像
 *
 *  @param url
 */
- (void)requestForHeadImageWithUrl:(NSString *)url {
    
    if (url.length > 0) {
        
        [self.model requestForHeadImageWithUrl:url];
        
    }
    
    
}

- (void)saveDataAfterSuccessLogin:(User *)user {
    
    //保存用户的个人信息
    [User saveCustomerByUser:user];
    
    //登录信息保存    
    [self saveLoginInfoWith:self.phoneText.rightTextField.text
                   password:self.passwordText.rightTextField.text
                    success:^(int successCode) {
                        
        if (successCode == SUCCESS_STATUS) {
            
            [self.hud hide:YES];
            [SVProgressHUD showSuccessStatus:@"登录成功" afterDelay:HUD_DELAY];
            //跳转
            [self jumpToMainPage];
        }
    } failure:^(int errorCode) {
        
        NSLog(@"login is failure");
        [self.hud hide:YES];
    }];
    
}

/**
 *  登录信息保存
 *
 *  @param phone    登录手机号
 *  @param password 登录密码
 *  @param success  成功后的回调
 */
- (void)saveLoginInfoWith:(NSString *)phone
                 password:(NSString *)password
                  success:(void (^)(int successCode))success
                  failure:(void (^)(int errorCode))failure{
    
    BOOL isSave = [User saveLoginInformationWithUsernmae:phone password:password];
    if (isSave) {
        success(SUCCESS_STATUS);
    }
    failure(FAILURE_STATUS);
}

//初始化登录信息
- (void)initLoginInformation {
    
    if ([User haveExistedLoginInformation]) {
        
        self.phoneText.rightTextField.text    = [User getUsername];
        self.passwordText.rightTextField.text = [User getPasswoord];
        [self jumpToMainPage];
        
    }else {
        
        self.phoneText.rightTextField.text    = @"";
        self.passwordText.rightTextField.text = @"";
       
        [self validateFinishedBtn];

    }
}



#pragma mark 点击屏幕收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (![self.phoneText.rightTextField isExclusiveTouch] && ![self.passwordText.rightTextField isExclusiveTouch]) {
        [self.phoneText.rightTextField resignFirstResponder];
        [self.passwordText.rightTextField resignFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initLoginInformation];
    
    [self.view addSubview:self.headImage];
    [self.view addSubview:self.phoneText];
    [self.view addSubview:self.passwordText];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.forgetBtn];
    
    [self setUILayout];
    
  //  [User saveLoginInformationWithUsernmae:@"15295732669" password:@"123456"];
    
    NSLog(@"%@",NSHomeDirectory());

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self setAllAction];
    [self stopSystemPopGestureRecognizer];
}

#pragma mark 禁止pop手势
- (void)stopSystemPopGestureRecognizer {
    self.fd_interactivePopDisabled = YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFY_REGISTER]) {
        if ([segue.destinationViewController isKindOfClass:[RegisterController class]]) {
            
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
