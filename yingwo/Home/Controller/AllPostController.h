//
//  AllPostController.h
//  yingwo
//
//  Created by 王世杰 on 2017/3/4.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "GalleryController.h"


typedef void(^RemindLabelBlock)(int badgeCount);

@interface AllPostController : GalleryController

@property (nonatomic, strong) YWTabBar        *tabBar;

@property (nonatomic, strong) RemindLabelBlock remindLabelBlock;

@end
