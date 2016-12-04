//
//  YWMessageTopView.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWMessageTopView.h"

@implementation YWMessageTopView

- (instancetype)init {
    
    if (self = [super init]) {
        [self createSubview];
    }
    return self;
    
}

- (void)createSubview {
    
    _headImageView                     = [[UIImageView alloc] init];
    _nickname                          = [[UILabel alloc] init];
    _time                              = [[UILabel alloc] init];
    _deleteBtn                         = [[UIButton alloc] init];
    
    _headImageView.image               = [UIImage imageNamed:@"touxiang"];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius  = 20;

    _nickname.font                     = [UIFont systemFontOfSize:12];
    _time.font                         = [UIFont systemFontOfSize:10];

    _nickname.textColor                = [UIColor colorWithHexString:THEME_COLOR_2];
    _time.textColor                    = [UIColor colorWithHexString:THEME_COLOR_3];
    
    [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];

    [self addSubview:_headImageView];
    [self addSubview:_nickname];
    [self addSubview:_time];
    [self addSubview:_deleteBtn];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(5);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [_nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(7.5);
        make.centerY.equalTo(_headImageView.mas_centerY).offset(-7.5);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickname.mas_left);
        make.top.equalTo(_nickname.mas_bottom).offset(7.5);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.height.equalTo(@20);
    }];

}

@end
