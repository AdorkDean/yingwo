//
//  YWCommentReplyView.m
//  yingwo
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWCommentReplyView.h"

@implementation YWCommentReplyView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview {
    
    self.leftName           = [[UILabel alloc] init];
    self.content            = [[YWContentLabel alloc] initWithFrame:CGRectZero];
    
    self.leftName.font      = [UIFont systemFontOfSize:14];
    
    self.leftName.textColor = [UIColor colorWithHexString:THEME_COLOR_1];
    
    [self addSubview:self.leftName];
    [self addSubview:self.content];
    
    [self.leftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftName.mas_right).offset(5);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
}
@end
