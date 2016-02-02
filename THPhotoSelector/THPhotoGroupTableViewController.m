//
//  THPhotoGroupTableViewController.m
//  THPhotoSelector
//
//  Created by laowang on 15/10/14.
//  Copyright © 2015年 隔壁老王. All rights reserved.
//

//
//  THPhotoGroupTableViewController.m
//  THPhotoSelector
//
//  Created by GaoWanli on 15/7/23.
//  Copyright (c) 2015年 TH. All rights reserved.
//

#import "THPhotoGroupTableViewController.h"
#import "THPhotoALAssets.h"
#import "THPhotoGroup.h"
#import "THPhotoGroupDetailController.h"

@interface THPhotoGroupCell : UITableViewCell

@property(nonatomic, strong) THPhotoGroup *photoGroup;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic, weak) UIImageView *iconView;
@property(nonatomic, weak) UILabel *infoLabel;

@end

@implementation THPhotoGroupCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"photoGroupCell";
    THPhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
        cell = [[THPhotoGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
        [self makeCellSubviews];
    return self;
}

- (void)makeCellSubviews {
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.backgroundColor = [UIColor clearColor];
    self.iconView = iconView;
    [self addSubview:iconView];
    
    UILabel *infoLabel = [[UILabel alloc]init];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLabel = infoLabel;
    [self addSubview:infoLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 10;
    CGFloat controlWH = 44;
    CGFloat marginLR = 15;
    CGFloat marginTB = (CGRectGetHeight(self.frame) - controlWH) * 0.5;
    
    _iconView.frame = CGRectMake(marginLR, marginTB, controlWH, controlWH);
    
    _infoLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame) + padding, marginTB, CGRectGetWidth(self.frame) - CGRectGetMaxX(_iconView.frame) - marginLR, controlWH);
}

- (void)setPhotoGroup:(THPhotoGroup *)photoGroup {
    _photoGroup = photoGroup;
    [self.iconView setImage:photoGroup.groupIcon];
    self.infoLabel.text = [NSString stringWithFormat:@"%@(%zd)",photoGroup.groupName,photoGroup.photoALAssets.count];
}

@end

@interface THPhotoGroupTableViewController ()

@property(nonatomic, weak) UIView *errorMessageView;
@property(nonatomic, strong) THPhotoGroupDetailController *photoGroupDetailController;

@end

@implementation THPhotoGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相簿";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnDidClick)];
}

- (void)cancelBtnDidClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showErrorMessageView {
    self.errorMessageView.hidden = NO;
}

/**设置数据*/
- (void)setPhotoGroupArray:(NSArray *)photoGroupArray{
    _photoGroupArray = photoGroupArray;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.photoGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THPhotoGroupCell *cell = [THPhotoGroupCell cellWithTableView:tableView];
    THPhotoGroup *photoGroup = self.photoGroupArray[indexPath.section];
    if (photoGroup.photoALAssets.count == 0)
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.photoGroup = photoGroup;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    THPhotoGroup *photoGroup = self.photoGroupArray[indexPath.section];
    if (photoGroup.photoALAssets.count == 0)
        return;
    THPhotoGroupDetailController *photoGroupDetailController;
    if (!self.canMultiAlbumSelect) {
        for (THPhotoGroup *photoGroup in self.photoGroupArray) {
            for (THPhotoALAssets *photoALAssets in photoGroup.photoALAssets) {
                photoALAssets.selected = NO;
            }
        }
        photoGroupDetailController = [[THPhotoGroupDetailController alloc]init];
        photoGroupDetailController.maxCount = self.maxCount;
        photoGroupDetailController.block = self.block;
    }else {
        if (!_photoGroupDetailController) {
            _photoGroupDetailController = [[THPhotoGroupDetailController alloc]init];
            _photoGroupDetailController.maxCount = self.maxCount;
            _photoGroupDetailController.block = self.block;
        }
        photoGroupDetailController = _photoGroupDetailController;
    }
    photoGroupDetailController.photoALAssets = photoGroup.photoALAssets;
    [self.navigationController pushViewController:photoGroupDetailController animated:YES];
}

#pragma mark - getter && setter
- (void)setMaxCount:(NSInteger)maxCount {
    _maxCount = maxCount;
}

- (UIView *)errorMessageView {
    if (!_errorMessageView) {
        UIView *errorMessageView = [[UIView alloc]init];
        errorMessageView.backgroundColor = [UIColor whiteColor];
        errorMessageView.frame = self.view.bounds;
        errorMessageView.hidden = YES;
        self.errorMessageView = errorMessageView;
        [self.view addSubview:errorMessageView];
        
        UILabel *msgLabel = [[UILabel alloc]init];
        msgLabel.text = @"未能读取到任何照片";
        msgLabel.backgroundColor = [UIColor clearColor];
        msgLabel.font = [UIFont systemFontOfSize:15];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.textColor = [UIColor lightGrayColor];
        CGFloat msgLabelHeight = 15;
        msgLabel.frame = CGRectMake(0, (CGRectGetHeight(errorMessageView.frame) - msgLabelHeight) * 0.5 , CGRectGetWidth(errorMessageView.frame), msgLabelHeight);
        [errorMessageView addSubview:msgLabel];
        
        _errorMessageView = errorMessageView;
    }
    return _errorMessageView;
}

@end
