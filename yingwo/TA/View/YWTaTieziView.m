//
//  YWTaTieziView.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTaTieziView.h"
#import "TieZi.h"

#import "YWHomeTableViewCellNoImage.h"
#import "YWHomeTableViewCellOneImage.h"
#import "YWHomeTableViewCellTwoImage.h"
#import "YWHomeTableViewCellThreeImage.h"
#import "YWHomeTableViewCellFourImage.h"
#import "YWHomeTableViewCellSixImage.h"
#import "YWHomeTableViewCellNineImage.h"
#import "YWHomeTableViewCellMoreNineImage.h"

@protocol  YWHomeCellMiddleViewBaseProtocol;
@interface YWTaTieziView()<UITableViewDataSource,UITabBarDelegate>

@property (nonatomic, strong) TieZi             *model;

@end

@implementation YWTaTieziView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *taTopicLabel = [[UILabel alloc] init];
        taTopicLabel.text = @"TA的话题";
        taTopicLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_2];
        taTopicLabel.font = [UIFont systemFontOfSize:14];
        
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.image = [UIImage imageNamed:@"Row"];
        rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:taTopicLabel];
        [self addSubview:rightImageView];
        
        [taTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
        }];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(taTopicLabel);
        }];
        
    }
    return self;
}

/**
 *  cell identifier
 */
static NSString *YWHomeCellNoImageIdentifier       = @"noImageCell";
static NSString *YWHomeCellOneImageIdentifier      = @"oneImageCell";
static NSString *YWHomeCellTwoImageIdentifier      = @"twoImageCell";
static NSString *YWHomeCellThreeImageIdentifier    = @"threeImageCell";
static NSString *YWHomeCellFourImageIdentifier     = @"fourImageCell";
static NSString *YWHomeCellSixImageIdentifier      = @"sixImageCell";
static NSString *YWHomeCellNineImageIdentifier     = @"nineImageCell";
static NSString *YWHomeCellMoreNineImageIdentifier = @"moreNineImageCell";


#pragma mark 懒加载

- (UITableView *)homeTableview {
    if (_homeTableview == nil) {
        _homeTableview                 = [[UITableView alloc] initWithFrame:self.bounds
                                                                      style:UITableViewStyleGrouped];
        _homeTableview.delegate        = self;
        _homeTableview.dataSource      = self;
        _homeTableview.separatorStyle  = UITableViewCellSeparatorStyleNone;
        _homeTableview.backgroundColor = [UIColor clearColor];
//        _homeTableview.contentInset    = UIEdgeInsetsMake(0, 0, footerHeight, 0);
        _homeTableview.scrollEnabled   = NO;
        
        [_homeTableview registerClass:[YWHomeTableViewCellNoImage class]
               forCellReuseIdentifier:YWHomeCellNoImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellOneImage class]
               forCellReuseIdentifier:YWHomeCellOneImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellTwoImage class]
               forCellReuseIdentifier:YWHomeCellTwoImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellThreeImage class]
               forCellReuseIdentifier:YWHomeCellThreeImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellFourImage class]
               forCellReuseIdentifier:YWHomeCellFourImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellSixImage class]
               forCellReuseIdentifier:YWHomeCellSixImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellNineImage class]
               forCellReuseIdentifier:YWHomeCellNineImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellMoreNineImage class]
               forCellReuseIdentifier:YWHomeCellMoreNineImageIdentifier];
        
    }
    return _homeTableview;
}


@end
