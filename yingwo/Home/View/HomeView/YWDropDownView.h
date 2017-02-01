//
//  YWDropDownView.h
//  yingwo
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWDropDownViewDelegate;
@interface YWDropDownView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray         *titleArr;
@property (nonatomic, assign) BOOL                   isPopDropDownView;
@property (nonatomic, assign) NSInteger              selectedIndex;
@property (nonatomic, assign) id<YWDropDownViewDelegate> delegate;

/**
 *  创建下拉列表
 *
 *  @param titles 列表中的标题，其中，第一个标题不能点击
 *  @param height 列表高度
 *  @param width  列表宽度
 *
 *  @return self
 */
- (instancetype)initWithTitlesArr:(NSMutableArray *) titles
                           height:(CGFloat) height
                            width:(CGFloat)width;

/**
 *  动画展现列表
 *
 */
- (void)showDropDownView;

/**
 *  关闭列表
 */
- (void)hideDropDownView;

@end

@protocol YWDropDownViewDelegate <NSObject>

- (void)seletedDropDownViewAtIndex:(NSInteger)index;

@end