//
//  HotDisscussViewModel.h
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHotDiscussCell.h"
#import "HotDiscussEntity.h"

@interface HotDisscussViewModel : UIView

@property (nonatomic, strong) RACCommand     *fecthTopicEntityCommand;

- (void)setupModelOfCell:(YWHotDiscussCell *)cell model:(HotDiscussEntity *)model;

@end
