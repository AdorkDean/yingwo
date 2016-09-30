//
//  YWSandBoxTool.m
//  AvatarPhoto
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 chenyufengweb. All rights reserved.
//

#import "YWSandBoxTool.h"

static YWSandBoxTool *instance = nil;

@implementation YWSandBoxTool

//多线程单例

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL]init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [YWSandBoxTool shareInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone {
    return [YWSandBoxTool shareInstance];
}

//沙盒各路径

+ (NSString *)homePath {
    
    NSLog(@"home:%@",NSHomeDirectory());
    return NSHomeDirectory();
}

+ (NSString *)docPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)libCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)tempPath {
    return [NSHomeDirectory() stringByAppendingString:@"/tmp"];
}

+ (void)saveHeadPortraitIntoCache:(UIImage *)headPortrait {
    
    //先创建文件夹
    NSFileManager *fileManager          = [NSFileManager defaultManager];
    NSString *headPortraitDirectoryPath = [[YWSandBoxTool libCachePath] stringByAppendingString:@"/head"];
    Boolean isExist = [fileManager fileExistsAtPath:headPortraitDirectoryPath];
    
    if (!isExist) {
        
        [fileManager createDirectoryAtPath:headPortraitDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];

    }

    //再存储头像
    NSString *imagePath                 = [[YWSandBoxTool libCachePath] stringByAppendingString:@"/head/head_portrait.png"];
    Boolean isSave                      = [UIImagePNGRepresentation(headPortrait) writeToFile:imagePath atomically:YES];
    
    if (isSave) {
        
        NSLog(@"头像保存成功");
        
    }else{
        
        NSLog(@"头像保存失败");
        
    }
}

+ (NSString *)getHeadPortraitPathFromCache {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *headPortraitPath = [[YWSandBoxTool libCachePath] stringByAppendingString:@"/head/head_portrait.png"];
    Boolean isExist            = [fileManager fileExistsAtPath:headPortraitPath];
 
    if (isExist) {
        
        return headPortraitPath;
        
    }else {
        
        NSLog(@"头像不存在");
        
    }
    
    return nil;
}

+ (BOOL)saveImageInCache:(UIImage *)image withName:(NSString *)name{
    
    NSFileManager *fileManager   = [NSFileManager defaultManager];
    NSString *photoDirectoryPath = [[YWSandBoxTool libCachePath ]stringByAppendingString:@"/photo/"];
    Boolean isExist              = [fileManager fileExistsAtPath:photoDirectoryPath];
  
    if (!isExist) {
        [fileManager createDirectoryAtPath:photoDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    name                = [name stringByAppendingString:@".jpg"];
    NSString *imagePath = [photoDirectoryPath stringByAppendingString:name];
    Boolean isSave      = [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];

    if (isSave) {
        return YES;
    }else
    {
        return NO;
    }
}

+ (BOOL)saveImageDataInCache:(NSData *)imageData withName:(NSString *)name{
    
    NSFileManager *fileManager   = [NSFileManager defaultManager];
    NSString *photoDirectoryPath = [[YWSandBoxTool libCachePath ]stringByAppendingString:@"/photo/"];
    Boolean isExist              = [fileManager fileExistsAtPath:photoDirectoryPath];
    
    if (!isExist) {
        [fileManager createDirectoryAtPath:photoDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *imagePath = [photoDirectoryPath stringByAppendingString:name];
    Boolean isSave      = [imageData writeToFile:imagePath atomically:YES];

    if (isSave) {
        return YES;
    }else
    {
        return NO;
    }
}

+ (NSData *)loadImageDataByImageName:(NSString *)name {
    
    NSFileManager *fileManager   = [NSFileManager defaultManager];
    NSString *photoDirectoryPath = [[YWSandBoxTool libCachePath ]stringByAppendingString:@"/photo/"];
    NSString *photoImagePath     = [photoDirectoryPath stringByAppendingString:name];
    Boolean isExist              = [fileManager fileExistsAtPath:photoImagePath];

    if (isExist) {
        NSData *imageData = [NSData dataWithContentsOfFile:photoImagePath];
        return imageData;
    }
    return nil;
}

+ (BOOL)isExistImageByName:(NSString *)name {
    
    NSFileManager *fileManager   = [NSFileManager defaultManager];
    NSString *photoDirectoryPath = [[YWSandBoxTool libCachePath ]stringByAppendingString:@"/photo/"];
    NSString *photoImagePath     = [photoDirectoryPath stringByAppendingString:name];
    Boolean isExist              = [fileManager fileExistsAtPath:photoImagePath];
    
    return isExist;
}

+ (NSMutableArray *)getImagesFromCacheByUrlsArr:(NSArray *)urlArr {
    
    NSMutableArray *cacheimageArr = [NSMutableArray arrayWithCapacity:urlArr.count];
    
    for (NSString *url in urlArr) {
        
        NSString *name    = [url lastPathComponent];
        NSData *imageData = [YWSandBoxTool loadImageDataByImageName:name];
        UIImage *image    = [UIImage imageWithData:imageData];
        
        [cacheimageArr addObject:image];
    }
    
    return cacheimageArr;
}


@end
