//
//  YWDetailTopView.h
//  yingwo
//
//  Created by apple on 16/8/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWLabel.h"
#import "YWAlertButton.h"

@interface YWDetailTopView : UIView

@property (nonatomic, strong) UIImageView   *labelImage;
@property (nonatomic, strong) YWLabel       *label;
@property (nonatomic, strong) YWAlertButton *moreBtn;

@end
