//
//  YWHomeCellBottomView.m
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWHomeCellBottomView.h"

@implementation YWHomeCellBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createSubView];
        
    }
    return self;
}

- (void)createSubView {

    _headImageView                     = [[UIImageView alloc] init];
    _nickname                          = [[UILabel alloc] init];
    _time                              = [[UILabel alloc] init];

    _favour                            = [[YWSpringButton alloc ]initWithSelectedImage:[UIImage imageNamed:@"heart_red"]
                                          
                                                                        andCancelImage:[UIImage imageNamed:@"heart_gray"]];
    _more                              = [[YWAlertButton alloc] initWithNames:[NSArray arrayWithObjects:@"删除",@"复制",@"举报",nil]];

    _message                           = [[UIButton alloc] init];
    _favourLabel                       = [[UILabel alloc] init];
    _messageLabel                      = [[UILabel alloc] init];

    _favourLabel.tag                   = 101;

    _headImageView.image               = [UIImage imageNamed:@"touxiang"];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius  = 20;
    
    [_message setBackgroundImage:[UIImage imageNamed:@"bub_gray"]
                        forState:UIControlStateNormal];
    [_more setBackgroundImage:[UIImage imageNamed:@"more_gray"]
                     forState:UIControlStateNormal];
    
    _nickname.font = [UIFont systemFontOfSize:12];
    _time.font     = [UIFont systemFontOfSize:10];

    _nickname.textColor     = [UIColor colorWithHexString:THEME_COLOR_2];
    _time.textColor         = [UIColor colorWithHexString:THEME_COLOR_3];
    _favourLabel.textColor  = [UIColor colorWithHexString:THEME_COLOR_4];
    _messageLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_4];


    [self addSubview:_headImageView];
    [self addSubview:_nickname];
    [self addSubview:_time];
    [self addSubview:_favour];
    [self addSubview:_message];
    [self addSubview:_more];
    [self addSubview:_favourLabel];
    [self addSubview:_messageLabel];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [_nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(7.5);
        make.centerY.equalTo(_headImageView.mas_centerY).offset(-7.5);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickname.mas_left);
        make.top.equalTo(_nickname.mas_bottom).offset(7.5);
    }];
    
    [_more mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headImageView);
        make.right.equalTo(self.mas_right);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headImageView);
        make.right.equalTo(_more.mas_left).offset(-10);
    }];
    
    [_message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_messageLabel.mas_left).offset(-5);
        make.centerY.equalTo(_headImageView);
    }];
    
    [_favourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headImageView);
        make.right.equalTo(_message.mas_left).offset(-10);
    }];
    
    [_favour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_favourLabel.mas_left).offset(-5);
        make.centerY.equalTo(_headImageView);
    }];

    
}

/**
 *  点赞
 */
//- (void)favourTheTieZi {
//    
//    [_favour setBackgroundImage:[UIImage imageNamed:@"heart_red"] forState:UIControlStateNormal];
//    
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
//    anim.springBounciness    = 0;
//    anim.springSpeed         = 20;
//    [_favour pop_addAnimation:anim forKey:@"Center"];
//    
//    anim.completionBlock = ^(POPAnimation *animation, BOOL finished){
//        self.isFavour = YES;
//        [_favour addTarget:self action:@selector(cancelFavour) forControlEvents:UIControlEventTouchUpInside];
//        [self revivificationFavour];
//    };
//}
//
///**
// *  取消点赞
// */
//- (void)cancelFavour {
//    
//    [_favour setBackgroundImage:[UIImage imageNamed:@"heart_gray"] forState:UIControlStateNormal];
//
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
//    anim.springBounciness    = 0;
//    anim.springSpeed         = 20;
//    [_favour pop_addAnimation:anim forKey:@"Center"];
//    anim.completionBlock = ^(POPAnimation *animation, BOOL finished){
//        self.isFavour = NO;
//        [_favour addTarget:self action:@selector(favourTheTieZi) forControlEvents:UIControlEventTouchUpInside];
//        [self revivificationFavour];
//    };
//}
//
///**
// *  还原图片大小
// */
//- (void)revivificationFavour {
//    
//    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
//    anim.springBounciness    = 0;
//    anim.springSpeed         = 20;
//    [_favour pop_addAnimation:anim forKey:@"Center"];
//    
//}

@end











