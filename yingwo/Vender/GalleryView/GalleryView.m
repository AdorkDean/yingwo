//  GalleryViewDemo
//
//  Created by line0 on 13-5-27.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

#import "GalleryView.h"
#import "YWIndicatorView.h"

@interface GalleryView ()

@property (nonatomic, strong) UIScrollView        *scrollView;
@property (assign, nonatomic) NSInteger           currentPage;

@property (atomic,    assign) CGFloat             imageLoadProgress;
@property (nonatomic, assign) CGFloat             totalProgress;
@property (nonatomic, strong) YWIndicatorView     *indicatorView;

@end


@implementation GalleryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    self.scrollView                                = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate                       = self;
    self.scrollView.pagingEnabled                  = YES;
    self.scrollView.userInteractionEnabled         = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator   = NO;
    self.scrollView.clipsToBounds                  = YES;
    [self addSubview:self.scrollView];
    
    self.maximumZoomScale = 3;
    self.minimumZoomScale = 1;
    
    [self addSubview:self.pageLabel];
}

- (UILabel *)pageLabel {
    if (_pageLabel == nil) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        _pageLabel.center = CGPointMake(self.center.x, 40);
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.textColor = [UIColor whiteColor];
    }
    return _pageLabel;
}

/*
- (void)setImages:(NSArray *)images
{
    _images = images;
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width * images.count, self.scrollView.bounds.size.height)];

    for (int i = 0; i < images.count; i++)
    {
        CGRect rect = CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        ZoomScrollView *zoomScrollView = [[ZoomScrollView alloc] initWithFrame:rect andImage:[images objectAtIndex:i] atIndex:i];
        [self.scrollView addSubview:zoomScrollView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [singleTap setNumberOfTouchesRequired:1];
        [singleTap setNumberOfTapsRequired:1];
        [zoomScrollView addGestureRecognizer:singleTap];
        
        [singleTap requireGestureRecognizerToFail:zoomScrollView.doubleTapGesture];
    }
}
*/


- (void)setMaximumZoomScale:(CGFloat)maximumZoomScale
{
    _maximumZoomScale = maximumZoomScale;
    
    for (int i = 0; i < self.images.count; i++)
    {
        ZoomScrollView *zoomScrollView = [[ZoomScrollView alloc]init];
        [zoomScrollView setMaximumZoomScale:maximumZoomScale];
    }
}

- (void)setMinimumZoomScale:(CGFloat)minimumZoomScale
{
    _minimumZoomScale = minimumZoomScale;
    
    for (int i = 0; i < self.images.count; i++)
    {
        ZoomScrollView *zoomScrollView = [[ZoomScrollView alloc]init];
        [zoomScrollView setMinimumZoomScale:minimumZoomScale];
    }
}

- (void)setImages:(NSArray *)imageViews showAtIndex:(NSInteger)index{
    
    _imageViews = imageViews;
        
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width * imageViews.count,
                                               self.scrollView.bounds.size.height)];
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*index, 0);
    
    
    for (int i = 0; i < imageViews.count; i++)
    {
        CGRect rect = CGRectMake(self.scrollView.frame.size.width * i,
                                 0,
                                 self.scrollView.frame.size.width,
                                 self.scrollView.frame.size.height);
        
        ZoomScrollView *zoomScrollView = [[ZoomScrollView alloc] initWithFrame:rect
                                                                  andImageView:[imageViews objectAtIndex:i]
                                                                       atIndex:i];
        
        [self.scrollView addSubview:zoomScrollView];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(singleTap:)];
        [singleTap setNumberOfTouchesRequired:1];
        [singleTap setNumberOfTapsRequired:1];
        [zoomScrollView addGestureRecognizer:singleTap];
        
        [singleTap requireGestureRecognizerToFail:zoomScrollView.doubleTapGesture];
    }
    
    self.pageLabel.text = [NSString stringWithFormat:@"%lu/%lu",index+1,self.imageViews.count];
    //currentPage 从0开始计算
    self.currentPage = index;
}

- (void)setImageViews:(NSArray *)imageViews
withImageUrlArrEntity:(NSArray *)entities
          showAtIndex:(NSInteger)index {
    
    _imageViews        = imageViews;
    _imageUrlArrEntity = entities;

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width * imageViews.count,
                                               self.scrollView.bounds.size.height)];
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width*index, 0);
    
    for (int i = 0; i < imageViews.count; i++)
    {
        CGRect rect = CGRectMake(self.scrollView.frame.size.width * i,
                                 0,
                                 self.scrollView.frame.size.width,
                                 self.scrollView.frame.size.height);
        
        ZoomScrollView *zoomScrollView = [[ZoomScrollView alloc] initWithFrame:rect
                                                                  andImageView:[imageViews objectAtIndex:i]
                                                                       atIndex:i];
        //给一个tag，因为图片总是要下载前后三张，方便找到位置
        zoomScrollView.tag = 200+i;
        
        [self.scrollView addSubview:zoomScrollView];
        
        //单击事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(singleTap:)];
        [singleTap setNumberOfTouchesRequired:1];
        [singleTap setNumberOfTapsRequired:1];
        [zoomScrollView addGestureRecognizer:singleTap];
        
        [singleTap requireGestureRecognizerToFail:zoomScrollView.doubleTapGesture];
        
    }
    
    if ([YWNetworkTools networkStauts]) {
        [self loadImageWithCurrentPage:index];
    }

    self.pageLabel.text = [NSString stringWithFormat:@"%lu/%lu",index+1,self.imageViews.count];
    //currentPage 从0开始计算
    self.currentPage = index;
}

- (void)removeImageView{
    
    //获取被放大的小图
    UIImageView *currentSmallView    = [self.imageViews objectAtIndex:self.currentPage];
    //获取放大后的图
    UIImageView *currentBigImageView = [self viewWithTag:self.currentPage+1];
    
    //获取被点击的图片的zoomScrollView，如果图片放大了，需要设置zoom为1
    ZoomScrollView *zoomScrollView = (ZoomScrollView *)currentBigImageView.superview;
    
    //先去除背景色
    self.backgroundColor             = [UIColor clearColor];
    self.pageLabel.textColor         = [UIColor clearColor];

    [UIView animateWithDuration:0.3
                     animations:^{
        
                         [zoomScrollView setZoomScale:1];
                         currentBigImageView.frame = currentSmallView.frame;
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.delegate galleryView:self removePageAtIndex:self.currentPage];
    }];
}


#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat   pageWidth   = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (currentPage != self.currentPage)
    {
        [self loadImageWithCurrentPage:self.currentPage];

    }
    self.currentPage = currentPage;
    
    if ([self.delegate respondsToSelector:@selector(galleryView:didShowPageAtIndex:)])
    {
        [self.delegate galleryView:self didShowPageAtIndex:currentPage];
    }
    
    
    self.pageLabel.text = [NSString stringWithFormat:@"%lu/%lu",currentPage+1,self.imageViews.count];
    
}


#pragma mark - Tap

- (void)singleTap:(UITapGestureRecognizer *)tap
{
    if (tap.numberOfTapsRequired == 1)
    {
        ZoomScrollView *zoomScrollView = (ZoomScrollView *)tap.view;
        
        if ([self.delegate respondsToSelector:@selector(galleryView:didSelectPageAtIndex:)])
        {
            [self.delegate galleryView:self didSelectPageAtIndex:zoomScrollView.index];
        }
    }
}

//预先加载前后两张图片
- (void)loadImageWithCurrentPage:(NSInteger)currentPage {
    
    //左边和右边都有图片，并且两张都加载
    if (currentPage+1 < self.imageViews.count && currentPage >0) {
        
        self.totalProgress = 3.0;
        
        //滑动到当前展示的图片
        ZoomScrollView *centerZoomScrollView = [self.scrollView viewWithTag:200+currentPage];
        //展示左边的图片
        ZoomScrollView *leftZoomScrollView   = [self.scrollView viewWithTag:200+currentPage-1];
        //展示右边的图片
        ZoomScrollView *rightZoomScrollView  = [self.scrollView viewWithTag:200+currentPage+1];
        
        [self resizeImageViewByzoomScrollView:centerZoomScrollView atIndex:currentPage];
        [self resizeImageViewByzoomScrollView:leftZoomScrollView atIndex:currentPage-1];
        [self resizeImageViewByzoomScrollView:rightZoomScrollView atIndex:currentPage+1];
        
    }
    //滑动到第一张图片，只加载第一张和第二张
    else if (currentPage == 0 && self.imageViews.count > 1)
    {
        
        self.totalProgress = 2.0;

        //滑动到当前展示的图片
        ZoomScrollView *centerZoomScrollView = [self.scrollView viewWithTag:200+currentPage];
        //展示右边的图片
        ZoomScrollView *rightZoomScrollView  = [self.scrollView viewWithTag:200+currentPage+1];
        
        [self resizeImageViewByzoomScrollView:centerZoomScrollView atIndex:currentPage];
        [self resizeImageViewByzoomScrollView:rightZoomScrollView atIndex:currentPage+1];
        
    }
    //滑动到最后一张图片，只加载最后一张和最后第二张图片
    else if (currentPage +1 == self.imageViews.count && currentPage != 0)
    {
        self.totalProgress = 2.0;

        //滑动到当前展示的图片
        ZoomScrollView *centerZoomScrollView = [self.scrollView viewWithTag:200+currentPage];
        //展示左边的图片
        ZoomScrollView *leftZoomScrollView   = [self.scrollView viewWithTag:200+currentPage-1];
        
        [self resizeImageViewByzoomScrollView:centerZoomScrollView atIndex:currentPage];
        [self resizeImageViewByzoomScrollView:leftZoomScrollView atIndex:currentPage-1];
    }
    //只有一张图片
    else if (self.imageViews.count == 1)
    {
        self.totalProgress = 1.0;
        
        //滑动到当前展示的图片
        ZoomScrollView *centerZoomScrollView = [self.scrollView viewWithTag:200+currentPage];
        
        [self resizeImageViewByzoomScrollView:centerZoomScrollView atIndex:currentPage];
    }
    
}

- (void)resizeImageViewByzoomScrollView:(ZoomScrollView *)zoomScrollView atIndex:(NSInteger)index{
  
    [self.indicatorView removeFromSuperview];
    
    ImageViewEntity *imageEntity = [self.imageUrlArrEntity objectAtIndex:index];
    
    //添加进度指示器
    YWIndicatorView *indicatorView            = [[YWIndicatorView alloc] init];
    indicatorView.viewMode                    = YWIndicatorViewModeLoopDiagram;
    indicatorView.center                      = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5,
                                                            [UIScreen mainScreen].bounds.size.height * 0.5);
    self.indicatorView                        = indicatorView;
    [self addSubview:self.indicatorView];
    __weak __typeof(self)weakSelf = self;
    [zoomScrollView.imageView sd_setImageWithURL:[NSURL URLWithString:imageEntity.imageName] placeholderImage:nil
                                         options:SDWebImageRetryFailed
                                        progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                            //显示进度
                                            __strong __typeof(weakSelf)strongSelf       = weakSelf;
                                            strongSelf.indicatorView.progress           = (CGFloat)receivedSize / expectedSize;
    }
                                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                                     // imageEntity.isDownload = YES;
                                           
                                           __strong __typeof(weakSelf)strongSelf = weakSelf;
                                           [strongSelf.indicatorView removeFromSuperview];

                                           [zoomScrollView resizeImageViewWithImage:image];
                                           
                                           if (zoomScrollView.zoomScale != 1) {
                                               [zoomScrollView setZoomScale:1.0];
                                           }

    }];
    
    //  下载后一张
//    if (zoomScrollView.tag == 200 && self.imageViews.count != 1 && self.imageViews.count-1 > index) {
//        
//        ZoomScrollView *rightZoomScrollView = [self.scrollView viewWithTag:201];
//        ImageViewEntity *rigthImageEntity = [self.imageUrlArrEntity objectAtIndex:index+1];
//
//        [rightZoomScrollView.imageView sd_setImageWithURL:[NSURL URLWithString:rigthImageEntity.imageName]
//                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                                    
//                                                    [rightZoomScrollView resizeImageViewWithImage:image];
//        }];
//    }
    
//    [YWAvatarBrowser downloadImageWithUrl:imageEntity
//                                 progress:nil
//                                  success:^(UIImage *image) {
//                                      
//                                      [SVProgressHUD dismiss];
//                                      [zoomScrollView resizeImageViewWithImage:image];
//                                      
//                                  } failure:^(NSString *error) {
//                                      
//                                  }];
    
}



@end
