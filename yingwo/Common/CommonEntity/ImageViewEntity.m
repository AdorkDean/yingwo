//
//  ImageViewEntity.m
//  yingwo
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "ImageViewEntity.h"

@implementation ImageViewEntity

+ (NSMutableArray *)getImageUrlsFromImageEntities:(NSArray *)entities {
    
    NSMutableArray *imageUrls = [[NSMutableArray alloc ]init];
    
    for (ImageViewEntity *entity in entities) {
        [imageUrls addObject:entity.imageName];
    }
    
    return imageUrls;
}

@end
