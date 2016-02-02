//
//  ViewController.m
//  THPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#import "ViewController.h"
#import "THPhotoSelectorVcTool.h"
@interface ViewController ()<UIActionSheetDelegate>
@property(nonatomic, strong)NSMutableArray* currentPhotoArray;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    THPhotoSelectorVcTool* vc = [[THPhotoSelectorVcTool alloc] init];
    
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIActionSheet* actSheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄", @"相册", nil];
    
    [actSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"拍摄");
        [self selectPhoto:photoPickerTypeCamera];
    }else if(buttonIndex == 1){
        NSLog(@"相册");
        [self selectPhoto:photoPickerTypePhoto];
        
    }else{
        [actionSheet cancelButtonIndex];
    }
}


- (void)selectPhoto:(photoPickerType)photoType{
    switch (photoType) {
        case photoPickerTypeCamera:
        {
            
            [THPhotoSelectorVcTool photoSelector:photoPickerTypeCamera maxPhoto:9-self.currentPhotoArray.count photoArray:^(NSArray *images) {
                [self.currentPhotoArray addObjectsFromArray:images];
                [self setupPhotos:self.currentPhotoArray];
            }];
        }
            break;
        case photoPickerTypePhoto:{
            [THPhotoSelectorVcTool photoSelector:photoPickerTypePhoto maxPhoto:9-self.currentPhotoArray.count photoArray:^(NSArray *images) {
                [self.currentPhotoArray addObjectsFromArray:images];
                [self setupPhotos:self.currentPhotoArray];
                
            }];
        }
        default:
            break;
    }
}
- (void)setupPhotos:(NSArray*)images{
    
    for (UIView* sub in self.view.subviews) {
        [sub removeFromSuperview];
    }
    
    NSInteger max = 3;
    CGFloat photoW = kScreenW/max;
    CGFloat photoH = photoW;
    
    for (int i = 0 ; i<images.count; i++) {
        UIImageView* imageView = [[UIImageView alloc] init];
        // 所属行
        CGFloat row = i/max;
        NSLog(@"%f", row);
        // 所属列
        CGFloat col = i%max;
        
        imageView.frame = CGRectMake(col*photoH, row*photoW+100, photoW, photoH);
        imageView.image = images[i];
        [self.view addSubview:imageView];
    }
    
}

-(NSMutableArray *)currentPhotoArray{
    if (_currentPhotoArray == nil) {
        _currentPhotoArray = [NSMutableArray array];
    }
    return _currentPhotoArray;
}

@end
