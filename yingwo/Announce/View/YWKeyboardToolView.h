//
//  YWKeyboardToolView.h
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWKeyboardToolViewProtocol;

@interface YWKeyboardToolView : UIView

@property (nonatomic, strong) UIButton                   *face;
@property (nonatomic, strong) UIButton                   *keyborad;
@property (nonatomic, strong) UIButton                   *photo;
@property (nonatomic, strong) UIButton                   *returnKeyBoard;
@property (nonatomic, assign) id<YWKeyboardToolViewProtocol> delegate;

@end

@protocol YWKeyboardToolViewProtocol <NSObject>

@optional
- (void)didSelectedEmoji;
- (void)didSelectedKeyboard;

@end