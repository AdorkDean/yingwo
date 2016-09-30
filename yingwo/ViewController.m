//
//  ViewController.m
//  yingwo
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ViewController.h"
#import "YWCommentView.h"
#import "YWCommentReplyView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YWCommentView *commentView = [[YWCommentView alloc] init];
//    commentView.identfier = nil;
//    commentView.rightName = nil;
    [self.view addSubview:commentView];
    
    commentView.leftName.text = @"myyu";
    commentView.content.text = @"3333";
    commentView.backgroundColor = [UIColor greenColor];
    
    [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
