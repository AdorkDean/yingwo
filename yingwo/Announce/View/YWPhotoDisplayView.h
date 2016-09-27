//
//  YWPhotoDisplayView.h
//  yingwo
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PhotoSelectModel) {
    FirstSelectPhoto,
    AddMorePhoto
};

@interface YWPhotoDisplayView : UIScrollView

@property (nonatomic, strong) UIButton         *addMorePhotosBtn;

@property (nonatomic, strong) NSMutableArray   *photoImageViewsArr;
@property (nonatomic, strong) NSMutableArray   *photoImageArr;

@property (nonatomic, assign) NSInteger        photoImagesCount;
@property (nonatomic, assign) CGFloat          photoWidth;
@property (nonatomic, assign) PhotoSelectModel selectModel;



- (void)addPhotoInScrollViewWithImage:(UIImage *)photoImage andImageCount:(NSInteger)count;

- (void)putPhotosToImagesArr;
- (void)addImages:(NSArray *)assets;
- (void)addMoreImages:(NSArray *)assets;
@end
