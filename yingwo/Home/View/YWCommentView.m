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

    _identfier.layer.cornerRadius = 10;
    _identfier.backgroundColor    = [UIColor colorWithHexString:THEME_COLOR_1 alpha:0.5];

    self.leftName.font            = [UIFont systemFontOfSize:14];

    self.leftName.textColor       = [UIColor colorWithHexString:THEME_COLOR_1];

    self.content.font             = [UIFont systemFontOfSize:14];
    self.content.textColor        = [UIColor colorWithHexString:THEME_COLOR_2];
    self.content.numberOfLines    = 0;
    self.content.lineBreakMode    = NSLineBreakByCharWrapping;

    [self addSubview:self.leftName];
    [self addSubview:self.identfier];
    [self addSubview:self.content];

    [self.leftName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).priorityHigh();
        make.top.equalTo(self);
        make.height.equalTo(@13).priorityHigh();
    }];
    
    [self.identfier mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftName.mas_right).offset(2).priorityHigh();
        make.top.equalTo(self).offset(1);
        make.width.equalTo(@30);
    }];

    [self.content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftName.mas_left);
        make.right.equalTo(self.mas_right).offset(5);
        make.top.equalTo(self.leftName.mas_top).priorityHigh();
        make.bottom.equalTo(self);
    }];
        
}

@end
