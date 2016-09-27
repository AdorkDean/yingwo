//
//  YWAvatarBrowser.m
//  AvaterView
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWAvatarBrowser.h"
@implementation YWAvatarBrowser

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
                       failure:(void (^)(NSString *))failure {
    
    NSMutableArray *imageArr        = [[NSMutableArray alloc] init];
    __block CGFloat totalProgress   = 0;
    __block CGFloat partProgress    = 1.0f / [imageUrls count];
    __block NSUInteger currentIndex = 0;

    YWAvatarBrowserHelper *downloadHelper           = [YWAvatarBrowserHelper shareInstance];
    __weak typeof (YWAvatarBrowserHelper) *weakself = downloadHelper;
    
    weakself.singleSuccessBlock = ^(UIImage *image){
        [imageArr addObject:image];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex ++;
        if (imageUrls.count == imageArr.count) {
            success([imageArr copy]);
            return ;
        }else if(currentIndex <= imageUrls.count){
            [YWAvatarBrowser downloadImageWithUrl:imageUrls[currentIndex] progress:nil success:weakself.singleSuccessBlock failure:weakself.singleFailureBlock];
        }
        
    };
    
    //回调上面实现的匿名block
    [YWAvatarBrowser downloadImageWithUrl:imageUrls[0] progress:nil success:weakself.singleSuccessBlock failure:weakself.singleFailureBlock];

}
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
                     failure:(void (^)(NSString *))failure {
    
    //参数是像素值,这里我设置为全屏的一半
   NSString *imageMode = [NSString stringWithFormat:QINIU_PROPORTION_IMAGE_MODEL,(int)SCREEN_HEIGHT,(int)SCREEN_WIDTH];

   NSString *fullUrl   = [url stringByAppendingString:imageMode];
   fullUrl             = [fullUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

   YWHTTPManager *manager = [YWHTTPManager manager];
    NSLog(@"%@",fullUrl);
    [manager GET:fullUrl
       parameters:nil
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  UIImage *downloadImage = [UIImage imageWithData:responseObject];
                  NSString *imageName    = [url lastPathComponent];
                  
                  [YWSandBoxTool saveImageDataInCache:responseObject
                                             withName:imageName];
                  success(downloadImage);
              }

              
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片下载失败！error:%@",error);
        failure(@"failure");
    }];
    
}


@end
