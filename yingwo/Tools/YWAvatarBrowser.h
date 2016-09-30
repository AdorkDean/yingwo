//
//  YWAvatarBrowser.h
//  AvaterView
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YWAvatarBrowserHelper.h"

/**
 *  七牛图片下载工具类，支持单图、多图下载
 */
@interface YWAvatarBrowser : NSObject

/**
 *  下载多张图片
 *
 *  @param imageUrls 图片url数组
 *  @param progress  进度
 *  @param success   成功后返回包含UIImage的NSArray
 *  @param failure   失败
 */
+ (void)downloadImagesWithUrls:(NSArray *)imageUrls
                      progress:(void (^)(CGFloat))progress
                       success:(void (^)(NSMutableArray *))success
                       failure:(void (^)(NSString *))failure;

/**
 *  下载单张图片
 *
 *  @param url      资源定位符
 *  @param progress 进度
 *  @param success  成功后返回 UImage
 *  @param failure  失败
 */
+ (void)downloadImageWithUrl:(NSString *)url
                    progress:(void (^)(CGFloat))progress
                     success:(void (^)(UIImage *))success
                     failure:(void (^)(NSString *))failure;
@end
