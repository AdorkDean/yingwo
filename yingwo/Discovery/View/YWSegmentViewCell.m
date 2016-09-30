//
//  YWSegmentViewCell.m
//  yingwo
//
//  Created by apple on 16/8/27.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWSegmentViewCell.h"

@implementation YWSegmentViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubview];
    }
    return self;
}

- (void)createSubview {
    
    self.discoverySegmentView = [[SMPagerTabView alloc]initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            SCREEN_WIDTH,
                                                                            SCREEN_HEIGHT)];
    self.discoverySegmentView.delegate = self;
    
    [self.contentView addSubview:self.discoverySegmentView];
    
    self.catalogVcArr = [[NSMutableArray alloc] init];
    self.oneFieldVc   = [[FieldOneController alloc] init];
    self.twoFieldVc   = [[FieldTwoController alloc] init];
    self.threeFieldVc = [[FieldThreeController alloc] init];
    
    [self.catalogVcArr addObject:self.oneFieldVc];
    [self.catalogVcArr addObject:self.twoFieldVc];
    [self.catalogVcArr addObject:self.threeFieldVc];
    
    //开始构建UI
    [self.discoverySegmentView buildUI];
    //起始选择一个tab
    [self.discoverySegmentView selectTabWithIndex:0 animate:NO];
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
