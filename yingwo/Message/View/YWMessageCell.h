//
//  YWMessageCell.h
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWMessageTopView.h"
#import "YWMessageBottomView.h"
#import "MessageEntity.h"

@protocol YWMessageCellDelegate;

@interface YWMessageCell : UITableViewCell

@property (nonatomic, strong) MessageEntity       *messageEntity;
@property (nonatomic, strong) YWMessageTopView    *topView;
@property (nonatomic, strong) YWContentLabel      *replyContent;
@property (nonatomic, strong) YWMessageBottomView *bottomView;
//点赞的♥️
@property (nonatomic, strong) UIImageView         *favor;

@property (nonatomic, assign) id<YWMessageCellDelegate> delegate;

- (void)createSubview;

- (void)addFavorImageView;

//添加点击事件
- (void)addSingleTapForBottomView ;

@end

@protocol YWMessageCellDelegate <NSObject>

- (void)didSelectedTieZi:(MessageEntity *)messageEntity;

@end
