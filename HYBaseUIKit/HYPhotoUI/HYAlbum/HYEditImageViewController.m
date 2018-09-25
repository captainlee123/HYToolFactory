//
//  EditImageViewController.m
//  WeiKePad
//
//  Created by lee on 15-1-22.
//  Copyright (c) 2015年 WeiKeGroup. All rights reserved.
//

#import "HYEditImageViewController.h"
#import "HYBaseUIHeader.h"
#import "UIImage+HYAddition.h"
#import "HYPhotoKit.h"

@interface HYEditImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView       *imgView;
@property (nonatomic, strong) UIScrollView      *scrollView;

//裁剪区域高宽比
@property (nonatomic, assign) CGFloat           ratio;

@end

@implementation HYEditImageViewController

- (void)loadView {
    [super loadView];
    [self configHeaderBar];
}

- (void)configHeaderBar {
    [self.headerBar leftBtnSetImage:[HYBaseUITool hy_imageNamed:@"hy_return_btn"] forState:0];
    [self.headerBar leftBtnAddTarget:self selector:@selector(backAction)];
    
    [self.headerBar centerBtnSetTitle:@"移动和缩放" forState:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HY_RGBA(190, 190, 190, 1);
    
    self.ratio = [HYPhotoKit shareInstance].clipRatio;
    if (self.ratio == 0) {
        self.ratio = 1.0;
    }
    [self initView];
}

- (void)initView {
    self.view.clipsToBounds = YES;
    [self initContentView];
    [self initBottomView];
}

/**
 *  @Author licheng, 15-01-22 11:01:34
 *
 *  TODO:初始化 - 内容view
 */
- (void)initContentView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = width * self.ratio;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+(HY_SCREEN_HEIGHT-64-45-height)/2.0, width, height)];
    
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1.5;
    self.scrollView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.scrollView.layer.borderWidth = 2;
    [self.view insertSubview:self.scrollView atIndex:0];
    
    if (self.editImage) {
        self.imgView =[[UIImageView alloc] initWithFrame:CGRectZero];
        CGFloat imageRatio = self.editImage.size.height / self.editImage.size.width;  //图片高宽比
        if (imageRatio >  self.ratio) {
            self.imgView.frame = CGRectMake(0, 0, width, width*imageRatio);
            self.scrollView.contentSize = self.imgView.frame.size;
            self.scrollView.contentOffset = CGPointMake(0, (self.imgView.frame.size.height-self.scrollView.frame.size.height)/2);
        }else {
            self.imgView.frame = CGRectMake(0, 0, height/imageRatio, height);
            self.scrollView.contentSize = self.imgView.frame.size;
            self.scrollView.contentOffset = CGPointMake((self.imgView.frame.size.width-self.scrollView.frame.size.width)/2, 0);
        }
        self.imgView.image = self.editImage;
        [self.scrollView addSubview:self.imgView];
    }
}

/**
 *  @Author licheng, 15-01-22 11:01:34
 *
 *  TODO:初始化 - BottomView
 */
- (void)initBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, HY_SCREEN_HEIGHT-45, HY_SCREEN_WIDTH, 45)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomView.frame.size.width-70, 5, 60, 35)];
    confirmBtn.exclusiveTouch = YES;
    confirmBtn.layer.cornerRadius = 5.0;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setBackgroundImage:[UIImage createImageWithColor:HY_HEADER_COLOR] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmBtn];
}

#pragma mark ============== UIScrollViewDelegate =============
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}



#pragma mark ===== Button Action =====
/// 返回
- (void)backAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editImageViewControllerDidClickbackButton:)]) {
        [self.delegate editImageViewControllerDidClickbackButton:self];
    }
}

/// 确认编辑
- (void)confirmAction:(UIButton *)sender {
    CGRect imgViewFrame = [self.scrollView convertRect:self.imgView.frame toView:self.view];
    //裁剪区域
    CGRect frame = CGRectMake(self.scrollView.frame.origin.x-imgViewFrame.origin.x, self.scrollView.frame.origin.y-imgViewFrame.origin.y, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    //对原图裁剪的区域
    CGFloat scale = self.scrollView.contentSize.height/self.editImage.size.height;
    CGRect convertFrame = CGRectMake(frame.origin.x/scale, frame.origin.y/scale, frame.size.width/scale, frame.size.height/scale);
    
    //裁剪后的图片 超过320*320 则缩放
    UIImage *editImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.editImage.CGImage, convertFrame) scale:1 orientation:self.editImage.imageOrientation];
//    if (editImage.size.width > 320) {
//        editImage = [editImage resizeImageTo:CGSizeMake(320, 320)];
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(editImageViewController:didFinishClipImage:)]) {
        [self.delegate editImageViewController:self didFinishClipImage:editImage];
    }
}

/**
 *  @Author licheng, 15-01-22 13:01:00
 *
 *  TODO:截取 部分图片
 */
- (UIImage*)getSubImage:(CGRect)rect fromImage:(UIImage *)image {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
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
