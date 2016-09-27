//
//  YWDetailBottomView.m
//  yingwo
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDetailBottomView.h"

@implementation YWDetailBottomView

- (instancetype)init {
    
    self =[super init];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubview];
    }
    return self;
}

- (void)createSubview {
    
    self.backgroundView = [[UIView alloc] init];
    self.messageField   = [[UITextField alloc] init];
    self.favorBtn       = [[YWSpringButton alloc ]initWithSelectedImage:[UIImage imageNamed:@"heart_red"]
                           
                                                         andCancelImage:[UIImage imageNamed:@"heart_gray"]];
    self.backgroundView.layer.cornerRadius  = 10;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.backgroundColor     = [UIColor colorWithHexString:THEME_COLOR_5 alpha:0.5];

    self.messageField.placeholder         = @"还没有留言～";
    self.messageField.font                = [UIFont systemFontOfSize:14];
    [self.favorBtn setBackgroundImage:[UIImage imageNamed:@"heart_gray"]
                             forState:UIControlStateNormal];
    
    [self addSubview:self.backgroundView];
    [self addSubview:self.messageField];
    [self addSubview:self.favorBtn];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.height.equalTo(@30);
        make.right.equalTo(self.favorBtn.mas_left).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.messageField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView).offset(10);
        make.right.equalTo(self.backgroundView).offset(-10);
        make.height.equalTo(@15);
        make.centerY.equalTo(self.mas_centerY);

    }];
    
    [self.favorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
}

@end
