//
//  HYMoviePlayViewController.h
//  TimeCapsule
//
//  Created by captain on 2017/8/29.
//  Copyright © 2017年 李诚. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYPhotoAssets.h"

@class HYMoviePlayViewController;

@protocol HYMoviePlayViewControllerDelegate <NSObject>

@optional
//确认选择
- (void)hyMoviePlayViewControllerDidConfirm:(HYMoviePlayViewController *)vc;
//界面释放
- (void)hyMoviePlayViewControllerDidDealloc:(HYMoviePlayViewController *)vc;

@end


@interface HYMoviePlayViewController : HYBaseViewController

@property (nonatomic, weak) id<HYMoviePlayViewControllerDelegate>   delegate;

//直接拍摄
@property (nonatomic, strong) NSURL             *videoURL;
//本地视频
@property (nonatomic, strong) HYPhotoAssets     *photoAsset;

@end
