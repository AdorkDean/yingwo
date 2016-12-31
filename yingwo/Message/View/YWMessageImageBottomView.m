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
    
    _username                       = [[UILabel alloc] init];
    _content                        = [[YWContentLabel alloc] initWithFrame:CGRectZero];
    _leftImageView                  = [[UIImageView alloc] init];

    _username.textColor             = [UIColor colorWithHexString:THEME_COLOR_1];
    _username.font                  = [UIFont systemFontOfSize:13];
    _content.backgroundColor        = [UIColor colorWithHexString:BACKGROUND_COLOR];
//    _content.textColor            = [UIColor colorWithHexString:THEME_COLOR_4];
    _content.numberOfLines          = 4;
    _content.font                   = [UIFont systemFontOfSize:13];
    
    _leftImageView.clipsToBounds    = YES;
    _leftImageView.contentMode      = UIViewContentModeScaleAspectFill;

    [self addSubview:_content];
    [self addSubview:_username];
    [self addSubview:_leftImageView];

    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.height.width.equalTo(@100);
    }];
    
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right).offset(5);
        make.top.equalTo(_leftImageView).offset(2);
        make.height.equalTo(@16);
    }];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right).offset(5);
        make.top.equalTo(_username.mas_bottom).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.right.equalTo(self.mas_right).offset(-5);
    }];
    
}

@end
