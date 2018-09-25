//
//  AVPlayerView.h
//  PhoenixChinese
//
//  Created by captain on 2016/10/27.
//  Copyright © 2016年 李诚. All rights reserved.
//

/*
 *  播放器界面
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class AVPlayerView;

@protocol AVPlayerViewDelegate <NSObject>

@optional
//基本信息加载完毕
- (void)avPlayerView:(AVPlayerView *)playerView didFinishLoadingBaseInfo:(CGFloat)totalTime;

//加载失败
- (void)avPlayerViewLoadFailed:(AVPlayerView *)playerView;

//当前播放的时间
- (void)avPlayerView:(AVPlayerView *)playerView currentTime:(CGFloat)currentTime;

//播放结束
- (void)avPlayerViewDidPlayEnd:(AVPlayerView *)playerView;

@end

@interface AVPlayerView : UIView

@property (nonatomic, weak) id<AVPlayerViewDelegate>    delegate;

@property (nonatomic, strong) AVPlayerLayer             *playerLayer;

- (instancetype)initWithURL:(NSURL *)videoURL;

- (void)showLoading;
- (void)hideLoading;
- (void)play;
- (void)pause;

/*
 *  设置播放进度
 */
- (void)setPlayerProgress:(CGFloat)progress;

@end
