//
//  YWAnnounceTextView.h
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWKeyboardToolView.h"

@interface YWAnnounceTextView : UIView<UITextViewDelegate>

@property (nonatomic, strong) HPGrowingTextView  *contentTextView;
@property (nonatomic, strong) YWKeyboardToolView *keyboardToolView;

@end
