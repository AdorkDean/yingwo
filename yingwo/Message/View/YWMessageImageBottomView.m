//
//  YWMessageImageBottomView.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWMessageImageBottomView.h"

@implementation YWMessageImageBottomView

- (instancetype)init {
    
    if (self = [super init]) {
        
        self.backgroundColor = [ UIColor colorWithHexString:BACKGROUND_COLOR];
        [self createSubview];
    }
    return self;
}

- (void)createSubview {
    
    _username                = [[UILabel alloc] init];
    _content                 = [[YWContentLabel alloc] initWithFrame:CGRectZero];
    _leftImageView           = [[UIImageView alloc] init];

    _username.textColor      = [UIColor colorWithHexString:THEME_COLOR_1];
    _username.font           = [UIFont systemFontOfSize:14];

    _content.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
    _content.numberOfLines   = 4;

    [self addSubview:_content];
    [self addSubview:_username];
    [self addSubview:_leftImageView];

    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.height.width.equalTo(@100);
    }];
    
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right).offset(2.5);
        make.top.equalTo(_leftImageView);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right);
        make.top.height.equalTo(_leftImageView);
        make.right.equalTo(self);
    }];
    
}

@end
