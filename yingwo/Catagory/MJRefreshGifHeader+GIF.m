//
//  MJRefreshGifHeader+GIF.m
//  yingwo
//
//  Created by apple on 2017/3/9.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "MJRefreshGifHeader+GIF.h"

@implementation MJRefreshGifHeader (GIF)

//- (NSMutableArray *)refreshImages {
//    
//    
//    
//    return objc_getAssociatedObject(self, &AddressKey);
//    
//    if (_refreshImages == nil) {
//        
//        _refreshImages = [NSMutableArray arrayWithCapacity:27];
//        
//        for (int i = 0; i < 27; i ++) {
//            
//            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"buka_60x60_000%d",i]];
//            [_refreshImages addObject:image];
//        }
//        
//    }
//    return _refreshImages;
//}
//
//- (void)setRefreshImages:(NSMutableArray *)refreshImages {
//    
//    objc_setAssociatedObject(self, &AddressKey, refreshImages, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

- (void)setHeaderRefreshWithCustomImages{
    
    NSMutableArray *idleRefreshImages = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *pullRefreshImages = [NSMutableArray arrayWithCapacity:27];
    NSMutableArray *refreshImages = [NSMutableArray arrayWithCapacity:27];

    for (int i = 0; i < 10; i ++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"buka_60x60_000%d",i]];
        [idleRefreshImages addObject:image];
    }
    
    for (int i = 10; i < 20; i ++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"buka_60x60_00%d",i]];
        [pullRefreshImages addObject:image];
    }
    
    for (int i = 10; i < 27; i ++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"buka_60x60_00%d",i]];
        [pullRefreshImages addObject:image];
    }
    
    [self setImages:idleRefreshImages forState:MJRefreshStateIdle];
    [self setImages:pullRefreshImages forState:MJRefreshStatePulling];
    [self setImages:refreshImages forState:MJRefreshStateWillRefresh];

//    // Hide the time
//    self.lastUpdatedTimeLabel.hidden = YES;
//    
//    // Hide the status
//    self.stateLabel.hidden = YES;
}

@end
