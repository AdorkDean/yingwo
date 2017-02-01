//
//  YWDetailBottomView.h
//  yingwo
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWSpringButton.h"

@interface YWDetailBottomView : UIView

@property (nonatomic, strong) UIView         *backgroundView;
@property (nonatomic, strong) UITextField    *messageField;
@property (nonatomic, strong) YWSpringButton *favorBtn;

@end
