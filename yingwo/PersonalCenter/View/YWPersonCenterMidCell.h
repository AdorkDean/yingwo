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

@property (nonatomic, strong) UILabel *friendLabel;
@property (nonatomic, strong) UILabel *attentionLabel;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UILabel *visitorLabel;

- (instancetype)initWithFriends:(NSString *)friendNum
                     attentions:(NSString *)attentionNum
                           fans:(NSString *)fansNum
                       visitors:(NSString *)visitorNum;

@end
