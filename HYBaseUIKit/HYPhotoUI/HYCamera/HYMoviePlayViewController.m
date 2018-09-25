//
//  HYMoviePlayViewController.m
//  TimeCapsule
//
//  Created by captain on 2017/8/29.
//  Copyright © 2017年 李诚. All rights reserved.
//

#import "HYMoviePlayViewController.h"
#import "AVPlayerView.h"
#import "HYBaseUIHeader.h"

@interface HYMoviePlayViewController () <AVPlayerViewDelegate>

@property (nonatomic, strong) AVPlayerView      *playerView;

/*顶部cover*/
@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic, strong) UIButton          *backBtn;

//开始播放按钮
@property (nonatomic, strong) UIButton       *startPlayBtn;
//是否播放
@property (nonatomic, assign) BOOL          isPlaying;

@end

static CGFloat kTopFullGapping = 64.f;
//static CGFloat kBotFullGapping = 50.f;

@implementation HYMoviePlayViewController

- (void)dealloc {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hyMoviePlayViewControllerDidDealloc:)]) {
        [self.delegate hyMoviePlayViewControllerDidDealloc:self];
    }
    
    [self.playerView pause];
}

#pragma mark ===== Button Action =====
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hyMoviePlayViewControllerDidConfirm:)]) {
        [self.delegate hyMoviePlayViewControllerDidConfirm:self];
    }
}

- (void)startPlayAction {
    [self playVideoAndAudio];
}


- (void)loadView {
    [super loadView];
    self.headerBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopVideoAndAudio];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initPlayerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
    self.view.backgroundColor = [UIColor blackColor];
    //默认不播放
    self.isPlaying = NO;
}

#pragma mark ===== 初始化 =====
- (void)initData {
    if (self.photoAsset) {
        self.videoURL = [self.photoAsset.asset valueForProperty:ALAssetPropertyAssetURL];
    }
}

- (void)initView {
    [self initHeaderView];
}

- (void)initPlayerView {
    if (self.playerView) {
        return;
    }
    self.playerView = [[AVPlayerView alloc] initWithURL:self.videoURL];
    self.playerView.delegate = self;
    self.playerView.frame = self.view.bounds;
    self.playerView.playerLayer.frame = self.playerView.bounds;
    [self.view insertSubview:self.playerView atIndex:0];
    
    self.startPlayBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 66)];
    self.startPlayBtn.center = self.view.center;
    [self.startPlayBtn addTarget:self action:@selector(startPlayAction) forControlEvents:UIControlEventTouchUpInside];
    self.startPlayBtn.userInteractionEnabled = NO;
    [self.startPlayBtn setImage:[HYBaseUITool hy_imageNamed:@"hy_video_play"] forState:0];
    [self.view addSubview:self.startPlayBtn];
}

//头部cover view
- (void)initHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kTopFullGapping)];
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headerView];
    
    CGFloat topButtonW = 44.0f;
    //返回
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, topButtonW, topButtonW)];
    [self.backBtn setImage:[HYBaseUITool hy_imageNamed:@"hy_video_back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.backBtn];
}


#pragma mark ===== AVPlayerViewDelegate =====
//基本信息加载完毕
- (void)avPlayerView:(AVPlayerView *)playerView didFinishLoadingBaseInfo:(CGFloat)totalTime {
    //1.开始播放
    [self playVideoAndAudio];
    
    //2.刷新播放按钮状态
    self.startPlayBtn.userInteractionEnabled = YES;
}

//加载失败
- (void)avPlayerViewLoadFailed:(AVPlayerView *)playerView {
    self.startPlayBtn.userInteractionEnabled = NO;
    
    self.startPlayBtn.hidden = NO;
}

//当前播放的时间
- (void)avPlayerView:(AVPlayerView *)playerView currentTime:(CGFloat)currentTime {
    
}

//播放结束
- (void)avPlayerViewDidPlayEnd:(AVPlayerView *)playerView {
    [self stopVideoAndAudio];
}


//播放视频&音频
- (void)playVideoAndAudio {
    self.isPlaying = YES;
    
    [self.playerView play];
    self.startPlayBtn.hidden = YES;
}

//停止视频&音频
- (void)stopVideoAndAudio {
    self.isPlaying = NO;
    
    [self.playerView pause];
    self.startPlayBtn.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
