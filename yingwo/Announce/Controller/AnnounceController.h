//
//  AnnounceController.h
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "YWAnnounceTextView.h"
#import "AnnounceModel.h"

@protocol AnnounceControllerDelegate;

@interface AnnounceController : BaseViewController

@property (nonatomic, strong) YWAnnounceTextView         *announceTextView;

//跟贴的id
@property (nonatomic, assign) NSInteger                  post_id;

@property (nonatomic, strong) AnnounceModel              *viewModel;

@property (nonatomic,assign ) id<AnnounceControllerDelegate> delegate;

- (instancetype)initWithTieZiId:(int)postId title:(NSString *)title;

/**
 *  既有图片又有内容
 *
 *  @param photoArr 图片数组
 *  @param content  贴子内容
 */
- (void)postTieZiWithImages:(NSArray *)photoArr andContent:(NSString *)content;

- (void)backToFarword ;

@end

@protocol AnnounceControllerDelegate <NSObject>
@optional
- (void)AlbumDidFinishPick:(NSArray *)assets;
- (void)jumpToHomeController;

@end
