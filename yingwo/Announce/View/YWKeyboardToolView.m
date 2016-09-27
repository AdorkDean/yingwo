//
//  YWKeyboardToolView.m
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWKeyboardToolView.h"

@implementation YWKeyboardToolView {
    BOOL _isSelected;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createSubview {

    _face           = [UIButton buttonWithType:UIButtonTypeCustom];
    _keyborad       = [UIButton buttonWithType:UIButtonTypeCustom];
    _photo          = [UIButton buttonWithType:UIButtonTypeCustom];
    _returnKeyBoard = [UIButton buttonWithType:UIButtonTypeCustom];

    _face.frame           = CGRectMake(15, 10, 25, 25);
    _photo.frame          = CGRectMake(60, 10, 30, 24);
    _keyborad.frame       = CGRectMake(15, 13, 30, 21);
    _returnKeyBoard.frame = CGRectMake(SCREEN_WIDTH-53, 15, 33, 21);

    _face.hidden = NO;
    _keyborad.hidden = YES;
    
    [_face setBackgroundImage:[UIImage imageNamed:@"emoji_G"] forState:UIControlStateNormal];
    [_keyborad setBackgroundImage:[UIImage imageNamed:@"keyboard_green"] forState:UIControlStateNormal];
    [_photo setBackgroundImage:[UIImage imageNamed:@"picture_green"] forState:UIControlStateNormal];
    [_returnKeyBoard setBackgroundImage:[UIImage imageNamed:@"keyboard_gray"] forState:UIControlStateNormal];
    
    [_face addTarget:self action:@selector(selectedEmoji) forControlEvents:UIControlEventTouchUpInside];
    [_keyborad addTarget:self action:@selector(selectedKeyboard) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:_face];
    [self addSubview:_keyborad];
    [self addSubview:_photo];
    [self addSubview:_returnKeyBoard];

}

- (void)selectedEmoji {

    if ([self.delegate respondsToSelector:@selector(didSelectedEmoji)]) {
        [self.delegate didSelectedEmoji];
    }
    
    _face.hidden     = YES;
    _keyborad.hidden = NO;
}

- (void)selectedKeyboard {
    
    if ([self.delegate respondsToSelector:@selector(didSelectedKeyboard)]) {
        [self.delegate didSelectedKeyboard];
    }
    
    _keyborad.hidden = YES;;
    _face.hidden     = NO;
}



@end
