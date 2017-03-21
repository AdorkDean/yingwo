//
//  YWPersonCenterMidCell.m
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWPersonCenterMidCell.h"

@implementation YWPersonCenterMidCell

- (instancetype)initWithFriends:(NSString *)friendNum
                     attentions:(NSString *)attentionNum
                           fans:(NSString *)fansNum
                       visitors:(NSString *)visitorNum {
    if (self = [super init]) {
        //因为该cell是UIImageView，所以要设置手势为YES，否则之后的操作都不可用
        self.userInteractionEnabled = YES;
        
        _friends    = [[UILabel alloc] init];
        _attentions = [[UILabel alloc] init];
        _fans       = [[UILabel alloc] init];
        _visitors   = [[UILabel alloc] init];
        
        _friends.font    = [UIFont systemFontOfSize:15];
        _attentions.font = [UIFont systemFontOfSize:15];
        _fans.font       = [UIFont systemFontOfSize:15];
        _visitors.font   = [UIFont systemFontOfSize:15];
        
        _friends.text    = friendNum;
        _attentions.text = attentionNum;
        _fans.text       = fansNum;
        _visitors.text   = visitorNum;
        
        _friends.textColor    = [UIColor colorWithHexString:THEME_COLOR_1];
        _attentions.textColor = [UIColor colorWithHexString:THEME_COLOR_1];
        _fans.textColor       = [UIColor colorWithHexString:THEME_COLOR_1];
        _visitors.textColor   = [UIColor colorWithHexString:THEME_COLOR_1];
        
        _friendLabel         = [[UILabel alloc] init];
        _attentionLabel      = [[UILabel alloc] init];
        _fansLabel           = [[UILabel alloc] init];
        _visitorLabel        = [[UILabel alloc] init];
        
        _friendLabel.font    = [UIFont systemFontOfSize:14];
        _attentionLabel.font = [UIFont systemFontOfSize:14];
        _fansLabel.font      = [UIFont systemFontOfSize:14];
        _visitorLabel.font   = [UIFont systemFontOfSize:14];

        _friendLabel.text    = @"好友";
        _attentionLabel.text = @"关注";
        _fansLabel.text      = @"粉丝";
        _visitorLabel.text   = @"访客";
        
        _friendLabel.textColor    = [UIColor colorWithHexString:THEME_COLOR_2];
        _attentionLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_2];
        _fansLabel.textColor      = [UIColor colorWithHexString:THEME_COLOR_2];
        _visitorLabel.textColor   = [UIColor colorWithHexString:THEME_COLOR_2];
        
        _friends.textAlignment          = NSTextAlignmentCenter;
        _attentions.textAlignment       = NSTextAlignmentCenter;
        _fans.textAlignment             = NSTextAlignmentCenter;
        _visitors.textAlignment         = NSTextAlignmentCenter;
        
        _friendLabel.textAlignment      = NSTextAlignmentCenter;
        _attentionLabel.textAlignment   = NSTextAlignmentCenter;
        _fansLabel.textAlignment        = NSTextAlignmentCenter;
        _visitorLabel.textAlignment     = NSTextAlignmentCenter;

        [self addSubview:_friends];
        [self addSubview:_attentions];
        [self addSubview:_fans];
        [self addSubview:_visitors];
        
        [self addSubview:_friendLabel];
        [self addSubview:_attentionLabel];
        [self addSubview:_fansLabel];
        [self addSubview:_visitorLabel];
        
        float margin = 10;
        float width = (INPUTTEXTFIELD_WIDTH-5*margin)/4;
        
        [_friendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_friends.mas_bottom).offset(0);
            make.left.equalTo(self.mas_left).offset(margin);
            make.width.mas_equalTo(width);
        }];
        
        [_attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_attentions.mas_bottom).offset(0);
            make.left.equalTo(_friendLabel.mas_right).offset(margin);
            make.width.mas_equalTo(width);
        }];
        
        [_fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fans.mas_bottom).offset(0);
            make.left.equalTo(_attentionLabel.mas_right).offset(margin);
            make.width.mas_equalTo(width);
        }];
        
        [_visitorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_visitors.mas_bottom).offset(0);
            make.right.equalTo(self.mas_right).offset(-margin);
            make.width.mas_equalTo(width);
        }];
        
        [_friends mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(_friendLabel);
            make.width.mas_equalTo(width);
        }];
        
        [_attentions mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(_attentionLabel);
            make.width.mas_equalTo(width);
        }];
        
        [_fans mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(_fansLabel);
            make.width.mas_equalTo(width);
        }];
        
        [_visitors mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(_visitorLabel);
            make.width.mas_equalTo(width);
        }];
    }
    return self;
}

@end
