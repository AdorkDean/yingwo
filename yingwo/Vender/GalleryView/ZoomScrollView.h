//  GalleryViewDemo
//
//  Created by line0 on 13-5-27.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *  此类用于图片点击放大的UIScrollView，用来放大图片和限制图片放大倍数
 */
@interface ZoomScrollView : UIScrollView <UIScrollViewDelegate>

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image atIndex:(NSInteger)index;

@property (nonatomic, strong, readonly) UIImageView   *imageView;
@property (nonatomic, assign, readonly) NSInteger     index;
@property (nonatomic, assign, readonly) BOOL          doubleTapped;

@property (nonatomic, strong, readonly) UITapGestureRecognizer *doubleTapGesture;

/**
 *  添加图片
 *
 *  @param frame
 *  @param imageView
 *  @param index
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame andImageView:(UIImageView *)imageView atIndex:(NSInteger)index;

/**
 *  添加并展示图片，以动画形式展现
 *
 *  @param frame     新frame
 *  @param origin    起点frame
 *  @param imageView 需要展示的UIImageView
 *  @param index     位置
 *
 *  @return 
 */
- (id)initWithFrame:(CGRect)frame withOriginFrame:(Rect)origin andImageView:(UIImageView *)imageView atIndex:(NSInteger)index ;

/**
 *  重新下载图片
 *
 *  @param newImage 新的图片
 */
- (void)resizeImageViewWithImage:(UIImage *)newImage;



@end
