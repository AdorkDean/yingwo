//
//  YWConfigurationCell.h
//  yingwo
//
//  Created by apple on 16/7/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWConfigurationCell : UIButton

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightView;

- (instancetype)initWithLeftLabel:(NSString *)left isHasRightView:(Boolean)ishas;

@end
