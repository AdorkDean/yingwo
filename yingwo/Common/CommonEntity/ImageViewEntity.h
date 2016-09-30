//
//  ImageViewEntity.h
//  yingwo
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageViewEntity : NSObject

//图片的宽度，像素
@property (nonatomic, assign) CGFloat  width;

//图片的长度，像素
@property (nonatomic, assign) CGFloat  height;

//imageName形式：http://obabu2buy.bkt.clouddn.com/xxxxxxxxxxxxxx
@property (nonatomic, copy  ) NSString *imageName;

//是否点击大图下载过
@property (nonatomic, assign) BOOL     isDownload;

/**
 *  获得所有图片的名称
 *
 *  @param entities 包含图片实体的数组
 *
 *  @return 返回包含图片名称的数组
 */
+ (NSMutableArray *)getImageUrlsFromImageEntities:(NSArray *)entities;

@end
