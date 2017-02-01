//
//  YWDetailReplyView.h
//  yingwo
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWKeyboardToolView.h"

@interface YWDetailCommentView : UIView

@property (nonatomic, strong) UIView                     *backgroundView;

@property (nonatomic, strong) UIButton                   *face;
@property (nonatomic, strong) UIButton                   *keyborad;
@property (nonatomic, strong) HPGrowingTextView          *messageTextView;
@property (nonatomic, assign) id<YWKeyboardToolViewProtocol> delegate;


@end
