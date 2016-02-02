//
//  THPhotoLibrayController.m
//  THPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import "THPhotoLibrayController.h"
#import "THPhotoGroup.h"
#import "THPhotoALAssets.h"
#import "THPhotoGroupTableViewController.h"

@interface THPhotoLibrayController ()

@property (nonatomic, copy) photoSelectorBlock block;
@property(nonatomic, strong) THPhotoGroupTableViewController *photoGroupTableViewController;
@property(nonatomic, strong) ALAssetsLibrary *library;
@property(nonatomic, strong) NSMutableArray *photoGroupArray;

@end

@implementation THPhotoLibrayController

+ (instancetype)photoLibrayControllerWithBlock:(photoSelectorBlock) block {
    return [[self alloc]initWithBlock:block];
}

- (instancetype)initWithBlock:(photoSelectorBlock) block {
    _block = block;
    return [super initWithRootViewController:self.photoGroupTableViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupImagePickerController];
}

- (void)setupImagePickerController {
    __weak typeof (self) selfVc = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *error) {
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [selfVc.photoGroupTableViewController showErrorMessageView];
                });
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
            if (result != NULL) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    THPhotoGroup *photoGroup = [selfVc.photoGroupArray lastObject];
                    THPhotoALAssets *photoALAssets = [[THPhotoALAssets alloc]init];
                    photoALAssets.photoALAsset = result;
                    photoALAssets.selected = NO;
                    [photoGroup.photoALAssets addObject:photoALAssets];
                }
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup *aLAssets, BOOL* stop){
            if (aLAssets != nil) {
                NSString *groupName = [aLAssets valueForProperty:ALAssetsGroupPropertyName];
                UIImage *posterImage = [UIImage imageWithCGImage:[aLAssets posterImage]];
                
                THPhotoGroup *photoGroup = [[THPhotoGroup alloc]init];
                photoGroup.groupName = groupName;
                photoGroup.groupIcon = posterImage;
                [selfVc.photoGroupArray addObject:photoGroup];
                
                [aLAssets enumerateAssetsUsingBlock:groupEnumerAtion];
                dispatch_async(dispatch_get_main_queue(), ^{
                    selfVc.photoGroupTableViewController.photoGroupArray = selfVc.photoGroupArray;
                });
            }
        };
        
        [selfVc.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:libraryGroupsEnumeration failureBlock:failureblock];
    });
}

#pragma mark - getter && setter
- (THPhotoGroupTableViewController *)photoGroupTableViewController {
    if (!_photoGroupTableViewController) {
        _photoGroupTableViewController = [[THPhotoGroupTableViewController alloc]init];
    }
    return _photoGroupTableViewController;
}

- (ALAssetsLibrary *)library {
    if (!_library) {
        _library = [[ALAssetsLibrary alloc] init];
    }
    return _library;
}

- (NSMutableArray *)photoGroupArray {
    if (!_photoGroupArray) {
        _photoGroupArray = [NSMutableArray array];
    }
    return _photoGroupArray;
}

- (void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
    self.photoGroupTableViewController.maxCount = maxCount;
    self.photoGroupTableViewController.block = self.block;
}

- (void)setMultiAlbumSelect:(BOOL)multiAlbumSelect {
    _multiAlbumSelect = multiAlbumSelect;
    self.photoGroupTableViewController.multiAlbumSelect = multiAlbumSelect;
}

@end
