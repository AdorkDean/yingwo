//
//  CommentView.m
//  yingwo
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWCommentView.h"

@implementation YWCommentView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubview];
    //    self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)createSubview {

    self.leftName                 = [[UILabel alloc] init];
    self.identfier                = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"louzhubiaoqian"]];
    self.content                  = [[UILabel alloc] initWithFrame:CGRectZero];
    self.deleteBtn                = [[UIButton alloc] init];
    
    _identfier.layer.cornerRadius = 10;
    _identfier.backgroundColor    = [UIColor colorWithHexString:THEME_COLOR_1 alpha:0.5];

    self.leftName.font            = [UIFont systemFontOfSize:14];

    self.leftName.textColor       = [UIColor colorWithHexString:THEME_COLOR_1];

    self.leftName.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapLeftName:)];
    
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired    = 1;
    
    [self.leftName addGestureRecognizer:tap];
    
    self.content.font             = [UIFont systemFontOfSize:14];
    self.content.textColor        = [UIColor colorWithHexString:THEME_COLOR_2];
    self.content.numberOfLines    = 0;
    self.content.lineBreakMode    = NSLineBreakByCharWrapping;

    [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    
    [self addSubview:self.identfier];
    [self addSubview:self.content];
    [self addSubview:self.leftName];
    [self addSubview:self.deleteBtn];

    [self.leftName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).priorityHigh();
        make.top.equalTo(self).priorityHigh();
//        make.height.equalTo(@14).priorityHigh();
        make.bottom.equalTo(self.mas_top).offset(14);
    }];
    
    [self.identfier mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftName.mas_right).offset(2).priorityHigh();
        make.centerY.equalTo(self.leftName);
        make.width.equalTo(@30);
    }];

    [self.content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftName.mas_left);
        make.right.equalTo(self.mas_right).offset(5);
        make.top.equalTo(self.leftName.mas_top).priorityHigh();
        make.bottom.equalTo(self);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content.mas_right).offset(5);
        
    }];
    
        
}

- (void)tapLeftName:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(didSelectLeftNameWithUserId:)]) {
        [self.delegate didSelectLeftNameWithUserId:self.user_id];
    }
}

@end
