//
//  YWHotDiscussMiddleView.m
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWHotDiscussMiddleView.h"

@implementation YWHotDiscussMiddleView

- (instancetype)init {
    if (self = [super init]) {
        [self createSubviews];
    }
    
    return self;
}

- (void)createSubviews {
    
    _content = [[YWContentLabel alloc] initWithFrame:CGRectZero];
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ying"]];
    
    _content.numberOfLines  = 2;
    _content.textColor      = [UIColor colorWithHexString:THEME_COLOR_2];
    _content.font           = [UIFont systemFontOfSize:16];
    _content.textAlignment  = NSTextAlignmentCenter;
    
    [self addSubview:_content];
    [self addSubview:_imageView];
    
    [_content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
        
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_content.mas_bottom).offset(5);
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@175);
    }];
    
}

@end









