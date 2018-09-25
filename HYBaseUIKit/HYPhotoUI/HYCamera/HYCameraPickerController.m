//
//  CommonCameraPickerController.m
//  WeiKePad
//
//  Created by lee on 15-1-12.
//  Copyright (c) 2015年 WeiKeGroup. All rights reserved.
//

#import "HYCameraPickerController.h"

@interface HYCameraPickerController ()

@end

@implementation HYCameraPickerController

/**
 *  @Author licheng, 14-12-26 11:12:20
 *
 *  TODO:屏幕方向改变通知
 */
- (void)statusBarOrientationWillChange:(NSNotification *)notification {
    NSInteger newOrientation = [[[notification userInfo] objectForKey:UIApplicationStatusBarOrientationUserInfoKey] integerValue];
    switch (newOrientation) {
        case UIInterfaceOrientationLandscapeRight:{
            self.cameraViewTransform = CGAffineTransformMakeRotation(0);
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            self.cameraViewTransform = CGAffineTransformMakeRotation(M_PI);
        }
            break;
        case UIInterfaceOrientationPortrait:{
            self.cameraViewTransform = CGAffineTransformMakeRotation(M_PI_2);
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:{
            self.cameraViewTransform = CGAffineTransformMakeRotation(M_PI_2*3);
        }
            break;
            
        default:
            break;
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
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
