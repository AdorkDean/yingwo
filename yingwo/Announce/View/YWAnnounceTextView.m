//
//  YWAnnounceTextView.m
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWAnnounceTextView.h"

@implementation YWAnnounceTextView
{
}

- (instancetype)init {
    self = [super init];
    if (self) {
      //  self.delegate = self;
        
        [self createSubview];
    }
    return self;
}

- (void)createSubview {
//
//    _placeholder         = [[UILabel alloc] init];
//    _placeholder.font    = [UIFont systemFontOfSize:15];
//    _placeholder.enabled = NO;
//    _placeholder.text    = @"请输入内容...";
    self.backgroundColor = [UIColor whiteColor];
    
    _contentTextView     = [[HPGrowingTextView alloc] init];
    
    [self addSubview:_contentTextView];
    
    [_contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(self.mas_height);
    }];
    
}


@end
