//
//  AnnounceController.h
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^returnValueBlock) (BOOL reloaded2);
typedef void(^ReplyTieZiBlock)(NSDictionary *paramters,BOOL isRelease);

@protocol AnnounceControllerDelegate;

@interface AnnounceController : BaseViewController

//判断是否是跟帖
@property (nonatomic, assign) BOOL                       isFollowTieZi;

//判断是否是发话题
@property (nonatomic, assign) BOOL                       isTopic;

//跟贴的id
@property (nonatomic, assign) NSInteger                  post_id;

//话题的id
@property (nonatomic, assign) int                        topic_id;

@property (nonatomic, copy)NSString                     *topic_title;

@property (nonatomic,assign ) id<AnnounceControllerDelegate> delegate;

@property (nonatomic, copy) returnValueBlock            returnValueBlock;

@property (nonatomic, assign)BOOL reloaded2;

//回调穿参，返回刚发布的贴子内容
@property (nonatomic, copy)  ReplyTieZiBlock replyTieZiBlock;

- (void)returnValue:(returnValueBlock)block;

@end

@protocol AnnounceControllerDelegate <NSObject>

- (void)jumpToHomeController;

@end
