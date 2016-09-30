//
//  InputPhoneTextField.m
//  yingwo
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "InputTextField.h"

@implementation InputTextField

- (instancetype)initWithLeftLabel:(NSString *)name rightPlace:(NSString *)placeName{
    self = [super init];
    if (self) {
        
        _leftLabel               = [[UILabel alloc] init];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.text          = name;
        _leftLabel.font          = [UIFont fontWithName:@"CourierNewPSMT" size:15];
        _leftLabel.textColor     = [UIColor colorWithHexString:THEME_COLOR_3];

        _rightTextField             = [[UITextField alloc] init];
        _rightTextField.font        = [UIFont systemFontOfSize:15.0f];
        _rightTextField.placeholder = placeName;
        self.image                  = [UIImage imageNamed:@"input_textfield"];
        self.userInteractionEnabled = YES;
        
        [self addSubview:_leftLabel];
        [self addSubview:_rightTextField];
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self);
        }];
        
        [_rightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_leftLabel.mas_left).offset(85);
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self);
        }];
        
    }
    return self;
    
}

- (instancetype)initWithLeftLabel:(NSString *)leftName {
    self = [self init];
    if (self) {
        
        _leftLabel               = [[UILabel alloc] init];

        _rightTextField             = [[UITextField alloc] init];
        _rightTextField.font        = [UIFont systemFontOfSize:15.0f];
        _rightTextField.placeholder = leftName;
        self.image                  = [UIImage imageNamed:@"input_textfield"];
        self.userInteractionEnabled = YES;
        
        [self addSubview:_leftLabel];
        [self addSubview:_rightTextField];

        
        [_rightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.width.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end
