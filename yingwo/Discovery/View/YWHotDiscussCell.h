//
//  YWHotDiscussCell.h
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHotDiscussTopView.h"
#import "YWHotDiscussMiddleView.h"
#import "YWHotDiscussBottomView.h"

@interface YWHotDiscussCell : UITableViewCell

@property (nonatomic, strong) YWHotDiscussTopView    *topView;
@property (nonatomic, strong) YWHotDiscussMiddleView *middleView;
@property (nonatomic, strong) YWHotDiscussBottomView *bottomView;


@end
