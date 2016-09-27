//
//  YWSpringButton.h
//  yingwo
//
//  Created by apple on 16/8/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWSpringButtonDelegate;

@interface YWSpringButton : UIButton

@property (nonatomic,assign ) BOOL                   isSpring;
@property (nonatomic, strong) UIImage                *seletedImage;
@property (nonatomic, strong) UIImage                *cancelImage;

@property (nonatomic, assign) id<YWSpringButtonDelegate> delegate;

@property (nonatomic, assign) int                    post_id;

- (instancetype)initWithSelectedImage:(UIImage *)seletedImage andCancelImage:(UIImage *)cancelImage ;

@end

@protocol YWSpringButtonDelegate <NSObject>

/**
 *  点赞所在的贴子
 *
 *  @param postId 贴子Id
 *  @param model  YES or NO (1 或 0)
 */
- (void)didSelectSpringButtonOnView:(UIView *)view postId:(int)postId model:(int)model;

@end