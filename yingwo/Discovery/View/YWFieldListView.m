//
//  YWFieldListView.m
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWFieldListView.h"

@implementation YWFieldListView

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview {
    
    _leftImageView        = [[UIImageView alloc] init];
    _rightImageView       = [[UIImageView alloc] init];
    _subject              = [[UILabel alloc] init];

    _subject.font         = [UIFont systemFontOfSize:15];
    _subject.textColor    = [UIColor colorWithHexString:THEME_COLOR_2];

    _rightImageView.image = [UIImage imageNamed:@"Row"];

    _rightImageView.contentMode = UIViewContentModeScaleAspectFit;

    [self addSubview:_leftImageView];
    [self addSubview:_rightImageView];
    [self addSubview:_subject];
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self);
        make.height.width.equalTo(@25);
    }];
    
    [_subject mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right).offset(7.5);
        make.centerY.equalTo(self);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-7.5);
        make.centerY.equalTo(self);
    }];
    
}

@end
