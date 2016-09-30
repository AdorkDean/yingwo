//
//  YWInputButton.m
//  yingwo
//
//  Created by apple on 16/7/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWInputButton.h"

@implementation YWInputButton

-(instancetype)initWithFrame:(CGRect)frame leftLabel:(NSString *)left centerLabel:(NSString *)center {
    self = [super initWithFrame:frame];
    if (self) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_4];
        _leftLabel.textAlignment = NSTextAlignmentLeft;

        _leftLabel.text = left;
        
        _centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width-_leftLabel.width-15, 14)];
        _centerLabel.font = [UIFont systemFontOfSize:14];
        _centerLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_4];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.text = center;
        _centerLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_leftLabel];
        [self addSubview:_centerLabel];
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self);
        }];
        
    }
    return  self;
}

- (void)showRightView {
    UIImageView *rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Row"]];
    [self addSubview:rightView];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-25);
        make.centerY.equalTo(self);
    }];
}

@end
