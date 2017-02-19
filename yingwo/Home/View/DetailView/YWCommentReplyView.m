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
    
    self.leftName                        = [[UILabel alloc] init];
    self.content                         = [[UILabel alloc] initWithFrame:CGRectZero];

    self.leftName.font                   = [UIFont systemFontOfSize:14];

    self.leftName.userInteractionEnabled = YES;

    self.leftName.textColor              = [UIColor colorWithHexString:THEME_COLOR_1];

    UITapGestureRecognizer *tap          = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapLeftName:)];

    tap.numberOfTouchesRequired          = 1;
    tap.numberOfTapsRequired             = 1;
    
    [self.leftName addGestureRecognizer:tap];

    self.content.font          = [UIFont systemFontOfSize:14];
    self.content.textColor     = [UIColor colorWithHexString:THEME_COLOR_2];
    self.content.numberOfLines = 0;
    self.content.lineBreakMode = NSLineBreakByCharWrapping;
    

    [self addSubview:self.content];
    [self addSubview:self.leftName];

    [self.leftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self).priorityHigh();
        make.bottom.equalTo(self.mas_top).offset(14);
    }];

    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftName.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.leftName.mas_top);
        make.bottom.equalTo(self);
    }];
}
@end
