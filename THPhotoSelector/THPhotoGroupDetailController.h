//
//  THPhotoGroupDetailController.h
//  THPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THPhotoSelectorHeader.h"

@interface THPhotoGroupDetailController : UICollectionViewController
@property(nonatomic, assign) NSInteger maxCount;
@property(nonatomic, strong) NSArray *photoALAssets;
/**回调*/
@property (nonatomic, copy) photoSelectorBlock block;

@end
