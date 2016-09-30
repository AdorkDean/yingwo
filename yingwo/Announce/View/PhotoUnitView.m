//
//  photoUnitView.m
//  yingwo
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "PhotoUnitView.h"

@implementation PhotoUnitView

- (instancetype)initWithImage:(UIImage *)photoImage {
    
    self = [super init];
    if (self) {
        [self createSubview:photoImage];
    }
    return self;
}

- (void)createSubview:(UIImage *)photoImage {
    
    _deleteViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoImageView = [[UIImageView alloc] initWithImage:photoImage];
    
    [_deleteViewBtn setBackgroundImage:[UIImage imageNamed:@"x_green"] forState:UIControlStateNormal];
    
    [self addSubview:_photoImageView];
    [self addSubview:_deleteViewBtn];

    [_deleteViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_right).offset(-5);
        make.centerY.equalTo(self.mas_top).offset(5);
    }];
    
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
}

@end
