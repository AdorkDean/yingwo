//
//  YWMessageCell.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWMessageCell.h"

@implementation YWMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self createCommonSubview];
        [self createSubview];
        [self addSingleTapForBottomView];
        
        self.backgroundColor                   = [UIColor clearColor];
        self.backgroundView.layer.cornerRadius = 10;
        self.selectionStyle                    = UITableViewCellSelectionStyleNone;
        self.backgroundView.backgroundColor    = [UIColor whiteColor];


        
    }
    return self;
}

- (void)createCommonSubview {

    self.backgroundView = [[UIView alloc] init];
    _topView            = [[YWMessageTopView alloc] init];
    _replyContent       = [[YWContentLabel alloc] initWithFrame:CGRectZero];
    
    [_topView.deleteBtn addTarget:self action:@selector(deleteTap) forControlEvents:UIControlEventTouchUpInside];
    [_topView.headImageView addTapAction:@selector(headTap) target:self];
    [_topView.nickname      addTapAction:@selector(headTap) target:self];
    
    [self.contentView addSubview:self.backgroundView];
    [self.backgroundView addSubview:_topView];
    [self.backgroundView addSubview:_replyContent];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 2.5, 10));
    }];
    
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.backgroundView);
        make.height.equalTo(@40);
    }];
    

    
}

- (void)createSubview {
    
    _bottomView = [[YWMessageBottomView alloc] init];
    
    [self.backgroundView addSubview:_bottomView];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView.mas_left).offset(10);
        make.right.equalTo(self.backgroundView.mas_right).offset(-10);
        make.top.equalTo(_replyContent.mas_bottom).offset(10);
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-10);
        make.height.equalTo(@30);
    }];
    
    [_replyContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundView).offset(-5);
        make.left.equalTo(self.backgroundView).offset(5);
        make.top.equalTo(_topView.mas_bottom).offset(10);
        make.bottom.equalTo(_bottomView.mas_top).offset(-5);
    }];
    
}

- (void)addFavorImageView {
    
    _favor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart_red"]];
    
    [self.contentView addSubview:self.favor];
    
    [_favor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyContent.mas_left).offset(50);
        make.centerY.equalTo(_replyContent);
        make.width.height.equalTo(@25);
    }];
    
}

- (void)addSingleTapForBottomView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(singleTap)];
    
    [_bottomView addGestureRecognizer:tap];

}

- (void)singleTap {
    
    if ([self.delegate respondsToSelector:@selector(didSelectedTieZi:)]) {
        
        [self.delegate didSelectedTieZi:self.messageEntity];
    }
    
}

- (void)deleteTap {
    if ([self.delegate respondsToSelector:@selector(didSelectedDeleteBtn:withEntity:)]) {
        [self.delegate didSelectedDeleteBtn:self.topView.deleteBtn withEntity:self.messageEntity];
    }
}

- (void)headTap {
    if ([self.delegate respondsToSelector:@selector(didSelectHeadImageWithEntity:)]) {
        [self.delegate didSelectHeadImageWithEntity:self.messageEntity];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
