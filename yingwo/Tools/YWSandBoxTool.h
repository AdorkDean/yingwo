//
//  YWSandBoxTool.h
//  AvatarPhoto
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 chenyufengweb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  沙盒工具类，用于沙盒的读取和存储
 */
@interface YWSandBoxTool : NSObject

+ (NSString *)homePath;
+ (NSString *)docPath;
+ (NSString *)libCachePath;
+ (NSString *)tempPath;

//头像沙盒存储
+ (void)saveHeadPortraitIntoCache:(UIImage *)headPortrait;

/**
 *  获取头像
 *
 *  @return 返回头像路径
 */
+ (NSString *)getHeadPortraitPathFromCache;

/**
 *  将图片以二机制文件形式保存下来
 *  建议使用这种方式保存文件，这比下面直接保存为jpeg更好，因为jpeg更占空间
 *  @param imageData NSData
 *  @param name      图片要保存的后缀名
 *
 *  @return 返回是否成功
 */
+ (BOOL)saveImageDataInCache:(NSData *)imageData withName:(NSString *)name;
/**
 *  保存下载下来的图片
 *  不推荐使用，建议用上面的方式
 *  @param image 图片的image
 *  @param name  图片要保存的后缀名
 *
 *  @return 返回是否成功
 */
+ (BOOL)saveImageInCache:(UIImage *)image withName:(NSString *)name;

/**
 *  寻找缓存图片
 *
 *  @param name 根据图片名称
 *
 *  @return 返回二进制
 */
+ (NSData *)loadImageDataByImageName:(NSString *)name;
/**
 *  判断图片是否存在
 *
 *  @param name 根据图片名
 *
 *  @return 返回YES或NO
 */
+ (BOOL)isExistImageByName:(NSString *)name;

/**
 *  从缓存中读取图片
 *
 *  @param urlArr 图片url数组
 *
 *  @return 返回保存UIImage的数组
 */
+ (NSMutableArray *)getImagesFromCacheByUrlsArr:(NSArray *)urlArr;

@end
