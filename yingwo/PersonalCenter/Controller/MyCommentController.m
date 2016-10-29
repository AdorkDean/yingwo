//
//  MyCommentController.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/25.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyCommentController.h"

@interface MyCommentController ()

@end

@implementation MyCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"我的评论";
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(backToPersonCenterView)];
    
    
}



//返回个人中心界面
- (void)backToPersonCenterView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
