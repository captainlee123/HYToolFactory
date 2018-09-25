//
//  ClipImageViewController.m
//  QAService
//
//  Created by captain on 15/9/22.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import "ClipImageViewController.h"
#import "WKImageClipView.h"

@interface ClipImageViewController () <WKImageClipViewDelegate>

@end

@implementation ClipImageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initView];
}

- (void)initView {
    WKImageClipView *clipView = [[WKImageClipView alloc] initWithImage:self.clipImage frame:self.view.bounds];
    clipView.delegate = self;
    [self.view addSubview:clipView];
}

#pragma mark ============== WKImageClipViewDelegate ============
/**
 TODO:图片裁剪界面取消回调
 
 @author 徐晨阳
 @since 1.0
 */
- (void)WKImageClipViewDidCancelClip {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clipImageViewControllerDidClickbackButton:)]) {
        [self.delegate clipImageViewControllerDidClickbackButton:self];
    }
}

/**
 TODO:图片裁剪界面取消回调
 
 @param clippedImage 裁剪后的图片
 
 @author 徐晨阳
 @since 1.0
 */
- (void)WKImageClipViewDidConfirmClipWithImage:(UIImage *)clippedImage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clipImageViewController:didFinishClipImage:)]) {
        [self.delegate clipImageViewController:self didFinishClipImage:clippedImage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
