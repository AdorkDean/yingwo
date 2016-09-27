//
//  YWHomeCellMiddleViewBase.m
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWHomeCellMiddleViewBase.h"

@implementation YWHomeCellMiddleViewBase

- (instancetype)initWithImagesNumber:(NSInteger)num
{
    self = [super init];
    if (self) {
        
        [self createSubviewByImagesNumber:num];
        
    }
    return  self;
}

- (void)setImageHeightByDivide:(double) divide {
    
    if (divide == 1) {
        
        //图片宽度计算方式
        //SCREEN_WIDTH - 10*2 - 5 *2 这个计算出来的是MiddleView的实际宽度
        //self.margin * 1 这个是减去图片中间的间隙：self.margin
        //当图片一行放两个时候的宽度
        self.YWOneImageHeight = (SCREEN_WIDTH - 10*2 - 5 *2)/divide;
        
    }
    else if (divide == 2.0) {
        
        //图片宽度计算方式
        //SCREEN_WIDTH - 10*2 - 5 *2 这个计算出来的是MiddleView的实际宽度
        //self.margin * 1 这个是减去图片中间的间隙：self.margin
        //当图片一行放两个时候的宽度
        self.YWOneImageHeight = (SCREEN_WIDTH - 10*2 - 5 *2 - self.margin * 1)/divide;
        
    }else if (divide == 3) {
        
        //图片宽度计算方式
        //SCREEN_WIDTH - 10*2 - 5 *2 这个计算出来的是MiddleView的实际宽度
        //self.margin * 1 这个是减去图片中间的间隙：self.margin
        //当图片一行放三个时候的宽度
        self.YWOneImageHeight = (SCREEN_WIDTH - 10*2 - 5 *2 - self.margin * 2)/divide;
    }
}

- (double)margin {
    
    _margin = 2;
    
    return _margin;
}

- (void)createSubviewByImagesNumber:(NSInteger)num {
    
    self.imagesArr = [NSMutableArray arrayWithCapacity:num];
    
    for (int i = 0; i < num; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag          = i+1;

        [self.imagesArr addObject:imageView];
        
        [self addSubview:imageView];
        
        //约束的key，最好检查错误的时候最好设置一下
        imageView.mas_key = [NSString stringWithFormat:@"imageView%d",i];
        
        //给每个图片添加点击事件
        UITapGestureRecognizer *tap      = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectedImageView:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
    [self addImageViewsFrameToView];
}

- (void)addImageViewsFrameToView {
    
}


- (void)addImageViewByImageArr:(NSMutableArray *)imageArr {
    
    //只显示9张
    if (imageArr.count <= 9) {
        
        for (int i = 0; i < imageArr.count; i ++) {
            
            UIImageView *newImageView = [imageArr objectAtIndex:i];
            UIImageView *oldImageView = (UIImageView *)[self viewWithTag:i+1];
            oldImageView.image        = newImageView.image;

        }
    }else {
        for (int i = 0; i < 9; i ++) {
            
            UIImageView *newImageView = [imageArr objectAtIndex:i];
            UIImageView *oldImageView = [self viewWithTag:i+1];
            oldImageView.image        = newImageView.image;
            
        }
    }
    
}

- (void)selectedImageView:(UIGestureRecognizer *)gesture {
    UIImageView *imageView = (UIImageView *)gesture.view;
    
    [self.delegate didSelectedAvatarImageViewOfMiddleView:imageView imageArr:self.imagesArr];
}

@end
