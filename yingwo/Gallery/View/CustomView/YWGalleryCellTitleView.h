//
//  YWHomeCellTopSubview.h
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTitle.h"
#import "YWVisitorNumLabel.h"

@interface YWGalleryCellTitleView : UIView

@property (nonatomic, strong) UIImageView       *labelImage;
@property (nonatomic, strong) YWTitle           *title;

@property (nonatomic, strong) YWVisitorNumLabel *visitorNumLabel;

@end
