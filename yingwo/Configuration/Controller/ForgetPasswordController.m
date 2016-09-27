//
//  ForgetPasswordController.m
//  yingwo
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ForgetPasswordController.h"
#import "InputTextField.h"
#import "ResetPasswordController.h"
@interface ForgetPasswordController ()

@property (nonatomic, strong) InputTextField *phoneTextFeild;
@property (nonatomic, strong) UIButton       *nextBtn;

@end



@implementation ForgetPasswordController

- (InputTextField *)phoneTextFeild {
    
    if (_phoneTextFeild == nil) {
        _phoneTextFeild = [[InputTextField alloc] initWithLeftLabel:@"手机号" rightPlace:@"请输入手机号"];
    }
    return _phoneTextFeild;
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width-30, 40)];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    }
    return _nextBtn;
}

#pragma mark -----初始化UI布局
- (void)setUILayout {
    [self.phoneTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.equalTo(self.nextBtn);  //这里有个bug，若不参考nextBtn，则phoneTextFeild大小会改变
        make.height.equalTo(self.nextBtn); //可能与自定义有关
        make.top.equalTo(self.view).offset(25);
    }];
    
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.phoneTextFeild).offset(40+20);
    }];
}

#pragma mark 所有按钮的的action
- (void) setAllAction {
    [self.nextBtn addTarget:self action:@selector(jumpToVerificationPage) forControlEvents:UIControlEventTouchUpInside];
}

- (void)jumpToVerificationPage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_RESETPASSWORD sender:self];
}

#pragma mark --------输入验证
- (void)validateNextBtn {
    RAC(self.nextBtn,enabled) = [RACSignal combineLatest:@[self.phoneTextFeild.rightTextField.rac_textSignal]
                                                  reduce:^id(NSString *phone){
                                                      return @([Validate validateMobile:phone]);
                                                  }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.phoneTextFeild];
    [self.view addSubview:self.nextBtn];
    
    [self setUILayout];
    [self setAllAction];
    [self validateNextBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"重置密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nva_con"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRegister)];
    //去除导航栏下的一条横线
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

//导航栏返回按钮事件
- (void)backToRegister {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark segue 传值
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_IDENTIFY_RESETPASSWORD]) {
        if ([segue.destinationViewController isKindOfClass:[ResetPasswordController class]]) {
            ResetPasswordController *vc = segue.destinationViewController;
            vc.phone = self.phoneTextFeild.rightTextField.text;
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
