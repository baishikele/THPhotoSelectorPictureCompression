//
//  THPhotoSelectorVcTool.m
//  testPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import "THPhotoSelectorVcTool.h"
#import "THPhotoLibrayController.h"
#import "THMinImageFileTool.h"
@interface THPhotoSelectorVcTool ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, copy)void(^myBlock)(NSArray*);
@end

@implementation THPhotoSelectorVcTool
HMSingletonM(THPhotoSelectorVcTool)

- (void)viewDidLoad {
    [super viewDidLoad];

}


+ (void)photoSelector:(photoPickerType)photoType maxPhoto:(NSInteger)maxCount photoArray:(void(^)(NSArray*))photoArray{
    THPhotoSelectorVcTool* vc = [[self alloc] init];
    vc.myBlock = photoArray;
    switch (photoType) {
        case photoPickerTypeCamera:
        {
            [self setupCamera:vc];
        }
            break;
        case photoPickerTypePhoto:
        {
            [self setupPhotoPalm:vc maxCount:maxCount];
        }
            break;
        default:
            break;
    }
}

+ (void)setupPhotoPalm:(THPhotoSelectorVcTool*)vc maxCount:(NSInteger)maxCount{
    THPhotoLibrayController *photoSelector = [THPhotoLibrayController photoLibrayControllerWithBlock:^(NSArray *images) {

        images = [THMinImageFileTool minImageFileArray:images wantSize:300];

        THPhotoSelectorVcTool* vc = [[self alloc] init];
        vc.myBlock(images);
    }];

    photoSelector.maxCount = maxCount;

    photoSelector.multiAlbumSelect = YES;
    
    [vc presentViewController:photoSelector animated:YES completion:nil];

}


+ (void)setupCamera:(THPhotoSelectorVcTool*)vc{
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    picker.delegate = vc;
    picker.allowsEditing = YES;//设置可编辑
    picker.sourceType = sourceType;
    [vc presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    image = [THMinImageFileTool minImageFile:image wantSize:300];

    self.myBlock(@[image]);

    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end

