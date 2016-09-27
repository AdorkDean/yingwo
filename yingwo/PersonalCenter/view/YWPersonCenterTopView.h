//
//  YWPersonCenterTopView.h
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPersonCenterTopView : UIButton

@property (nonatomic, strong)UIImage *headPortraitImage;

@property (nonatomic, strong)UIImageView *headPortraitImageView;
@property (nonatomic, strong)UIImageView *genderImageView;
@property (nonatomic, strong)UIImageView *rightImageView;

@property (nonatomic, strong)UILabel *usernameLabel;
@property (nonatomic, strong)UILabel *signatureLabel;


- (instancetype)initWithHeadPortrait:(UIImage *)headPortrait
                            username:(NSString *)username
                           signature:(NSString *)signature
                              gender:(NSString *)gender;

@end
