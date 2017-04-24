//
//  YWDetailBaseTableViewCell.h
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWDetailMasterView.h"
#import "YWDetailTopView.h"
#import "YWContentLabel.h"
#import "YWDetailCellBottomView.h"
#import "YWCommentView.h"

@protocol YWDetailTabeleViewDelegate;
@protocol YWCommentViewDelegate;

typedef void(^AvatarImageTapBlock)(UIImageView *imageView,ImageViewItem *imagesItem);

@interface YWDetailBaseTableViewCell : UITableViewCell

//YWDetailTableViewCell members
@property (nonatomic, strong ) YWDetailTopView            *topView;
@property (nonatomic, strong ) YWDetailMasterView         *masterView;
@property (nonatomic, strong ) AvatarImageTapBlock        imageTapBlock;
@property (nonatomic, strong ) ImageViewItem              *imagesItem;

//图片容器
@property (nonatomic, strong ) UIView                     *bgImageView;
//评论容器
@property (nonatomic, strong ) UIView                     *bgCommentView;
@property (nonatomic, strong ) YWContentLabel             *contentLabel;
@property (nonatomic, strong ) YWDetailCellBottomView     *bottomView;
@property (nonatomic, assign ) NSInteger                  imageCount;
@property (nonatomic, assign ) id<YWDetailTabeleViewDelegate> delegate;



//YWDetailReplyCell
@property (nonatomic, assign ) id<YWCommentViewDelegate>  commentDelegate;

@property (nonatomic, strong) YWAlertButton *moreBtn;


//common
- (void)createSubview;

- (void)addImageViewByImageArr:(NSMutableArray *)imageArr;

//YWDetailReplyCell members
- (void)addCommentViewByCommentArr:(NSMutableArray *)commentArr withMasterId:(NSInteger)master_id;

@end

@protocol YWDetailTabeleViewDelegate <NSObject>

- (void)didSelectCommentView:(YWCommentView *)commentView;

- (void)didSelectCommentViewLeftNameWithUserId:(int)userId;

@optional
- (void)didSelectMoreCommentLabelWith:(UIView *)btn;

@optional
- (void)didDeleteRigthContentWithCommentId:(int)postId commentView:(YWCommentView *)comentView;


@end
