//  GalleryViewDemo
//
//  Created by line0 on 13-5-27.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZoomScrollView.h"

@protocol GalleryViewDelegate;

/**
 *  github上的开源框架，做了些改动，添加注释的都是改动了的
 *  图片点击放大、切换的封装类
 *
 */
@interface GalleryView : UIView <UIScrollViewDelegate>
@property (nonatomic, assign) id <GalleryViewDelegate>    delegate;

@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong          ) UILabel      *pageLabel;

@property (assign, nonatomic, readonly) NSInteger    currentPage;

@property (assign, nonatomic          ) CGFloat      maximumZoomScale;//默认为3
@property (assign, nonatomic          ) CGFloat      minimumZoomScale;//默认为1

@property (strong, nonatomic          ) NSArray      *images;
@property (strong, nonatomic          ) NSArray      *imageViews;
@property (strong, nonatomic          ) NSArray      *imageUrlArrEntity;

/**
 *  设置需要展示的UIImage，并且确定展示第index个
 *
 *  @param imageViews   需要展示的UIImageView数组
 *  @param index        但前点击需要展示的索引
 */
- (void)setImages:(NSArray *)imageViews showAtIndex:(NSInteger)index;

/**
 *  设置需要展示的UIImage，并且确定展示第index个
 *
 *  @param imageViews 需要展示的UIImageView数组
 *  @param entities   需要展示的ImageViewEntity数组
 *  @param index      但前点击需要展示的索引
 */
- (void)setImageViews:(NSArray *)imageViews
withImageUrlArrEntity:(NSArray *)entities
          showAtIndex:(NSInteger)index;

/**
 *  点击消除
 *
 */
- (void)removeImageView;

@end



@protocol GalleryViewDelegate <NSObject>

@optional

//滑动时，切换到某一页时调用
- (void)galleryView:(GalleryView *)galleryView didShowPageAtIndex:(NSInteger)pageIndex;

//点击某一页时调用
- (void)galleryView:(GalleryView *)galleryView didSelectPageAtIndex:(NSInteger)pageIndex;

/**
 *  移除所有的展现的视图
 *
 *  @param galleryView
 *  @param pageIndex
 */
- (void)galleryView:(GalleryView *)galleryView removePageAtIndex:(NSInteger)pageIndex;

@end
