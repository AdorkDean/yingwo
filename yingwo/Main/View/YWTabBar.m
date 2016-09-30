//
//  YWTabBar.m
//  XXTabBar
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTabBar.h"
#import "YWButton.h"

#define TABVIEW_MARGIN 20

@implementation YWTabBar

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [UIImage imageNamed:@"nanvbars"];
        self.userInteractionEnabled = YES;
        self.buttons         = [NSMutableArray arrayWithCapacity:[imageArray count]-1];
        
        YWButton *homeBtn = [[YWButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"home"] selectImage:[UIImage imageNamed:@"home_G"]];
        YWButton *findBtn = [[YWButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"find"] selectImage:[UIImage imageNamed:@"find_G"]];
        YWButton *addBtn = [[YWButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"add"] selectImage:[UIImage imageNamed:@"add"]];
        YWButton *bubBtn = [[YWButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"bub"] selectImage:[UIImage imageNamed:@"bub_G"]];
        YWButton *headBtn = [[YWButton alloc] initWithBackgroundImage:[UIImage imageNamed:@"head"] selectImage:[UIImage imageNamed:@"head_G"]];

        homeBtn.tag = 0;
        findBtn.tag = 1;
        addBtn.tag  = 2;
        bubBtn.tag  = 3;
        headBtn.tag = 4;
        
        [homeBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [findBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bubBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [headBtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        [self.buttons addObject:homeBtn];
        [self.buttons addObject:findBtn];
        [self.buttons addObject:addBtn];
        [self.buttons addObject:bubBtn];
        [self.buttons addObject:headBtn];

        [self addSubview:homeBtn];
        [self addSubview:findBtn];
        [self addSubview:addBtn];
        [self addSubview:bubBtn];
        [self addSubview:headBtn];

        [homeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(TABVIEW_MARGIN);
            make.centerY.equalTo(self);
        }];
        
        [findBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(homeBtn.mas_right).offset(TABVIEW_MARGIN);
            make.centerY.equalTo(self);
        }];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        [bubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headBtn.mas_left).offset(-TABVIEW_MARGIN);
            make.centerY.equalTo(self);
        }];
        [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-TABVIEW_MARGIN);
            make.centerY.equalTo(self);
        }];
        
        
    }
    return self;
    
}



- (void)setBackgroundImage:(UIImage *)img
{
    [_backgroundView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
    UIButton *btn = sender;
   // NSLog(@"tag:%ld",(long)btn.tag);
    [self selectTabAtIndex:btn.tag];
}

- (void)selectTabAtIndex:(NSInteger)index {
    
    YWButton *btn;
    for (int i = 0; i < self.buttons.count; i ++ ) {
        btn = [self.buttons objectAtIndex:i];
        [btn setBackgroundImage:btn.backgroundImage forState:UIControlStateNormal];
    }


    btn = [self.buttons objectAtIndex:index];
    [btn setBackgroundImage:btn.selectedImage forState:UIControlStateNormal];
    
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)]) {
        [_delegate tabBar:self didSelectIndex:index];
    }
    NSLog(@"Select index: %ld",(long)btn.tag);

}

- (void)showSelectedTabBarAtIndex:(NSInteger)index {
    
    YWButton *btn;
    for (int i = 0; i < self.buttons.count; i ++ ) {
        btn = [self.buttons objectAtIndex:i];
        [btn setBackgroundImage:btn.backgroundImage forState:UIControlStateNormal];
    }
    
    
    btn = [self.buttons objectAtIndex:index];
    [btn setBackgroundImage:btn.selectedImage forState:UIControlStateNormal];

    NSLog(@"show Selected index: %ld",(long)btn.tag);

}

- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index {
    
    CGFloat width = self.frame.size.width / ([self.buttons count] + 1);
    for (UIButton *btn in self.buttons) {
        if (btn.tag >= index) {
            btn.tag++;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
}

- (void)removeTabAtIndex:(NSInteger)index {
    
}

@end
















