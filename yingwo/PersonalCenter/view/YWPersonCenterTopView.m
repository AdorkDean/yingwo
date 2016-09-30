//
//  YWPersonCenterTopView.m
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWPersonCenterTopView.h"

@implementation YWPersonCenterTopView

- (instancetype)initWithHeadPortrait:(UIImage *)headPortrait
                            username:(NSString *)username
                           signature:(NSString *)signature
                              gender:(NSString *)gender {
    if (self = [super init]) {
        
        _headPortraitImageView                     = [[UIImageView alloc] init];
        _genderImageView                           = [[UIImageView alloc] init];
        _rightImageView                            = [[UIImageView alloc] init];
        _usernameLabel                             = [[UILabel alloc] init];
        _signatureLabel                            = [[UILabel alloc] init];

        _headPortraitImageView.image               = headPortrait;
        _headPortraitImageView.layer.cornerRadius  = 32.5f;
        _headPortraitImageView.layer.masksToBounds = YES;
        _usernameLabel.text                        = username;
        _signatureLabel.text                       = signature;

        _usernameLabel.font                        = [UIFont systemFontOfSize:15];
        _usernameLabel.textColor                   = [UIColor colorWithHexString:THEME_COLOR_2];

        _signatureLabel.font                       = [UIFont systemFontOfSize:14];
        _signatureLabel.textColor                  = [UIColor colorWithHexString:THEME_COLOR_3];

        _rightImageView.image                      = [UIImage imageNamed:@"Row"];
        
        [self addSubview:_headPortraitImageView];
        [self addSubview:_genderImageView];
        [self addSubview:_usernameLabel];
        [self addSubview:_signatureLabel];
        [self addSubview:_rightImageView];

        [_headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(@65);
            make.height.equalTo(@65);
            make.left.equalTo(self.mas_left).offset(23);
        }];
        
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(25);
            make.left.equalTo(_headPortraitImageView.mas_right).offset(23);
        }];
        
        [_signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_usernameLabel.mas_bottom).offset(10);
            make.left.equalTo(_usernameLabel.mas_left);
        }];
        
        [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_usernameLabel.mas_right).offset(10);
            make.centerY.equalTo(_usernameLabel);
        }];
        
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
}
@end
