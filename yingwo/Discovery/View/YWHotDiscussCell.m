//
//  YWHotDiscussCell.m
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWHotDiscussCell.h"

@implementation YWHotDiscussCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundColor                    = [UIColor clearColor];
        self.backgroundView.backgroundColor     = [UIColor whiteColor];
        self.backgroundView.layer.masksToBounds = YES;
        self.backgroundView.layer.cornerRadius  = 10;
        self.backgroundView.frame = CGRectMake(0, 0, self.width - self.width * 0.05, 0);

        [self createSubviews];
        

    }
    
    return self;
    
}

- (void)createSubviews {
    
    _topView    = [[YWHotDiscussTopView alloc] init];
    _middleView = [[YWHotDiscussMiddleView alloc] init];
    _bottomView = [[YWHotDiscussBottomView alloc] init];

    
    [self.contentView addSubview:self.backgroundView];
  //  [self.backgroundView addSubview:_topView];
    [self.backgroundView addSubview:_middleView];
    [self.backgroundView addSubview:_bottomView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 2.5, 10));
    }];
    
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(self.backgroundView.mas_left).offset(10);
//        make.right.equalTo(self.backgroundView.mas_right);
//        make.top.equalTo(self.backgroundView.mas_top).offset(20);
//        make.height.equalTo(@10);
//    }];
    
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView.mas_left).offset(5);
        make.right.equalTo(self.backgroundView.mas_right).offset(-5);
        make.top.equalTo(self.backgroundView.mas_top).offset(10);
    }];
        
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_middleView.mas_bottom).offset(20);
        make.left.equalTo(self.backgroundView.mas_left).offset(5);
        make.right.equalTo(self.backgroundView.mas_right).offset(-5);
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-20);
    }];
    
}

@end








