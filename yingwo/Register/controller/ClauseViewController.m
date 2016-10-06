//
//  ClauseViewController.m
//  yingwo
//
//  Created by 王世杰 on 2016/9/23.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ClauseViewController.h"

@interface ClauseViewController ()

@end

@implementation ClauseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setClause];
}

//设定用户协议界面及属性
- (void)setClause
{
    self.view.backgroundColor   = [UIColor colorWithHexString:BACKGROUND_COLOR];
    
    CGRect clauseViewFrame      = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
    UITextView *clauseView      = [[UITextView alloc] initWithFrame:clauseViewFrame];
    
    //设置用户协议文件
    clauseView.text             = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]                   pathForResource:@"YingwoUserClause" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    
    //协议文字属性
    clauseView.editable         = NO;
    clauseView.font             = [UIFont fontWithName:@"Arial" size:14.5f];
    clauseView.textColor        = [UIColor blackColor];
    clauseView.backgroundColor  = [UIColor colorWithHexString:BACKGROUND_COLOR];
    clauseView.textAlignment    = NSTextAlignmentLeft;
    
    [self.view addSubview:clauseView];

}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationItem.title   = @"应我校园用户协议";
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(backToLastView)];
}

- (void)backToLastView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
