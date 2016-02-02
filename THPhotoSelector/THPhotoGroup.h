//
//  THPhotoGroup.h
//  THPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THPhotoGroup : NSObject
@property(nonatomic, copy) NSString *groupName;
@property(nonatomic, strong) UIImage *groupIcon;
@property(nonatomic, strong) NSMutableArray *photoALAssets;

@end
