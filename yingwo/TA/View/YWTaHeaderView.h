//
//  YWTaHeaderView.h
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXImageScrollView.h"

@interface YWTaHeaderView : MXImageScrollView

@property (nonatomic, strong)UIImageView        *bgImageView;
@property (nonatomic, strong)UIImageView        *headerView;
@property (nonatomic, strong)UILabel            *userName;
@property (nonatomic, strong)UILabel            *signature;
@property (nonatomic, strong)UILabel            *numberOfFollow;
@property (nonatomic, strong)UILabel            *numberOfFans;

@end
