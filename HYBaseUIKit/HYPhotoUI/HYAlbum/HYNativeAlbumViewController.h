//
//  NativeAlbumViewController.h
//  ImagePicker
//
//  Created by lee on 15-1-22.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HYPhotoAssets.h"
#import "HYEditImageViewController.h"
#import "HYBaseViewController.h"
#import "ClipImageViewController.h"

@class HYNativeAlbumViewController;

@protocol NativeAlbumViewControllerDelegate <NSObject>

@optional
- (void)nativeAlbumViewController:(HYNativeAlbumViewController *)album didSelectImages:(NSMutableArray *)mediaArr;

@end

@interface HYNativeAlbumViewController : HYBaseViewController

@property (nonatomic, strong) ALAssetsGroup                             *group;

@property (nonatomic, weak) id<NativeAlbumViewControllerDelegate>       delegate;

@property (nonatomic, weak) id<EditImageViewControllerDelegate>         editDelegate;

@property (nonatomic, weak) id<ClipImageViewControllerDelegate>         clipDelegate;

@end
