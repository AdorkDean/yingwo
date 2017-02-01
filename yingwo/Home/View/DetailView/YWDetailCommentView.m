//
//  YWDetailReplyView.m
//  yingwo
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDetailCommentView.h"

@implementation YWDetailCommentView {
    BOOL _isSelected;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubview];
        
        self.backgroundColor      = [UIColor whiteColor];
    }
    return self;
}


- (void)createSubview {
    
    _backgroundView                   = [[UIView alloc] init];

    _face                             = [UIButton buttonWithType:UIButtonTypeCustom];
    _keyborad                         = [UIButton buttonWithType:UIButtonTypeCustom];

    _messageTextView                  = [[HPGrowingTextView alloc] init];

    //最多四行高度
    _messageTextView.maxNumberOfLines = 4;

    _face.frame            = CGRectMake(10, 5, 30, 30);
    _keyborad.frame        = CGRectMake(10, 10, 30, 20);
    _backgroundView.frame  = CGRectMake(50, 5, SCREEN_WIDTH-60, 30);
    _messageTextView.frame = CGRectMake(60, 5, SCREEN_WIDTH-70, 30);

    _messageTextView.placeholder     = @"请输入你评论";
    _messageTextView.backgroundColor = [UIColor clearColor];
    _messageTextView.returnKeyType   = UIReturnKeyDone;
    

    _backgroundView.layer.cornerRadius  = 10;
    _backgroundView.layer.masksToBounds = YES;
    _backgroundView.backgroundColor     = [UIColor colorWithHexString:THEME_COLOR_5 alpha:0.5];

    
    [_face setBackgroundImage:[UIImage imageNamed:@"emoji_G"]
                     forState:UIControlStateNormal];
    [_keyborad setBackgroundImage:[UIImage imageNamed:@"keyboard_green"]
                         forState:UIControlStateNormal];
    [_face addTarget:self
              action:@selector(selectedEmoji)
    forControlEvents:UIControlEventTouchUpInside];
   
    [_keyborad addTarget:self
              action:@selector(selectedKeyboard)
    forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_face];
    [self addSubview:_keyborad];
    [self addSubview:_backgroundView];
    [self addSubview:_messageTextView];

//    [_face mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.centerY.equalTo(self);
//    }];
//    
//    [_keyborad mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(10);
//        make.centerY.equalTo(self);
//    }];
//    
//    //_messageTextView 的高度一定要比设置的字体大小要大！！！！这里设置为31，字体为14号
//    [_messageTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_face.mas_right).offset(20);
//        make.right.equalTo(self.mas_right).offset(-20);
//        make.height.equalTo(@31).priorityLow();
//        make.centerY.equalTo(self);
//    }];
//    
//    [self.backgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_face.mas_right).offset(10);
//        make.height.equalTo(_messageTextView.mas_height);
//        make.right.equalTo(self.mas_right).offset(-10);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
//    
    _keyborad.hidden = YES;
    
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
