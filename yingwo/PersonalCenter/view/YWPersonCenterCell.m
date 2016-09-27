//
//  YWPersonCenterCell.m
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWPersonCenterCell.h"

@implementation YWPersonCenterCell

- (instancetype)initWithLeftImage:(UIImage *)leftImage labelText:(NSString *)text {
    self = [super init];
    if (self) {
        
        UIImageView *leftImageView  = [[UIImageView alloc] init];
        UIImageView *rightImageView = [[UIImageView alloc] init];
        UILabel *textLabel          = [[UILabel alloc] init];

        rightImageView.image = [UIImage imageNamed:@"Row"];

        leftImageView.image  = leftImage;
        textLabel.text       = text;
        textLabel.font       = [UIFont systemFontOfSize:15];
        textLabel.textColor  = [UIColor colorWithHexString:THEME_COLOR_2];
                
        [self addSubview:leftImageView];
        [self addSubview:rightImageView];
        [self addSubview:textLabel];
        
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(20);
        }];
        
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(leftImageView.mas_right).offset(15);
        }];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.mas_right).offset(-15);
        }];
        
    }
    return self;
}

@end
