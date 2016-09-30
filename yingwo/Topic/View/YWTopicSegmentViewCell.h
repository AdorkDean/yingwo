//
//  YWTopicSegmentViewCell.h
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPagerTabView.h"
#import "HotTopicController.h"
#import "NewTopicController.h"

@interface YWTopicSegmentViewCell : UITableViewCell<SMPagerTabViewDelegate>

@property (nonatomic, strong) SMPagerTabView     *topicSegmentView;
@property (nonatomic, strong) NSMutableArray     *catalogVcArr;
@property (nonatomic, strong) HotTopicController *hotVc;
@property (nonatomic, strong) NewTopicController *freshVc;

@end
