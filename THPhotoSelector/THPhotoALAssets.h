//
//  THPhotoALAssets.h
//  THPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface THPhotoALAssets : NSObject
@property(nonatomic ,strong) ALAsset *photoALAsset;
@property(nonatomic, assign, getter=isSelected) BOOL selected;

@end
