//
//  InputPhoneTextField.h
//  yingwo
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputTextField : UIImageView

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UITextField  *rightTextField;

- (instancetype)initWithLeftLabel:(NSString *)name rightPlace:(NSString *)placeName;

- (instancetype)initWithLeftLabel:(NSString *)leftName;
@end
