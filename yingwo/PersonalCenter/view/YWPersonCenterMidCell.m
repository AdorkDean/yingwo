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

        UILabel *friendLabel    = [[UILabel alloc] init];
        UILabel *attentionLabel = [[UILabel alloc] init];
        UILabel *fansLabel      = [[UILabel alloc] init];
        UILabel *visitorLabel   = [[UILabel alloc] init];

        friendLabel.font    = [UIFont systemFontOfSize:14];
        attentionLabel.font = [UIFont systemFontOfSize:14];
        fansLabel.font      = [UIFont systemFontOfSize:14];
        visitorLabel.font   = [UIFont systemFontOfSize:14];

        friendLabel.text    = @"好友";
        attentionLabel.text = @"关注";
        fansLabel.text      = @"粉丝";
        visitorLabel.text   = @"访客";
        
        friendLabel.textColor    = [UIColor colorWithHexString:THEME_COLOR_2];
        attentionLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_2];
        fansLabel.textColor      = [UIColor colorWithHexString:THEME_COLOR_2];
        visitorLabel.textColor   = [UIColor colorWithHexString:THEME_COLOR_2];

        [self addSubview:_friends];
        [self addSubview:_attentions];
        [self addSubview:_fans];
        [self addSubview:_visitors];
        [self addSubview:friendLabel];
        [self addSubview:attentionLabel];
        [self addSubview:fansLabel];
        [self addSubview:visitorLabel];
        
        float padding = 30;
        float margin = (INPUTTEXTFIELD_WIDTH-2*padding-12*2)/3;
        
        [friendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_friends.mas_bottom).offset(0);
            make.left.equalTo(self.mas_left).offset(padding);
        }];
        
        [attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_attentions.mas_bottom).offset(0);
            make.left.equalTo(friendLabel.mas_left).offset(margin);
        }];
        
        [fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_fans.mas_bottom).offset(0);
            make.left.equalTo(attentionLabel.mas_left).offset(margin);
        }];
        
        [visitorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_visitors.mas_bottom).offset(0);
            make.right.equalTo(self.mas_right).offset(-padding);
        }];
        
        [_friends mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(friendLabel);
        }];
        
        [_attentions mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(attentionLabel);
        }];
        
        [_fans mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(fansLabel);
        }];
        
        [_visitors mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.centerX.equalTo(visitorLabel);
        }];
    }
    return self;
}

@end
