//
//  THMinImageFileTool.h
//  imageSize
//
//  Created by laowang on 15/10/10.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface THMinImageFileTool : NSObject

// 压缩图片数组
+ (NSArray*)minImageFileArray:(NSArray*)imageArray wantSize:(CGFloat)wantSize;
// 压缩单个图片
+ (UIImage*)minImageFile:(UIImage*)image wantSize:(CGFloat)wantSize;


@end
