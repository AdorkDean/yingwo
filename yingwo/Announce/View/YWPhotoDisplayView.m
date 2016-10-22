//
//  YWPhotoDisplayView.m
//  yingwo
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWPhotoDisplayView.h"
#import "PhotoUnitView.h"

@implementation YWPhotoDisplayView

- (instancetype)init {
    if (self = [super init]) {
        
        self.showsVerticalScrollIndicator   = NO;
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

/**
 *  将photo放入数组中
 */
- (void)putPhotosToImagesArr {
    
    for (int i = 0; i < self.photoImageViewsArr.count; i++) {
        
        PhotoUnitView *photo = [self.photoImageViewsArr objectAtIndex:i];
        UIImage *image       = photo.photoImageView.image;
        
        [self.photoImageArr addObject:image];
    }
    
}

- (void)addPhotoInScrollViewWithImage:(UIImage *)photoImage andImageCount:(NSInteger)count {
    
    PhotoUnitView *photo    = [[PhotoUnitView alloc] initWithImage:photoImage];
    
    photo.deleteViewBtn.tag = _photoImagesCount;
    
    [photo.deleteViewBtn addTarget:self
                            action:@selector(deletePhotoImageView:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.photoImageViewsArr addObject:photo];
    
    [self setPhotoImageViewLayout:photo byPhotoImagesCount:count];
 
}

/**
 *  将照片显示在UIScrollView上
 *
 *  @param photo            图片
 *  @param photoImagesCount 图片数量
 */
- (void)setPhotoImageViewLayout:(PhotoUnitView *)photo byPhotoImagesCount:(NSInteger)photoImagesCount {
    
    [photo.photoImageView.image fixOrientation];
    [self addSubview:photo];
    
    photo.frame = CGRectMake(photoImagesCount * self.photoWidth,
                             10,
                             self.photoWidth,
                             self.photoWidth);
    
    self.addMorePhotosBtn.frame = CGRectMake(self.photoWidth * (photoImagesCount + 1)+10,
                                             14,
                                             self.photoWidth-9,
                                             self.photoWidth-9);


    if (_photoImagesCount > 3) {
        
        //photosBgSrcollView 滑动
        self.contentSize = CGSizeMake(SCREEN_WIDTH + (photoImagesCount-4) * 100, 100);
    
    }
    
}

/**
 *  删除选中的照片
 *
 *  @param sender 删除按钮
 */
- (void)deletePhotoImageView:(UIButton *)sender {
    
    PhotoUnitView *photo = (PhotoUnitView *)sender.superview;
    
    [photo removeFromSuperview];

    NSUInteger index     = [self.photoImageViewsArr indexOfObject:photo];

    [self.photoImageViewsArr removeObject:photo];
    
    _photoImagesCount--;
    
    [self sortAllPhotos:self.photoImageViewsArr AtIndex:index];
    
}

/**
 *  重新排列图片
 *
 *  @param photosArr 图片数组
 *  @param index     index 后的全部重新排列
 */
- (void)sortAllPhotos:(NSMutableArray *)photosArr AtIndex:(NSUInteger)index {
    
    
    //删除最外面的图片
    if (index == photosArr.count) {
        
        //这里index ＝ 0表示数组中已经没有值了
        if (index > 0) {
            
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.addMorePhotosBtn.frame = CGRectMake(index * self.photoWidth+10,
                                                         14,
                                                         self.photoWidth-9,
                                                         self.photoWidth-9);

            }];
            
            }

        else
        {
            [self.addMorePhotosBtn removeFromSuperview];
            
        }
    }

        
    //删除里面的图片
    for (NSInteger i = index; i < photosArr.count; i++) {
        
        PhotoUnitView *photo = [photosArr objectAtIndex:i];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            photo.frame = CGRectMake(self.photoWidth*i,
                                     10,
                                     self.photoWidth,
                                     self.photoWidth);
            self.addMorePhotosBtn.frame = CGRectMake((i+1) * self.photoWidth+10,
                                                     14,
                                                     self.photoWidth-9,
                                                     self.photoWidth-9);

        }];
    }
    
    
}


/**
 *  添加照片
 *
 *  @param assets     照片数组
 *  @param scrollView 滑动背景
 */
- (void)addImages:(NSArray *)assets{
    
//    _photoImagesCount   = 0;
//    _photoImageViewsArr = nil;
//    _photoImageArr      = nil;
    
//    for (UIView *subview in [self subviews]) {
//        [subview removeFromSuperview];
//    }
    
    [self addSubview:self.addMorePhotosBtn];

    for (id asset in assets) {
        
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            if (phAsset.mediaType == PHAssetMediaTypeImage) {

                PHImageManager *manager = [PHImageManager defaultManager];
                
                [manager requestImageForAsset:phAsset
                                   targetSize:PHImageManagerMaximumSize
                                  contentMode:PHImageContentModeDefault
                                      options:self.requestOptions
                                resultHandler:^void(UIImage *image, NSDictionary *info) {
                    
                    [self addPhotoInScrollViewWithImage:image andImageCount:self.photoImagesCount];
                    
                    self.photoImagesCount ++;
                    
                }];
                
            }
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            
            ALAsset *alAsset = (ALAsset *)asset;
            
            if ([[alAsset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypePhoto"]) {
                
                
                //获取fullResolutionImage的从相册中选取的图片会有旋转问题，即默认orientation被重置为up 使用fullScreenImage则会压缩图片，所以使用默认方向和缩放比例
                UIImage * photoImage = [UIImage imageWithCGImage:[alAsset defaultRepresentation].fullResolutionImage scale:1 orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
                [self addPhotoInScrollViewWithImage:photoImage andImageCount:self.photoImagesCount];
                
                self.photoImagesCount ++;
                
            }
            else if ([[alAsset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypeVideo"]){
                //  NSURL *url = asset.defaultRepresentation.url;
                //  视频不处理
            }
            
        }
        
    }
    
    if (_photoImagesCount > 3) {
        
        //photosBgSrcollView 滑动
        self.contentSize = CGSizeMake(SCREEN_WIDTH + (_photoImagesCount-4) * 100, 100);
        
    }

    
}


/**
 *  继续添加图片
 *
 *  @param assets     图片数组
 *  @param scrollView 滑动背景
 */
- (void)addMoreImages:(NSArray *)assets {
    
    for (id asset in assets) {
        
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            if (phAsset.mediaType == PHAssetMediaTypeImage) {
                
                PHImageManager *manager = [PHImageManager defaultManager];
                
                [manager requestImageForAsset:phAsset
                                   targetSize:PHImageManagerMaximumSize
                                  contentMode:PHImageContentModeDefault
                                      options:self.requestOptions
                                resultHandler:^void(UIImage *image, NSDictionary *info) {
                                    
                                    [self addPhotoInScrollViewWithImage:image andImageCount:_photoImagesCount];
                                    
                                    _photoImagesCount ++;
                                    
                                }];
                
            }
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            
            ALAsset *alAsset = (ALAsset *)asset;
            
            if ([[alAsset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypePhoto"]) {
                
                
                //获取fullResolutionImage的从相册中选取的图片会有旋转问题，即默认orientation被重置为up 使用fullScreenImage则会压缩图片，所以使用默认方向和缩放比例
                UIImage * photoImage = [UIImage imageWithCGImage:[alAsset defaultRepresentation].fullResolutionImage scale:1 orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
                [self addPhotoInScrollViewWithImage:photoImage andImageCount:_photoImagesCount];
                
                _photoImagesCount ++;
                
            }
            else if ([[alAsset valueForProperty:@"ALAssetPropertyType"] isEqual:@"ALAssetTypeVideo"]){
                //  NSURL *url = asset.defaultRepresentation.url;
                //  视频不处理
            }
            
        }
        
    }
    
    if (_photoImagesCount > 3) {
        
        //photosBgSrcollView 滑动
        self.contentSize = CGSizeMake(SCREEN_WIDTH + (_photoImagesCount-4) * 100, 100);
        
    }
    
}

- (NSMutableArray *)photoImageViewsArr {
    if (_photoImageViewsArr == nil) {
        _photoImageViewsArr = [[NSMutableArray alloc] init];
    }
    return _photoImageViewsArr;
}

- (NSMutableArray *)photoImageArr {
    if (_photoImageArr == nil) {
        _photoImageArr = [[NSMutableArray alloc] init];
    }
    return _photoImageArr;
}

- (UIButton *)addMorePhotosBtn {
    if (_addMorePhotosBtn == nil) {
        _addMorePhotosBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addMorePhotosBtn setBackgroundImage:[UIImage imageNamed:@"+_gray"] forState:UIControlStateNormal];

    }
    return _addMorePhotosBtn;
}

-(PHImageRequestOptions *)requestOptions {
    if (_requestOptions == nil) {
        _requestOptions = [[PHImageRequestOptions alloc] init];
        _requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
        _requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        _requestOptions.synchronous = true;
    }
    return _requestOptions;
    
}




@end
