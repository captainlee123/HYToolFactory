//
//  AlbumViewController.h
//  WeiKePad
//
//  Created by lee on 15-1-29.
//  Copyright (c) 2015年 WeiKeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYNativeAlbumViewController.h"
#import "HYBaseViewController.h"

@interface HYAlbumViewController : HYBaseViewController

@property (nonatomic, weak) id<NativeAlbumViewControllerDelegate>       delegate;

@property (nonatomic, weak) id<EditImageViewControllerDelegate>         editDelegate;

@property (nonatomic, weak) id<ClipImageViewControllerDelegate>         clipDelegate;

@property (nonatomic, assign) BOOL isPresent;

@end
