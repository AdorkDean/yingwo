//
//  YWTopicViewCell.m
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTopicViewCell.h"

@implementation YWTopicViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createSubview];
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.layer.cornerRadius = 15;
    }
    
    return self;
    
}

- (void)createSubview {
    
    _leftImageView            = [[UIImageView alloc] init];
    _rightBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    _topic                    = [[UILabel alloc] init];
    _numberOfTopic            = [[UILabel alloc] init];
    _numberOfFavour           = [[UILabel alloc] init];

    _topic.font               = [UIFont systemFontOfSize:15];
    _numberOfTopic.font       = [UIFont systemFontOfSize:12];
    _numberOfFavour.font      = [UIFont systemFontOfSize:12];

    _topic.textColor          = [UIColor colorWithHexString:THEME_COLOR_2];
    _numberOfTopic.textColor  = [UIColor colorWithHexString:THEME_COLOR_3];
    _numberOfFavour.textColor = [UIColor colorWithHexString:THEME_COLOR_3];

    _topic.numberOfLines      = 0;
    
//    [_rightBtn setBackgroundImage:[UIImage imageNamed:@"weiguanzhu"]
//                         forState:UIControlStateNormal];
    
    [_rightBtn addTarget:self
                  action:@selector(favorTopic)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_leftImageView];
    [self addSubview:_topic];
    [self addSubview:_numberOfTopic];
    [self addSubview:_numberOfFavour];
    [self addSubview:_rightBtn];
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.height.width.equalTo(@62);
        make.centerY.equalTo(self);
    }];
    
    [_topic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right).offset(10);
        make.width.equalTo(@150);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    [_numberOfTopic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topic.mas_left);
        make.top.equalTo(_topic.mas_bottom).offset(10);
    }];
    
    [_numberOfFavour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberOfTopic.mas_top);
        make.left.equalTo(_numberOfTopic.mas_right).offset(10);
    }];

    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12.5);
    }];
    
}

//关注话题
- (void)favorTopic {
    
}

@end
