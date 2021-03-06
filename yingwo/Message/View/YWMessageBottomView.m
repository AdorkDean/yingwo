//
//  YWMessageBottomView.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWMessageBottomView.h"

@implementation YWMessageBottomView

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

    _username.textColor      = [UIColor colorWithHexString:THEME_COLOR_1];
    _username.font           = [UIFont systemFontOfSize:13];

    _content.numberOfLines   = 1;
    _content.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
//    _content.textColor       = [UIColor colorWithHexString:THEME_COLOR_4];

    [self addSubview:_content];
    [self addSubview:_username];

    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [_content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_username.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
        
}

@end
