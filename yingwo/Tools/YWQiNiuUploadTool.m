//
//  YWQiNiuUploadHelper.m
//  yingwo
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWQiNiuUploadTool.h"

@implementation YWQiNiuUploadTool

+ (void) getQiNiuUploadToken:(void (^)(NSString *token))token {
    
    NSString *fullUrl     = [BASE_URL stringByAppendingString:QINIU_TOKEN_URL];
    YWHTTPManager *manger = [YWHTTPManager manager];
    
    [manger POST:fullUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                  options:NSJSONReadingMutableLeaves
                                                                    error:nil];
        NSDictionary *tokenDic = resultDic[@"info"];
      //  NSLog(@"tokenDic:%@",tokenDic);

        token(tokenDic[@"uploadu_token"]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"token 获取失败");
    }];
}

/**
 *  上传多张图片
 *
 *  @param imageArr 图片数组
 *  @param progress 进度
 *  @param success  成功
 *  @param failure  失败
 */
+ (void)uploadImages:(NSArray *)imageArr
            progress:(void (^)(CGFloat))progress
             success:(void (^)(NSArray *))success
             failure:(void (^)())failure {
    
    //保存上传成功后返回的key（也是文件后缀）
    NSMutableArray *urlArr          = [[NSMutableArray alloc] init];
    //上传总的进度，__block形式
    __block CGFloat totalProgress   = 0;
    //上传完一个的进度
    __block CGFloat partProgress    = 1.0f / [imageArr count];
    //当前上传完的个数
    __block NSUInteger currentIndex = 0;

    
    //weakself 避免循环引用，是程序崩溃 YWQiNiuUploadHelper 是单例
    YWQiNiuUploadHelper *uploadHelper             = [YWQiNiuUploadHelper shareInstance];
    __weak typeof (YWQiNiuUploadHelper) *weakself = uploadHelper;

    //匿名block实现，这里通过block回调实现循环调用
    weakself.singleSuccessBlock = ^(NSString *url) {
        //保存已经上传完后返回的key
        [urlArr addObject:url];
        //进度增加
        totalProgress += partProgress;
        //回调进度
        progress(totalProgress);
        
        currentIndex ++;
        //当上传的个数和保存的key的个数相同，则跳出block，停止上传文件
        if (urlArr.count == imageArr.count) {
            //成功回调key数组，这个不一定会用
            success([urlArr copy]);
            return ;
        }else if(urlArr.count < imageArr.count){
            //如果保存的key个数小于需要上传的文件个数，则继续上传文件
            [YWQiNiuUploadTool uploadImage:imageArr[currentIndex]
                                  progress:nil success:weakself.singleSuccessBlock
                                   failure:weakself.singleFailureBlock];
        }
    };
    //没有图片不上传任何东西
    if (imageArr.count != 0) {
        //开始上传第一个文件,imageArr[0]
        [YWQiNiuUploadTool uploadImage:imageArr[0]
                              progress:nil
                               success:weakself.singleSuccessBlock
                               failure:weakself.singleFailureBlock];
    }
    else
    {
        progress(1);
        success(nil);
    }

}

/**
 *  上传一张图片
 *
 *  @param image    图片
 *  @param progress 进度
 *  @param success  成功
 *  @param failure  失败
 */
+ (void)uploadImage:(UIImage *)image
           progress:(__autoreleasing QNUpProgressHandler *)progress
            success:(void (^)(NSString *))success
            failure:(void (^)())failure {
    
    //先获取七牛上传文件需要的token
    [YWQiNiuUploadTool getQiNiuUploadToken:^(NSString *token) {
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        
        //获取图片的长和宽
        //上传图片链接时需要拼接上去
        CGFloat imageWidth  = image.size.width;
        CGFloat imageHeight = image.size.height;

        //将图片压缩后以二进制形式上传
        NSData *imageData          = UIImageJPEGRepresentation(image, 0.5);
        
        [upManager putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            //info.statusCode为200表示上传成功
            if (info.statusCode == SUCCESS_STATUS) {
                
                //获取上传成功后的key（文件后缀名）
                //url形式：http://域名/key&w&h,其中w为图片宽度，h为图片高度，单位都是像素px
                NSString *url = [NSString stringWithFormat:@"%@/%@?%f?%f",
                                 QINIU_BASE_URL,
                                 resp[@"key"],
                                 imageWidth,
                                 imageHeight];
                //成功后调用singleSuccessBlock（匿名block实现）
                success(url);
                
                //NSLog(@"imageUrl:%@",url);
            }else {
                NSLog(@"图片上传失败");
                failure();
            }
            
        } option:nil];
        
    }];
}






















@end
