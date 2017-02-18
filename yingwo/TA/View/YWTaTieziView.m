//
//  YWTaTieziView.m
//  yingwo
//
//  Created by apple on 2017/2/18.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWTaTieziView.h"

@implementation YWTaTieziView

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self createSubview];
    }
    return self;
    
}

- (void)createSubview {

    self.backgroundColor    = [UIColor whiteColor];
    self.layer.cornerRadius = 5;
    
    _leftLabel           = [[UILabel alloc] init];
    _rightImageView      = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Row"]];

    _leftLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_4];
    _leftLabel.font      = [UIFont systemFontOfSize:14];
    
    _leftLabel.text = @"TA的贴子";
    
    [self addSubview:_leftLabel];
    [self addSubview:_rightImageView];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top).offset(10);
    }];
}

@end
