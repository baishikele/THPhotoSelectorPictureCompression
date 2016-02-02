//
//  THPhotoGroupTableViewController.h
//  THPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THPhotoSelectorHeader.h"

@interface THPhotoGroupTableViewController : UITableViewController
@property(nonatomic, assign) NSInteger maxCount;
@property(nonatomic, strong) NSArray *photoGroupArray;
@property (nonatomic, copy) photoSelectorBlock block;
@property (nonatomic, assign, getter=canMultiAlbumSelect) BOOL multiAlbumSelect;

- (void)showErrorMessageView;

@end
