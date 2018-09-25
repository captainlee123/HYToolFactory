//
//  AVPlayerView.m
//  PhoenixChinese
//
//  Created by captain on 2016/10/27.
//  Copyright © 2016年 李诚. All rights reserved.
//

#import "AVPlayerView.h"
#import "HYBaseUIHeader.h"

@interface AVPlayerView (){
    //总时间
    float second;
    BOOL isPlaying;
}

@property (nonatomic, strong) NSURL             *videoURL;

@property (nonatomic, strong) AVPlayerItem      *playerItem;
@property (nonatomic, strong) AVPlayer          *player;


//小菊花
@property (nonatomic, strong) UIActivityIndicatorView   *indicatorView;

//当前播放时长
@property (nonatomic, assign) CGFloat           currentTime;

@property (nonatomic, assign) BOOL              shouldPlay;

@end

@implementation AVPlayerView

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    //移除KVO
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

- (instancetype)initWithURL:(NSURL *)videoURL {
    self = [super initWithFrame:HY_APP_RECT];
    if (self) {
        self.videoURL = videoURL;
        [self configPlayView];
        [self configActivityView];
    }
    return self;
}

#pragma mark=======================UI==========================
- (void)configPlayView {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    AVURLAsset *movieAsset = [AVURLAsset URLAssetWithURL:self.videoURL options:nil];
    self.playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    //监听status属性
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //监听loadedTimeRanges属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.frame = self.bounds;
    self.playerLayer.backgroundColor = [[UIColor blackColor] CGColor];
    
    [self.layer addSublayer:self.playerLayer];
}

//小菊花
- (void)configActivityView {
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicatorView.frame = self.bounds;
    [self addSubview:self.indicatorView];
}


#pragma mark====================界面布局===========================
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
    self.indicatorView.frame = self.bounds;
}

#pragma mark ================== 播放Notification ===============
/**
 *  @author 施峰磊, 15-06-02 11:06:02
 *
 *  TODO:播放结束
 *
 *  @param notification
 *
 *  @since 1.0
 */
- (void)moviePlayDidEnd:(NSNotificationCenter *)notification{
    //回到第一帧
    CMTime dragedCMTime = CMTimeMake(0, 1);
    [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){

    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(avPlayerViewDidPlayEnd:)]) {
        [self.delegate avPlayerViewDidPlayEnd:self];
    }
}

/**
 *  @author 施峰磊, 15-06-02 15:06:28
 *
 *  TODO:监听播放状态
 *
 *  @param playerItem
 *
 *  @since 1.0
 */
- (void)monitoringPlayStatus:(AVPlayerItem *)playerItem {
    WEAKSELF
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 25) queue:NULL usingBlock:^(CMTime time) {
        
        weakSelf.currentTime = CMTimeGetSeconds(time);// 计算当前在第几秒
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(avPlayerView:currentTime:)]) {
            [weakSelf.delegate avPlayerView:weakSelf currentTime:weakSelf.currentTime];
        }
    }];
}

#pragma mark ================= 播放监听KVO ==============
/**
 *  @author 施峰磊, 15-06-02 15:06:46
 *
 *  TODO:kvo监听
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 *
 *  @since 1.0
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            [self hideLoading];
            //获取视频总长度
            CMTime duration = self.playerItem.duration;
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            
            
            // 监听播放状态
            [self monitoringPlayStatus:self.playerItem];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(avPlayerView:didFinishLoadingBaseInfo:)]) {
                    [self.delegate avPlayerView:self didFinishLoadingBaseInfo:CMTimeGetSeconds(duration)];
                }
            });
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            //加载失败
            NSLog(@"AVPlayerStatusFailed");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(avPlayerViewLoadFailed:)]) {
                    [self.delegate avPlayerViewLoadFailed:self];
                }
            });
            
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //持续加载
        NSArray *array = playerItem.loadedTimeRanges;
        //本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        CGFloat startSeconds = CMTimeGetSeconds(timeRange.start);
        CGFloat durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        CGFloat totalBuffer = startSeconds + durationSeconds;
//        NSLog(@"共缓冲：%.2f",totalBuffer);
        
//        if (self.player.rate == 0) {
//            [self showLoading];
//        }else {
//            [self hideLoading];
//        }
        
        if (totalBuffer > (self.currentTime+0.5) && self.shouldPlay) {
            //缓冲大于当前播放0.5秒的话，并且如果应该播放
            [self.player play];
        }
    }
}

/**
 *  @author 施峰磊, 15-06-02 15:06:17
 *
 *  TODO:计算缓冲时间
 *
 *  @return
 *
 *  @since 1.0
 */
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}


#pragma mark ==== Public Method =====
- (void)showLoading {
    [self.indicatorView startAnimating];
}

- (void)hideLoading {
    [self.indicatorView stopAnimating];
}

- (void)play {
    self.shouldPlay = YES;
    [self.player play];
}

- (void)pause {
    self.shouldPlay = NO;
    [self.player pause];
}

/*
 *  设置播放进度
 */
- (void)setPlayerProgress:(CGFloat)progress {
//    CMTime dragedCMTime = CMTimeMake(progress, 1);
    //精确到1位小数
    Float64 convertProgress = [NSString stringWithFormat:@"%.1f", progress].doubleValue;
    
    CMTime dragedCMTime = CMTimeMakeWithSeconds(convertProgress, 25); //CMTimeMakeWithSeconds(a,b)    a当前时间,b每秒钟多少帧.
    WEAKSELF
    [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
        [weakSelf.player play];
    }];
}


/*
 *  设置音量
 */
- (void)setVediovolume:(UISlider *)slider {
    NSArray *audioTracks = [self.playerItem.asset tracksWithMediaType:AVMediaTypeAudio];
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams =
        [AVMutableAudioMixInputParameters audioMixInputParameters];
        [audioInputParams setVolume:slider.value atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    [audioMix setInputParameters:allAudioParams];
    
    [self.playerItem setAudioMix:audioMix];
}


@end
