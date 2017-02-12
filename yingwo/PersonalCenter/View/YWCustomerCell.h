//
//  YWCustomerCell.h
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWCustomerCell : UIButton

@property (nonatomic, strong) UIImage  *leftImage;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UILabel  *badgeLabel;

- (instancetype)initWithLeftImage:(UIImage *)leftImage labelText:(NSString *)text;

@end
