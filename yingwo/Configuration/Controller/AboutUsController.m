//
//  AboutUsController.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController ()

@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UILabel     *versionLabel;
@property (nonatomic, strong) UILabel     *copyrightLabel;

@end

@implementation AboutUsController

#define mark - 懒加载
-(UIImageView *)logoView {
    if (_logoView == nil) {
        _logoView                           = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_logo"]];
        _logoView.frame                     = CGRectMake(0, 0, 100, 100);
        _logoView.layer.masksToBounds       = YES;
        _logoView.layer.cornerRadius        = 10;
    }
    return _logoView;
}

-(UILabel *)versionLabel {
    if (_versionLabel == nil) {
        _versionLabel                       = [[UILabel alloc] init];
        _versionLabel.frame                 = CGRectMake(0, 0, 0, 0);
        _versionLabel.font                  = [UIFont systemFontOfSize:15];
        _versionLabel.textColor             = [UIColor colorWithHexString:@"#505050"];
        _versionLabel.textAlignment         = NSTextAlignmentCenter;
        _versionLabel.text                  = @"应我校园 V0.8.8";

    }
    return _versionLabel;
}

-(UILabel *)copyrightLabel {
    if (_copyrightLabel == nil) {
        _copyrightLabel                     = [[UILabel alloc] init];
        _copyrightLabel.frame               = CGRectMake(0, 0, 0, 0);
        _copyrightLabel.font                = [UIFont systemFontOfSize:13];
        _copyrightLabel.textColor           = [UIColor colorWithHexString:THEME_COLOR_3];
        _copyrightLabel.textAlignment       = NSTextAlignmentCenter;
        _copyrightLabel.text                = @"Copyright © 2016-2017 应我校园. All rights reserved.";
        _copyrightLabel.numberOfLines       = 2;

    }
    return _copyrightLabel;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title               = @"关于我们";
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(backToConfigurationView)];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.logoView];
    [self.view addSubview:self.versionLabel];
    [self.view addSubview:self.copyrightLabel];
    
    [self setAllUILayout];

}


- (void)setAllUILayout {
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.left.equalTo(self.view.mas_left).offset(150);
//        make.height.equalTo(self.logoView.mas_width);

    }];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
    }];
    
    [self.copyrightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view).offset(-20);

    }];
    
}

- (void)backToConfigurationView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
