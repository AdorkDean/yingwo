//
//  YWTaFollowView.m
//  yingwo
//
//  Created by 王世杰 on 2016/11/4.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTaFollowView.h"

@implementation YWTaFollowView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    
    UIImageView *bgImageView                    = [[UIImageView alloc] init];
    bgImageView.image                           = [UIImage imageNamed:@"ta_under_card"];
    UIButton *followBtn                         = [[UIButton alloc] init];
    UIButton *chatBtn                           = [[UIButton alloc] init];
    UIView *seperate                            = [[UIView alloc] init];
    
    followBtn.backgroundColor                   = [UIColor clearColor];
    followBtn.titleLabel.font                   = [UIFont systemFontOfSize:SCREEN_WIDTH / 375 * 16];
    chatBtn.backgroundColor                     = [UIColor clearColor];
    chatBtn.titleLabel.font                     = [
                                                   UIFont systemFontOfSize:SCREEN_WIDTH / 375 * 16];
    seperate.backgroundColor                    = [UIColor colorWithHexString:@"D8D8D8" alpha:0.8];

    //此处是否关注没有意义 之后获取到数据后会覆盖掉
    [followBtn setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    followBtn.imageEdgeInsets                   = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH / 375 * 50);
    [followBtn setTitle:@"关注"
               forState:UIControlStateNormal];
    followBtn.titleEdgeInsets                   = UIEdgeInsetsMake(0, SCREEN_WIDTH / 375 * 6, 0, 0);
    [followBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1]
                    forState:UIControlStateNormal];

    [chatBtn setImage:[UIImage imageNamed:@"pinglun"]
             forState:UIControlStateNormal];
    chatBtn.imageEdgeInsets                     = UIEdgeInsetsMake(0, 0, 0,  SCREEN_WIDTH / 375 * 50);
    [chatBtn setTitle:@"聊天" forState:UIControlStateNormal];
    chatBtn.titleEdgeInsets                     = UIEdgeInsetsMake(0, SCREEN_WIDTH / 375 * 6, 0, 0);
    [chatBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1]
                  forState:UIControlStateNormal];

    self.bgImageView                            = bgImageView;
    self.followBtn                              = followBtn;
    self.chatBtn                                = chatBtn;
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.followBtn];
    [self addSubview:self.chatBtn];
    [self addSubview:seperate];
    
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self);
    }];
    
    [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self);
        make.right.equalTo(seperate.mas_left);
    }];
    
    [seperate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SCREEN_HEIGHT / 667 * 34);
        make.width.equalTo(@1);
        make.centerX.centerY.equalTo(self);
    }];
    
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(seperate.mas_right).offset(10);
        make.bottom.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
    
}

@end
