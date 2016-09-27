//
//  YWDetailCellBottomView.m
//  yingwo
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDetailCellBottomView.h"

@implementation YWDetailCellBottomView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview {
    _favour       = [[YWSpringButton alloc ]initWithSelectedImage:[UIImage imageNamed:@"heart_red"]
                                                    andCancelImage:[UIImage imageNamed:@"heart_gray"]];
    _message      = [[UIButton alloc] init];

    _favourLabel  = [[UILabel alloc] init];
    _messageLabel = [[UILabel alloc] init];
    _bottomLine   = [[UILabel alloc] init];

    _favourLabel.textColor      = [UIColor colorWithHexString:THEME_COLOR_4];
    _messageLabel.textColor     = [UIColor colorWithHexString:THEME_COLOR_4];

    _bottomLine.backgroundColor = [UIColor colorWithHexString:THEME_COLOR_4];

    [_message setBackgroundImage:[UIImage imageNamed:@"bub_gray"]
                        forState:UIControlStateNormal];

    [_message addTarget:self
                 action:@selector(selectMessage)
       forControlEvents:UIControlEventTouchUpInside];
    
    _messageLabel.text = @"0";
    _favourLabel.text = @"0";

    [self addSubview:_favour];
    [self addSubview:_message];
    [self addSubview:_favourLabel];
    [self addSubview:_messageLabel];
    [self addSubview:_bottomLine];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    
    [_message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_messageLabel.mas_left).offset(-5);
        make.centerY.equalTo(self);
    }];
    
    [_favourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(_message.mas_left).offset(-10);
    }];
    
    [_favour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_favourLabel.mas_left).offset(-5);
        make.centerY.equalTo(self);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5f);
    }];
    
}

- (void)selectMessage {

    if ([self.delegate respondsToSelector:@selector(didSelectMessageWith:onSuperview:)]) {
        [self.delegate didSelectMessageWith:self.post_reply_id onSuperview:self.superview];
    }
}


@end
