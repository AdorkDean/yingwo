//
//  GradePickerView.m
//  yingwo
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "GradePickerView.h"

@implementation GradePickerView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {

        UILabel *title  = [[UILabel alloc] init];

        _topView        = [[UIView alloc] init];
        _finishedBtn    = [[UIButton alloc] init];
        _cancelBtn    = [[UIButton alloc] init];
        _pickerView     = [[UIPickerView alloc] init];

        title.text      = @"请选择入学年份";
        title.textColor = [UIColor colorWithHexString:THEME_COLOR_3];
        title.font      = [UIFont systemFontOfSize:14];

        [_finishedBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1]
                           forState:UIControlStateNormal];
        [_finishedBtn setTitle:@"完成" forState:UIControlStateNormal];
        _finishedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_cancelBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_3]
                           forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];

        [self addSubview:_topView];
        [self addSubview:_finishedBtn];
        [self addSubview:_cancelBtn];
        [self addSubview:_pickerView];
        [self addSubview:title];
        
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(_finishedBtn.mas_height);
            make.centerX.equalTo(self);
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topView);
            make.centerY.equalTo(_topView);
        }];
        
        [_finishedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_topView.mas_right).offset(-10);
            make.centerY.equalTo(_topView.mas_centerY);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topView.mas_left).offset(10);
            make.centerY.equalTo(_topView.mas_centerY);
        }];

        
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom).offset(10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(100));
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        
    }
    return self;
}

@end
