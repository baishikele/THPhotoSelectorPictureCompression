//
//  THPhotoSelectorVcTool.h
//  testPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSingleton.h"
typedef enum{
    
    photoPickerTypeCamera,
    
    photoPickerTypePhoto
    
}photoPickerType;
@interface THPhotoSelectorVcTool : UIViewController

@property(nonatomic, assign)photoPickerType photoType;
HMSingletonH(THPhotoSelectorVcTool)
+ (void)photoSelector:(photoPickerType)photoType maxPhoto:(NSInteger)maxCount photoArray:(void(^)(NSArray*))photoArray;

@end