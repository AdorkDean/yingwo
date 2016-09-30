//
//  BaseInfoController.m
//  yingwo
//
//  Created by apple on 16/7/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseInfoController.h"

@interface BaseInfoController ()

@property (nonatomic, strong) YWInputButton *signatureText;
@property (nonatomic, strong) YWInputButton *nicknameText;
@property (nonatomic, strong) YWInputButton *sexText;
@property (nonatomic, strong) YWInputButton *schoolText;
@property (nonatomic, strong) YWInputButton *academyText;
@property (nonatomic, strong) YWInputButton *gradeText;
@property (nonatomic, strong) UIButton       *male;
@property (nonatomic, strong) UIButton       *female;

@property (nonatomic, strong)Customer *user;

@end

@implementation BaseInfoController


- (YWInputButton *)signatureText {
    
    if (_signatureText == nil) {
        _signatureText = [[YWInputButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                    leftLabel:@"个性签名"
                                                  centerLabel:self.user.signature];
        [_signatureText setBackgroundImage:[UIImage imageNamed:@"input_text"]
                                  forState:UIControlStateNormal];
        [_signatureText showRightView];
    }
    return _signatureText;
}

- (YWInputButton *)nicknameText {
    
    if (_nicknameText == nil) {
        _nicknameText = [[YWInputButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                   leftLabel:@"昵称"
                                                 centerLabel:self.user.name];
        [_nicknameText setBackgroundImage:[UIImage imageNamed:@"input_top"]
                                 forState:UIControlStateNormal];
        [_nicknameText showRightView];
    }
    return _nicknameText;
}

- (YWInputButton *)sexText {
    
    if (_sexText == nil) {
        _sexText = [[YWInputButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                              leftLabel:@"性别"
                                            centerLabel:@""];
        
        [_sexText setBackgroundImage:[UIImage imageNamed:@"input_mid"]
                            forState:UIControlStateNormal];
    }
    return _sexText;
}

- (YWInputButton *)schoolText {
    
    if (_schoolText == nil) {
        _schoolText = [[YWInputButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                 leftLabel:@"学校"
                                               centerLabel:self.user.school_name];
        [_schoolText setBackgroundImage:[UIImage imageNamed:@"input_mid"]
                               forState:UIControlStateNormal];
        [_schoolText showRightView];
    }
    return _schoolText;
}

- (YWInputButton *)academyText {
    
    if (_academyText == nil) {
        _academyText = [[YWInputButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                  leftLabel:@"学院"
                                                centerLabel:self.user.academy_name];
        [_academyText setBackgroundImage:[UIImage imageNamed:@"input_mid"]
                                forState:UIControlStateNormal];
        [_academyText showRightView];
    }
    return _academyText;
}

- (YWInputButton *)gradeText {
    
    if (_gradeText == nil) {
        _gradeText = [[YWInputButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                leftLabel:@"年级"
                                              centerLabel:self.user.grade];
        [_gradeText setBackgroundImage:[UIImage imageNamed:@"input_col"]
                              forState:UIControlStateNormal];
    }
    return _gradeText;
}

- (UIButton *)male {
    if (_male == nil) {
        _male = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_male setBackgroundImage:[UIImage imageNamed:@"male-show"]
                         forState:UIControlStateNormal];
    }
    return _male;
}

- (UIButton *)female {
    if (_female == nil) {
        _female = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_female setBackgroundImage:[UIImage imageNamed:@"female-hide"]
                           forState:UIControlStateNormal];
    }
    return _female;
}

- (Customer *)user {
    if (_user == nil) {
        _user = [User findCustomer];
    }
    return _user;
}

#pragma mark -----初始化UI布局,布局约束

- (void)setUILayout {
    
    [self.signatureText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    
    [self.nicknameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signatureText.mas_bottom).offset(15);
        make.left.mas_equalTo(self.signatureText.mas_left);
        make.right.mas_equalTo(self.signatureText.mas_right);
    }];
    
    [self.sexText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nicknameText.mas_bottom);
        make.left.mas_equalTo(self.signatureText.mas_left);
        make.right.mas_equalTo(self.signatureText.mas_right);
    }];
    
    [self.schoolText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.sexText.mas_bottom);
        make.left.mas_equalTo(self.signatureText.mas_left);
        make.right.mas_equalTo(self.signatureText.mas_right);
    }];
    
    [self.academyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.schoolText.mas_bottom);
        make.left.mas_equalTo(self.signatureText.mas_left);
        make.right.mas_equalTo(self.signatureText.mas_right);
    }];
    
    [self.gradeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.academyText.mas_bottom);
        make.left.mas_equalTo(self.signatureText.mas_left);
        make.right.mas_equalTo(self.signatureText.mas_right);
    }];
    
    [self.male mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexText);
        make.centerX.equalTo(self.sexText.mas_centerX).offset(-18);
    }];
    
    [self.female mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sexText);
        make.centerX.equalTo(self.sexText.mas_centerX).offset(18);
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.signatureText];
    [self.view addSubview:self.nicknameText];
    [self.view addSubview:self.sexText];
    [self.view addSubview:self.schoolText];
    [self.view addSubview:self.academyText];
    [self.view addSubview:self.gradeText];
    [self.view addSubview:self.male];
    [self.view addSubview:self.female];
    
    [self setUILayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"基本资料";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc ]
                                             initWithImage:[UIImage imageNamed:@"nva_con"]
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(back)];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//action跳转
- (void)jumpToWriteSignaturePage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_WRITESIGNATURE sender:self];
}

- (void)jumpToWirteNicknamePage {
    [self performSegueWithIdentifier:SEGUE_IDENTIFY_WRITENICKNAME sender:self];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
