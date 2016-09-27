//
//  YWTopicListView.m
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTopicListView.h"

@implementation YWTopicListView

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self setBackgroundColor:[UIColor colorWithHexString:THEME_COLOR_4 alpha:0.2]];
        [self createSubview];
        _leftImageView.layer.cornerRadius = 5;
    }
    return self;
}

- (void)createSubview {
    
    _leftImageView            = [[UIImageView alloc] init];
    _topic                    = [[UILabel alloc] init];
    _numberOfTopic            = [[UILabel alloc] init];
    _numberOfFavour           = [[UILabel alloc] init];

    _topic.font               = [UIFont systemFontOfSize:14];
    _numberOfTopic.font       = [UIFont systemFontOfSize:10];
    _numberOfFavour.font      = [UIFont systemFontOfSize:10];

    _topic.textColor          = [UIColor colorWithHexString:THEME_COLOR_2];
    _numberOfTopic.textColor  = [UIColor colorWithHexString:THEME_COLOR_3];
    _numberOfFavour.textColor = [UIColor colorWithHexString:THEME_COLOR_3];

    [self addSubview:_leftImageView];
    [self addSubview:_topic];
    [self addSubview:_numberOfTopic];
    [self addSubview:_numberOfFavour];

    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.height.width.equalTo(@39);
        make.centerY.equalTo(self);
    }];
    
    [_topic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(9);
    }];
    
    [_numberOfTopic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topic.mas_left);
        make.top.equalTo(_topic.mas_bottom).offset(3);
    }];
    
    [_numberOfFavour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberOfTopic.mas_top);
        make.left.equalTo(_numberOfTopic.mas_right).offset(10);
    }];
    
}

@end
