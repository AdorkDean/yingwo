//
//  YWImageMessageCell.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWImageMessageCell.h"

@implementation YWImageMessageCell

- (void)createSubview {
    
    _imageBottomView = [[YWMessageImageBottomView alloc] init];
    
    [self.backgroundView addSubview:_imageBottomView];
    
    [_imageBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView.mas_left).offset(5);
        make.right.equalTo(self.backgroundView.mas_right).offset(-5);
        make.top.equalTo(self.replyContent.mas_bottom).offset(10);
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-10);
    }];
 
    [self.replyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backgroundView).offset(-5);
        make.left.equalTo(self.backgroundView).offset(5);
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.bottom.equalTo(_imageBottomView.mas_top).offset(-5);
    }];
    
}

- (void)addSingleTapForBottomView {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(singleTap)];
    
    [_imageBottomView addGestureRecognizer:tap];
    
}

- (void)singleTap {
    
    if ([self.delegate respondsToSelector:@selector(didSelectedTieZi:)]) {
        
        [self.delegate didSelectedTieZi:self.messageEntity];
    }
    
}

@end
