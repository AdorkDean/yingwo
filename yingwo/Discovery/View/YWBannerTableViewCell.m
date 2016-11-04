//
//  YWBannerTableViewCell.m
//  yingwo
//
//  Created by apple on 16/8/20.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWBannerTableViewCell.h"

//导航条图片高度
static CGFloat const scrollViewHeight = 150;

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
    //滚动图，默认背景图片
//    UIImageView *bannerPicDefaultImageView = [[UIImageView alloc] init];
//    bannerPicDefaultImageView.image = [UIImage imageNamed:@"banner_pic_default"];
    
//    [self setBackgroundView:bannerPicDefaultImageView];
//    [self setBackgroundColor:[UIColor colorWithHexString:BACKGROUND_COLOR]];
    
    [self addSubview:self.mxScrollView] ;
}

@end
