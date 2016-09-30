//
//  YWTopicHeaderView.m
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTopicHeaderView.h"

@implementation YWTopicHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubview];
        
    }
    return self;
}

- (void)createSubview {
    
    _blurImageView            = [[UIImageView alloc] init];
    _headerView               = [[UIImageView alloc] init];
    _darkView                 = [[UIView alloc] init];
    _topic                    = [[UILabel alloc]init];
    _numberOfTopic            = [[UILabel alloc]init];
    _numberOfFavour           = [[UILabel alloc] init];
    _addTopicBtn              = [[UIButton alloc] init];

    _topic.textColor          = [UIColor whiteColor];
    _numberOfTopic.textColor  = [UIColor whiteColor];
    _numberOfFavour.textColor = [UIColor whiteColor];

    _topic.font               = [UIFont systemFontOfSize:14];
    _numberOfTopic.font       = [UIFont systemFontOfSize:12.0];
    _numberOfFavour.font      = [UIFont systemFontOfSize:12.0];

    _darkView.backgroundColor = [UIColor blackColor];
    _darkView.alpha           = 0.3;
    
    [_addTopicBtn setBackgroundImage:[UIImage imageNamed:@"weiguanzhu"]

                            forState:UIControlStateNormal];
    
    [self addSubview:_blurImageView];
    [_blurImageView addSubview:_darkView];

    [self addSubview:_headerView];
    [self addSubview:_topic];
    [self addSubview:_numberOfTopic];
    [self addSubview:_numberOfFavour];
    [self addSubview:_addTopicBtn];

    [_blurImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(self);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
    }];
    
    [_darkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(self);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
    }];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@90);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_centerY).offset(-20);
    }];
    
    [_topic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
    
    [_numberOfTopic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX);
        make.top.equalTo(_topic.mas_bottom).offset(5);
    }];
    
    [_numberOfFavour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.top.equalTo(_numberOfTopic);
    }];
    
    [_addTopicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_numberOfTopic.mas_bottom).offset(5);
    }];
    
}

@end
