//
//  YWMessageImageBottomView.h
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWContentLabel.h"

@interface YWMessageImageBottomView : UIView

@property (nonatomic, strong) UILabel        *username;
@property (nonatomic, strong) YWContentLabel *content;
@property (nonatomic, strong) UIImageView    *leftImageView;

@end
