//
//  YWBannerTableViewCell.m
//  yingwo
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWBannerTableViewCell.h"

//导航条图片高度
static CGFloat const scrollViewHeight = 220;

@implementation YWBannerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createSubView];
        
    }
    return self;
}

- (void)createSubView {
    
    self.mxScrollView = [[MXImageScrollView alloc] initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        SCREEN_WIDTH,
                                                                        scrollViewHeight)];
    [self addSubview:self.mxScrollView] ;
}

@end
