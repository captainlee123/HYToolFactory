//
//  ClipImageViewController.h
//  QAService
//
//  Created by captain on 15/9/22.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import "HYBaseViewController.h"
@class ClipImageViewController;

@protocol ClipImageViewControllerDelegate <NSObject>

@optional
/**
 *  TODO:返回
 */
- (void)clipImageViewControllerDidClickbackButton:(ClipImageViewController *)vc;

/**
 *  TODO:裁剪完成
 */
- (void)clipImageViewController:(ClipImageViewController *)vc didFinishClipImage:(UIImage *)clipImage;

@end

@interface ClipImageViewController : HYBaseViewController

@property (nonatomic, strong) UIImage       *clipImage;

@property (nonatomic, weak) id<ClipImageViewControllerDelegate> delegate;

//是否是拍照
@property (nonatomic, assign) BOOL          isFromCamera;

@end
