//
//  EditImageViewController.h
//  WeiKePad
//
//  Created by lee on 15-1-22.
//  Copyright (c) 2015年 WeiKeGroup. All rights reserved.
//

#import "HYBaseViewController.h"
@class HYEditImageViewController;

@protocol EditImageViewControllerDelegate <NSObject>

@optional
/**
 *  TODO:返回
 */
- (void)editImageViewControllerDidClickbackButton:(HYEditImageViewController *)vc;

/**
 *  TODO:编辑完成
 */
- (void)editImageViewController:(HYEditImageViewController *)vc didFinishClipImage:(UIImage *)editImage;

@end

@interface HYEditImageViewController : HYBaseViewController

@property (nonatomic, weak) id<EditImageViewControllerDelegate>         delegate;

@property (nonatomic, strong) UIImage   *editImage;

//是否是拍照
@property (nonatomic, assign) BOOL      isFromCamera;

@end
