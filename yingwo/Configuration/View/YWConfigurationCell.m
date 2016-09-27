//
//  YWConfigurationCell.m
//  yingwo
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWConfigurationCell.h"

@implementation YWConfigurationCell

- (instancetype)initWithLeftLabel:(NSString *)left isHasRightView:(Boolean)ishas {

    self = [super init];
    if (self) {
        
        _leftLabel  = [[UILabel alloc] init];
        _rightLabel = [[UILabel alloc] init];
        _rightView  = [[UIImageView alloc] init];
        
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _rightLabel.font = [UIFont systemFontOfSize:15];
        
        _leftLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_2];
        _rightLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_2];

        _leftLabel.text = left;
        
        _rightView.image = [UIImage imageNamed:@"Row"];
        
        [self addSubview:_leftLabel];
        [self addSubview:_rightLabel];
        [self addSubview:_rightView];
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(8);
            make.centerY.equalTo(self);
        }];
        
        //左边箭头
        if (ishas) {
            
            [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-15);
                make.centerY.equalTo(self);
            }];
            
            [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_rightView.mas_left).offset(-8);
                make.centerY.equalTo(self);
            }];
            
        }else {
            [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.mas_right).offset(-25);
                make.centerY.equalTo(self);
            }];
        }
        
        //设备适配，主要是ihone5
//        if (IS_IPHONE_5) {
//            [self mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(@45);
//            }];
//        }
        
    }
    return self;
}
@end
