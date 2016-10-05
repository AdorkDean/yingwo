//  GalleryViewDemo
//
//  Created by line0 on 13-5-27.
//  Copyright (c) 2013年 makeLaugh. All rights reserved.
//

#import "ZoomScrollView.h"
#import "HomeController.h"

@interface ZoomScrollView ()
@property (nonatomic, strong) UIAlertController      *alertView;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
@property (nonatomic, strong) UIImageView            *imageView;
@property (nonatomic, assign) NSInteger              index;
@property (nonatomic, assign) BOOL                   doubleTapped;

@end

@implementation ZoomScrollView

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image atIndex:(NSInteger)index
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.index = index;

        [self setMinimumZoomScale:1];
        [self setMaximumZoomScale:3];
        [self setZoomScale:1];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setDelegate:self];
        
        CGFloat height = frame.size.width / image.size.width * image.size.height;
        self.imageView = [[UIImageView alloc] initWithImage:image];
        [self.imageView setFrame:CGRectMake(0, (self.frame.size.height - height) / 2,
                                            self.frame.size.width,
                                            height)];
        
        [self.imageView setUserInteractionEnabled:YES];
        [self addSubview:self.imageView];
        
        self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handleDoubleTap:)];
        [self.doubleTapGesture setNumberOfTapsRequired:2];
        [self.imageView addGestureRecognizer:self.doubleTapGesture];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andImageView:(UIImageView *)imageView atIndex:(NSInteger)index
{
    self = [self initWithFrame:frame];
    if (self)
    {
        self.index = index;
        
        [self setMinimumZoomScale:1];
        [self setMaximumZoomScale:3];
        [self setZoomScale:1];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setDelegate:self];
        
        CGFloat height       = frame.size.width / imageView.image.size.width * imageView.image.size.height;
        self.imageView       = [[UIImageView alloc] initWithFrame:imageView.frame];
        self.imageView.image = imageView.image;
        self.imageView.tag   = imageView.tag;

        [UIView animateWithDuration:0.3 animations:^{
            
            [self.imageView setFrame:CGRectMake(0, (self.frame.size.height - height) / 2,
                                                self.frame.size.width, height)];

        }];
        
        [self.imageView setUserInteractionEnabled:YES];
        [self addSubview:self.imageView];
        
        self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(handleDoubleTap:)];
        [self.doubleTapGesture setNumberOfTapsRequired:2];
        [self.imageView addGestureRecognizer:self.doubleTapGesture];
        
        //长按事件
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(longPress:)];
        longPress.minimumPressDuration          = 0.5f;
        [self.imageView addGestureRecognizer:longPress];

    //    [longPress requireGestureRecognizerToFail:self.doubleTapGesture];
    }
    return self;
}



- (void)resizeImageViewWithImage:(UIImage *)newImage {
    
    CGFloat height       = self.frame.size.width / newImage.size.width * newImage.size.height;
    self.imageView.image = newImage;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self.imageView setFrame:CGRectMake(0,
                                            (self.frame.size.height - height) / 2,
                                            self.frame.size.width,
                                            height)];
        
    }];
    
}


#pragma mark long press

- (void)longPress:(UILongPressGestureRecognizer *)press {
    
    
    if (_alertView == nil) {
        _alertView = [UIAlertController alertControllerWithTitle:@"提示"
                                                         message:nil
                                                  preferredStyle:UIAlertControllerStyleActionSheet];
        [_alertView addAction:[UIAlertAction actionWithTitle:@"保存图片"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [SVProgressHUD showLoadingStatusWith:@""];
                                                         UIImageView *pressImageView = (UIImageView *)[press view];
                                                         
                                                         [self saveImageToAlbum:pressImageView.image];
                                                         
                                                         _alertView = nil;

                                                     }]];
        
        [_alertView addAction:[UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         _alertView = nil;
                                                     }]];
        
        [self.window.rootViewController presentViewController:_alertView animated:YES completion:nil];

    }
    
}

/**
 *  将图片保存至相册
 *
 *  @param image
 */
- (void)saveImageToAlbum:(UIImage *)image {
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [SVProgressHUD showErrorStatus:@"保存失败" afterDelay:HUD_DELAY];
    }
    else
    {
        [SVProgressHUD showSuccessStatus:@"保存成功" afterDelay:HUD_DELAY];
    }
}


#pragma mark - Zoom methods

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    self.doubleTapped = !self.doubleTapped;

    float newScale = 1;
    if (self.doubleTapped)
        newScale = self.zoomScale * 3;
    else
        newScale = 1;
    CGPoint center = [gesture locationInView:gesture.view];
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:center];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)relayoutImageView
{
    CGPoint imageCenter = CGPointZero;
    if (self.contentSize.height <= self.frame.size.height)
        imageCenter = CGPointMake(self.contentSize.width/2, self.frame.size.height/2);
    else
        imageCenter = CGPointMake(self.contentSize.width/2, self.contentSize.height/2);
    
    [self.imageView setCenter:imageCenter];
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
    
    [self relayoutImageView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self relayoutImageView];
}


@end
