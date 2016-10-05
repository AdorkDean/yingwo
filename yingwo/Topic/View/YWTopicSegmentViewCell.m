//
//  YWTopicSegmentViewCell.m
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTopicSegmentViewCell.h"

@implementation YWTopicSegmentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubview];
    }
    return self;
}


- (void)createSubview {
    
    self.topicSegmentView          = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0,
                                                                                0,
                                                                                SCREEN_WIDTH,
                                                                                SCREEN_HEIGHT+250)];
    self.topicSegmentView.delegate = self;
    self.topicSegmentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.topicSegmentView];
    
    self.catalogVcArr = [[NSMutableArray alloc] init];
    self.hotVc        = [[HotTopicController alloc] init];
    self.freshVc      = [[NewTopicController alloc] init];
    
    [self.catalogVcArr addObject:self.freshVc];
    [self.catalogVcArr addObject:self.hotVc];

    //开始构建UI
    [self.topicSegmentView buildUI];
    //起始选择一个tab
    [self.topicSegmentView selectTabWithIndex:0 animate:NO];
    //显示红点，点击消失
    // [self.discoverySegmentView showRedDotWithIndex:0];
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    return [self.catalogVcArr count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    return self.catalogVcArr[number];
}

- (void)whenSelectOnPager:(NSUInteger)number {
    NSLog(@"页面 %lu",(unsigned long)number);
}


@end
