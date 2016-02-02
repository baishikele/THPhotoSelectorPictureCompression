//
//  THPhotoLibrayController.h
//  THPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THPhotoSelectorHeader.h"

@interface THPhotoLibrayController : UINavigationController
/**最多能选择的照片数量*/
@property(nonatomic, assign) NSInteger maxCount;
/**是否可以跨相册选择*/
@property (nonatomic, assign) BOOL multiAlbumSelect;

+ (instancetype)photoLibrayControllerWithBlock:(photoSelectorBlock) block;

@end
