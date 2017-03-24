//
//  EmptyRemindView.h
//  yingwo
//
//  Created by 王世杰 on 2017/3/20.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWEmptyRemindView : UIView

@property (nonatomic, strong) UIImageView       *imageView;
@property (nonatomic, strong) UILabel           *remindLabel;

-(instancetype)initWithFrame:(CGRect)frame andText:(NSString *)remindText;

@end
