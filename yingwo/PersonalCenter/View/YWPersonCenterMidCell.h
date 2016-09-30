//
//  YWPersonCenterMidCell.h
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWPersonCenterMidCell : UIImageView

@property (nonatomic, strong) UILabel *friends;
@property (nonatomic, strong) UILabel *attentions;
@property (nonatomic, strong) UILabel *fans;
@property (nonatomic, strong) UILabel *visitors;

- (instancetype)initWithFriends:(NSString *)friendNum
                     attentions:(NSString *)attentionNum
                           fans:(NSString *)fansNum
                       visitors:(NSString *)visitorNum;

@end
