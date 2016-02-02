//
//  THPhotoGroup.m
//  THPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import "THPhotoGroup.h"

@implementation THPhotoGroup
- (NSMutableArray *)photoALAssets {
    if (!_photoALAssets) {
        _photoALAssets = [NSMutableArray array];
    }
    return _photoALAssets;
}

@end
