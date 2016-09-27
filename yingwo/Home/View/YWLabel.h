//
//  YWLabel.h
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWLabelDelegate;

@interface YWLabel : UIView

@property (nonatomic, strong) UILabel         *label;
@property (nonatomic, assign) int             topic_id;
@property (nonatomic, assign) id<YWLabelDelegate> delegate;

@end

@protocol YWLabelDelegate <NSObject>

- (void)didSelectLabel:(YWLabel *)label;

@end
