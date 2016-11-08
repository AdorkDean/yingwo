//
//  YWTaTopicListView.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTaTopicListView.h"

@implementation YWTaTopicListView

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self createSubview];
        _topicImageView.layer.masksToBounds = YES;
        _topicImageView.layer.cornerRadius = 5;
    }
    return self;
}


- (void)createSubview {

    _topicImageView                 = [[UIImageView alloc] init];
    _topic                          = [[UILabel alloc] init];
    
    _topic.font                     = [UIFont systemFontOfSize:14.0];
    _topic.textColor                = [UIColor colorWithHexString:THEME_COLOR_2];
    _topic.textAlignment            = NSTextAlignmentCenter;

    [self addSubview:_topicImageView];
    [self addSubview:_topic];
    
    [_topicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
        make.top.equalTo(self).offset(2);
        make.height.equalTo(self.mas_width);
//        make.bottom.equalTo(self).offset(-19);
    }];
    
    [_topic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topicImageView.mas_bottom).offset(5);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self);
    }];
    
}

@end
