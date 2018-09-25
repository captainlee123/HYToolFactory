//
//  PhotoDisplayViewController.h
//  MEIKU
//
//  Created by 李诚 on 15/4/17.
//  Copyright (c) 2015年 Mrrck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBaseViewController.h"
#import "HYPhotoAssets.h"
@class HYPhotoDisplayViewController;

@protocol PhotoDisplayViewControllerDelegate <NSObject>

@optional
- (void)photoDisplayViewController:(HYPhotoDisplayViewController *)vc didDeletePhoto:(HYPhotoAssets *)photo;

- (void)photoDisplayViewController:(HYPhotoDisplayViewController *)vc didDidSelectIndex:(NSInteger)index photo:(HYPhotoAssets *)photo;

@end

@interface HYPhotoDisplayViewController : HYBaseViewController

@property (nonatomic, assign) NSInteger             selectIndex;

@property (nonatomic, strong) NSArray               *photos;

//是否显示删除button default is NO
@property (nonatomic, assign) BOOL                  showDeleteBtn;

@property (nonatomic, weak) id<PhotoDisplayViewControllerDelegate>  delegate;

@end
