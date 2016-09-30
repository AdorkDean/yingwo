//
//  YWPersonCenterCell.h
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPersonCenterCell : UIButton

@property (nonatomic, strong) UIImage *leftImage;
@property (nonatomic, strong) NSString *text;

- (instancetype)initWithLeftImage:(UIImage *)leftImage labelText:(NSString *)text;

@end
