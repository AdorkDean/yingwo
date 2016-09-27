//
//  GradePickerView.h
//  yingwo
//
//  Created by apple on 16/7/30.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradePickerView : UIView

@property (nonatomic, strong) UIView       *topView;
@property (nonatomic, strong) UIButton     *finishedBtn;
@property (nonatomic, strong) UIButton     *cancelBtn;
@property (nonatomic, strong) UIPickerView *pickerView;

@end
