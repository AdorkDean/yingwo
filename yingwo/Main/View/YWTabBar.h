//
//  YWTabBar.h
//  XXTabBar
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YWTabBarDelegate;

@interface YWTabBar : UIImageView

@property (nonatomic, strong) UIImageView      *backgroundView;
@property (nonatomic, strong) NSMutableArray   *buttons;
@property (nonatomic, assign) id<YWTabBarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray;
- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index;
- (void)setBackgroundImage:(UIImage *)img;
/**
 *  根据TabBar的index显示每个item的图标
 *  初始化时使用
 *  @param index
 */
- (void)selectTabAtIndex:(NSInteger)index;
/**
 *  dissmiss 后显示TabBar的位置
 *
 *  @param index 当前页面的index
 */
- (void)showSelectedTabBarAtIndex:(NSInteger)index;

/**
 *  显示unselected item
 *
 *  @param index
 */
- (void)removeTabAtIndex:(NSInteger)index;


@end

@protocol YWTabBarDelegate <NSObject>

@optional
- (void)tabBar:(YWTabBar *)tabBar didSelectIndex:(NSInteger)index;
@end
