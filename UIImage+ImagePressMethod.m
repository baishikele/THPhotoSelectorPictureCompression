//
//  THMinImageFileTool.m
//  imageSize
//
//  Created by laowang on 15/10/10.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import "UIImage+ImagePressMethod.h"

@implementation UIImage (ImagePressMethod)

- (id)reduceWithQualityPercent:(float)qualityPercent scaledPercent:(float)scaledPercent {
    
    @autoreleasepool {
        if (qualityPercent == 100.00 && scaledPercent == 1.00) {
            //无须压缩
            return self;
        }else{
            
            CGSize size = CGSizeMake(self.size.width * scaledPercent, self.size.height * scaledPercent);
            
            if (qualityPercent == 100) {
                //如果压缩质量为100,则图片质量无损压缩
                //比例压缩
                
                return [self imageWithImageSimpleScaledToSize:size];
                
            }else if (scaledPercent == 1.0) {
                //压缩比例为1，不进行压缩
                
                return [self reduceWithpercent:qualityPercent/100.00];
                
            }else {
                
                return [UIImage imageWithData:[self reduceWithpercent:qualityPercent/100.00 scaledToSize:size]] ;
                
            }
            
        }
    }
    
    return self;
}

- (NSData *)reduceWithpercent:(float)percent scaledToSize:(CGSize)newSize {
    
    @autoreleasepool {
        
        // Create a graphics image context
        UIGraphicsBeginImageContext(newSize);
        
        // new size
        [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        
    }
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, percent);
    
    
    return imageData;

}

- (NSData *)reduceWithpercent:(float)percent {
    
    NSData *imageData = UIImageJPEGRepresentation(self, percent);
    return imageData;
}

- (UIImage *)imageWithImageSimpleScaledToSize:(CGSize)newSize {
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    @autoreleasepool {
        // new size
        [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    }
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

@end
