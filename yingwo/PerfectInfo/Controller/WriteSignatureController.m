//
//  WriteSignatureController.m
//  yingwo
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "WriteSignatureController.h"
#import "InputTextField.h"
#import "PerfectInfoController.h"

@interface WriteSignatureController ()

@property (nonatomic, strong) InputTextField  *inputSignatureText;
@property (nonatomic, strong) UIButton        *deleteBtn;
@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;

@end

@implementation WriteSignatureController

#pragma mark ----------懒加载

- (InputTextField *)inputSignatureText {
    if (_inputSignatureText == nil) {
        _inputSignatureText = [[InputTextField alloc] initWithLeftLabel:@"请输入您的个性签名"];
    }
    return _inputSignatureText;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (UIBarButtonItem *)rightButtonItem {
    if (_rightButtonItem == nil) {
        _rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hook"] style:UIBarButtonItemStylePlain target:nil action:nil];
        _rightButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hook"] style:UIBarButtonItemStylePlain target:self action:@selector(passValueToBackController)];

    }
    return _rightButtonItem;
}

#pragma mark -------UI布局
- (void)setUILayout {
    
    [self.inputSignatureText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@40);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inputSignatureText.mas_centerY);
        make.right.equalTo(self.inputSignatureText.mas_right).offset(-20);
    }];
    
}

#pragma mark ------------输入监听

- (void)checkToDipalayDeleteBtn {
    
    RAC(self.deleteBtn ,hidden) = [RACSignal combineLatest:@[self.inputSignatureText.rightTextField.rac_textSignal]
                                                    reduce:^id(NSString *nickname){
                                                        return @([nickname  isEqual: @""]);
                                                    }];
}

- (void)checkNickName {
    
    RAC(self.rightButtonItem,enabled) = [RACSignal combineLatest:@[self.inputSignatureText.rightTextField.rac_textSignal] reduce:^id(NSString *nickname){
        return @([Validate validateUserName:nickname]);
    }];
}

#pragma mark ----------AllAction

- (void)setAllAction {
    [self.deleteBtn addTarget:self action:@selector(deleteNickName) forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteNickName {
    self.inputSignatureText.rightTextField.text = @"";
}



#pragma mark  private-method

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)passValueToBackController {
    PerfectInfoController *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    vc.signature = self.inputSignatureText.rightTextField.text;
    [self.navigationController popToViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.inputSignatureText];
    [self.view addSubview:self.deleteBtn];
    
    [self setUILayout];
    [self setAllAction];
    [self checkNickName];
    [self checkToDipalayDeleteBtn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"个性签名";
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nva_con"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
