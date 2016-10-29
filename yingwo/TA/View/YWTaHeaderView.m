//
//  YWTaHeaderView.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTaHeaderView.h"

@implementation YWTaHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self creatSubView];
    }
    return  self;
}


- (void)creatSubView {
    _bgImageView                            = [[UIImageView alloc] init];
    _headerView                             = [[UIImageView alloc] init];
    _userName                               = [[UILabel alloc] init];
    _signature                              = [[UILabel alloc] init];
    _numberOfFollow                         = [[UILabel alloc] init];
    _numberOfFans                           = [[UILabel alloc] init];
    
    _userName.textColor                     = [UIColor whiteColor];
    _signature.textColor                    = [UIColor whiteColor];
    _numberOfFollow.textColor               = [UIColor whiteColor];
    _numberOfFans.textColor                 = [UIColor whiteColor];
    
    _userName.font                          = [UIFont systemFontOfSize:14];
    _signature.font                         = [UIFont systemFontOfSize:12.0];
    _numberOfFollow.font                    = [UIFont systemFontOfSize:12.0];
    _numberOfFans.font                      = [UIFont systemFontOfSize:12.0];
    
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius  = 45;

    [self addSubview:_bgImageView];
    [self addSubview:_headerView];
    [self addSubview:_userName];
    [self addSubview:_signature];
    [self addSubview:_numberOfFans];
    [self addSubview:_numberOfFollow];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.left.equalTo(self);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
    }];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@90);
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_centerY).offset(-20);
    }];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headerView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
    
    [_signature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
    
    [_numberOfFollow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_centerX);
        make.top.equalTo(_signature.mas_bottom).offset(5);
    }];
    
    [_numberOfFans mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.top.equalTo(_numberOfFollow);
    }];
}

@end
