//
//  YWDetailBaseTableViewCell.h
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWHomeCellLabelView.h"
#import "YWDetailMasterView.h"
#import "YWDetailTopView.h"
#import "YWContentLabel.h"
#import "YWDetailCellBottomView.h"
#import "YWCommentView.h"

@protocol YWDetailTabeleViewDelegate;
@protocol YWCommentViewDelegate;

@interface YWDetailBaseTableViewCell : UITableViewCell

//YWDetailTableViewCell members
@property (nonatomic, strong ) YWDetailTopView            *topView;
@property (nonatomic, strong ) YWDetailMasterView         *masterView;
//图片容器
@property (nonatomic, strong ) UIView                     *bgImageView;
//评论容器
@property (nonatomic, strong ) UIView                     *bgCommentView;
@property (nonatomic, strong ) YWContentLabel             *contentLabel;
@property (nonatomic, strong ) YWDetailCellBottomView     *bottomView;
@property (nonatomic, assign ) NSInteger                  imageCount;
@property (nonatomic, assign ) id<YWDetailTabeleViewDelegate> delegate;

@property (nonatomic, assign ) id<YWCommentViewDelegate>  commentDelegate;


//common
- (void)createSubview;
- (void)addImageViewByImageArr:(NSMutableArray *)imageArr;

//YWDetailReplyCell members
- (void)addCommentViewByCommentArr:(NSMutableArray *)commentArr withMasterId:(NSInteger)master_id;

@end

@protocol YWDetailTabeleViewDelegate <NSObject>

//点击图片查看
- (void)didSeletedImageView:(UIImageView *)seletedImageView;
- (void)didSelectCommentView:(YWCommentView *)commentView;

@end
