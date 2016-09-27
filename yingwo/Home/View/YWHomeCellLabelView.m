//
//  YWHomeCellTopSubview.m
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWHomeCellLabelView.h"

@implementation YWHomeCellLabelView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubView];
    }
    return self;
}


- (void)createSubView {
    
    _labelImage               = [[UIImageView alloc] init];
    _title                    = [[YWLabel alloc] init];

    _labelImage.image         = [UIImage imageNamed:@"#_gray"];
    _title.label.text         = @"新鲜事";
    _title.layer.cornerRadius = 12;

    [self addSubview:_labelImage];
    [self addSubview:_title];
    
    [_labelImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_labelImage.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];

}
@end
