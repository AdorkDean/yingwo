//
//  YWHomeCellMiddleViewBase.h
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  YWHomeCellMiddleViewBaseProtocol;
@interface YWHomeCellMiddleViewBase : UIView

@property (nonatomic, strong) NSMutableArray                   *imagesArr;
@property (nonatomic, assign) id<YWHomeCellMiddleViewBaseProtocol> delegate;
@property (nonatomic, assign) double                           YWOneImageHeight;
@property (nonatomic, assign) double                           margin;

- (instancetype)initWithImagesNumber:(NSInteger)num;
/**
 *  添加图片
 *
 *  @param num 图片数量
 */
- (void)createSubviewByImagesNumber:(NSInteger)num;

/**
 *  添加图片约束（子View需重写）
 */
- (void)addImageViewsFrameToView;

/**
 *  图片加载
 *
 *  @param imageArr 图片数组
 */
- (void)addImageViewByImageArr:(NSMutableArray *)imageArr;

/**
 *  获取图片高度
 *
 *  @param divide 一排几个图片
 */
- (void)setImageHeightByDivide:(double) divide;

@end

@protocol YWHomeCellMiddleViewBaseProtocol <NSObject>

@required
/**
 *  点击cell中的图片
 *
 *  @param imageView
 */
- (void)didSelectedAvatarImageViewOfMiddleView:(UIImageView *)imageView imageArr:(NSMutableArray *)imageArr;

@end
