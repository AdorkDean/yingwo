//
//  BaseViewController.m
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(backToFarword)];
    }
    return _leftBarItem;
}

- (void)createSubviews {
    
}

- (void)layoutSubviews {
    
}

- (void)addAction {
    
}

- (void)initDataSourceBlock {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    [self createSubviews];
    [self layoutSubviews];
    [self initDataSourceBlock];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addAction];
    
    [YWNetworkTools networkStauts];

}

- (void)backToFarword {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
