//
//  ViewController.m
//  yingwo
//
//  Created by apple on 16/7/9.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "RegisterController.h"
#import "VerificationController.h"
#import "ClauseViewController.h"
#import "LoginModel.h"
#import "RegisterModel.h"

@interface RegisterController ()

@property (nonatomic, strong) UIImageView    *headImage;
@property (nonatomic, strong) InputTextField *phoneTextFeild;
@property (nonatomic, strong) UIButton       *selectBtn;
@property (nonatomic, strong) UILabel        *instroLabel;
@property (nonatomic, strong) UIButton       *clauseBtn;
@property (nonatomic, strong) UIButton       *nextBtn;
@property (nonatomic, strong) UIButton       *loginBtn;
@property (nonatomic, assign) NSString       *isAgreen;

@property (nonatomic, strong) RegisterModel  *viewModel;
@end


static NSString *agreen = @"同意";
static NSString *notAgreen = @"不同意";

@implementation RegisterController

#pragma mark ----------懒加载
- (UIImageView *)headImage {
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    }
    return _headImage;
}

- (InputTextField *)phoneTextFeild {
    
    if (_phoneTextFeild == nil) {
        _phoneTextFeild = [[InputTextField alloc] initWithLeftLabel:@"手机号" rightPlace:@"请输入手机号"];
    }
    return _phoneTextFeild;
}

- (UIButton *)selectBtn {
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    }
    return _selectBtn;
}

- (UIButton *)clauseBtn {
    if (_clauseBtn == nil) {
        _clauseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_clauseBtn setTitle:@"《应我校园用户协议》" forState:UIControlStateNormal];
        _clauseBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_clauseBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
    }
    return _clauseBtn;
}

- (UILabel *)instroLabel {
    if (_instroLabel == nil) {
        _instroLabel = [[UILabel alloc] init];
        _instroLabel.text = @"我已阅读并同意";
        _instroLabel.textColor = [UIColor blackColor];
        _instroLabel.font = [UIFont systemFontOfSize:12];
    }
    return _instroLabel;
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    }
    return _nextBtn;
}

- (UIButton *)loginBtn {
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginBtn setTitle:@"已有帐号 直接登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_4] forState:UIControlStateNormal];
    }
    return  _loginBtn;
}

- (RegisterModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[RegisterModel alloc] init];
    }
    return _viewModel;
}

#pragma mark -----初始化UI布局
- (void)setUILayout {
    //UI 布局
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(62);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.phoneTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.equalTo(self.nextBtn);  //这里有个bug，若不参考nextBtn，则phoneTextFeild大小会改变
        make.height.equalTo(self.nextBtn); //可能与自定义有关
        make.top.equalTo(self.headImage).offset(80+100);
    }];
    
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneTextFeild).offset(15);
        make.top.equalTo(self.phoneTextFeild).offset(20+40);
    }];
    
    [self.instroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectBtn).offset(15+15);
        make.top.equalTo(self.phoneTextFeild).offset(20+40);
    }];
    
    [self.clauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.instroLabel.mas_right).offset(0);
        make.top.equalTo(self.phoneTextFeild).offset(14+40);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.phoneTextFeild).offset(55+40);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.equalTo(self.nextBtn).offset(20+40);
    }];
}

#pragma mark 所有按钮的的action
- (void) setAllAction {
    [self.nextBtn addTarget:self action:@selector(jumpToVerificationPage) forControlEvents:UIControlEventTouchUpInside];
    [self.selectBtn addTarget:self action:@selector(changeClause) forControlEvents:UIControlEventTouchUpInside];
    [self.loginBtn addTarget:self action:@selector(backToLoginPage) forControlEvents:UIControlEventTouchUpInside];
    [self.clauseBtn addTarget:self action:@selector(jumpToClausePage) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  跳转去用户协议界面
 */
- (void)jumpToClausePage{
    ClauseViewController *setting = [[ClauseViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

/**
 *  跳转去获取短信页面
 */
- (void)jumpToVerificationPage {
    
    NSDictionary *paramaters = @{@"mobile":self.phoneTextFeild.rightTextField.text};
    
    [self.viewModel requestForCheckMobleWithUrl:MOBILE_CHECK_URL
                                     paramaters:paramaters
                                        success:^(StatusEntity *status) {
                                            
                                            if (status.error == 0) {
                                                
                                                [self performSegueWithIdentifier:SEGUE_IDENTIFY_VERFIFCATION
                                                                          sender:self];

                                            }
                                            else if (status.error_code == ERROR_REGISTERED_CODE) {
                                                [SVProgressHUD showErrorStatus:@"手机号已注册"
                                                                    afterDelay:HUD_DELAY];
                                            }
           
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorStatus:@"网络错误" afterDelay:HUD_DELAY];
    }];
    
}

/**
 *  返回登录界面，已有帐号直接登录
 */
- (void)backToLoginPage {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  判断协议是否同意
 */
- (void)changeClause {
    if (self.isAgreen == agreen) {
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"unselect"] forState:UIControlStateNormal];
        self.isAgreen = notAgreen;
    }else {
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
        self.isAgreen = agreen;
    }
}

#pragma mark --------输入验证
- (void)validateNextBtn {

    RAC(self.nextBtn,enabled) = [RACSignal combineLatest:@[self.phoneTextFeild.rightTextField.rac_textSignal,RACObserve(self,isAgreen)]
                                                  reduce:^id(NSString *phone,NSString *agreen){
                                                      return @([Validate validateMobile:phone] && [agreen  isEqual: @"同意"]);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.headImage];
    [self.view addSubview:self.phoneTextFeild];
    [self.view addSubview:self.selectBtn];
    [self.view addSubview:self.instroLabel];
    [self.view addSubview:self.clauseBtn];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.selectBtn];
    [self.view addSubview:self.loginBtn];

    [self setUILayout];
    [self setAllAction];
    [self validateNextBtn];
    //初始化协议为同意
    self.isAgreen = agreen;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

    
}

#pragma mark segue 传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFY_VERFIFCATION]) {
        if ([segue.destinationViewController isKindOfClass:[VerificationController class]]) {
            VerificationController *vc = segue.destinationViewController;
            vc.phone = self.phoneTextFeild.rightTextField.text;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
