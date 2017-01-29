//
//  HotDiscussBottomView.h
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWHotDiscussBottomView : UIView

@property (nonatomic, strong) NSArray     *imageURLArr;

@property (nonatomic, strong) UILabel     *messageNumLabel;

@property (nonatomic, strong) UILabel     *timeLabel;

@property (nonatomic, strong) UIImageView *messageImageView;

@property (nonatomic, strong) UIImageView *clockImageView;

- (void)addHeadImagesWith:(NSArray *)imageURLArr;


@end
