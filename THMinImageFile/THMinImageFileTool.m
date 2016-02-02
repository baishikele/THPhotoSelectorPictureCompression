//
//  THMinImageFileTool.m
//  imageSize
//
//  Created by laowang on 15/10/10.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import "THMinImageFileTool.h"
#import "UIImage+ImagePressMethod.h"

@implementation THMinImageFileTool

+ (NSArray*)minImageFileArray:(NSArray*)imageArray wantSize:(CGFloat)wantSize{

    // 1.获取image
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"沙盒地址: %@", documentsDirectory);

    
    NSMutableArray* resultArray = [NSMutableArray array];
    // 2.压缩图片
    for (int i = 0; i<imageArray.count; i++) {
        UIImage* image = [self miniImage:imageArray[i] documentsDirectory:documentsDirectory index:i wantSize:wantSize];
        [resultArray addObject:image];
    }

    return resultArray;
}

+ (UIImage*)minImageFile:(UIImage*)image wantSize:(CGFloat)wantSize{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"沙盒地址: %@", documentsDirectory);
    
    image = [self miniImage:image documentsDirectory:documentsDirectory index:0 wantSize:wantSize];
   
    return image;
}



// 压缩图片
+ (UIImage*)miniImage:(UIImage*)image documentsDirectory:(NSString*)documentsDirectory index:(NSInteger)index wantSize:(int)wantSize{
    
    // 1.比例压缩
    CGFloat scaleWidth = [UIScreen mainScreen].bounds.size.width*2;
    CGFloat scaleHeight = [UIScreen mainScreen].bounds.size.height*2;
    
    CGFloat percent = 1;
    if (scaleWidth < image.size.width) {
        percent = scaleWidth/image.size.width;
    }else if(scaleHeight < image.size.height){
        percent = scaleHeight/image.size.height;
    }
    
    image = [image reduceWithQualityPercent:100 scaledPercent:percent];
    
    
    // 2.存入沙盒，NSFileManger来查看图片准确大小
    NSData* saveData = UIImageJPEGRepresentation(image, 1);
    NSString* saveName =[NSString stringWithFormat:@"%@%@", [self currentTime:index], [self typeForImageData:saveData]] ;
    NSString *imageDocPath = [documentsDirectory stringByAppendingPathComponent:saveName];
    [saveData writeToFile:imageDocPath atomically:YES];
   NSString* path = [documentsDirectory stringByAppendingPathComponent:saveName];
    CGFloat NewFileSize = [self fileSizeAtPath:path]/1024;
    NSLog(@"比例压缩后图片大小：%luKB------manager", (unsigned long)NewFileSize);
    
    
    // 3.如果压缩后的大小不符合要求，降品压缩，（设置的目标压缩文件为wantSize）
    if (NewFileSize > 500) {
        saveData = UIImageJPEGRepresentation(image,  wantSize/500.0);
    }else if(NewFileSize > 400){
        saveData = UIImageJPEGRepresentation(image,  wantSize/400.0);
    }else if(NewFileSize > 300){
        saveData = UIImageJPEGRepresentation(image,  wantSize/300.0);
    }else if(NewFileSize > 200){
        saveData = UIImageJPEGRepresentation(image,  wantSize/200.0);
    }else if(NewFileSize > 100){
        saveData = UIImageJPEGRepresentation(image,  wantSize/100.0);
    }
    image = [UIImage imageWithData:saveData];
    [saveData writeToFile:imageDocPath atomically:YES];
    NSLog(@"品质压缩后图片大小：%luKB------manager", (unsigned long)[self fileSizeAtPath:path]/1024);
    return image;
    
}



//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



// 根据二进制得到图片类型
+ (NSString *)typeForImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @".jpeg";
            
        case 0x89:
            
            return @".png";
            
        case 0x47:
            
            return @".gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @".tiff";
            
    }
    
    return nil;
    
}


// 当前时间命名
+ (NSString*)currentTime:(NSInteger)index{
    
    return [NSString stringWithFormat:@"%ld", (long)index];
    
}


@end
