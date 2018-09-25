//
//  SM_MediaTool.m
//  ShanPao
//
//  Created by captain on 15-8-2.
//  Copyright (c) 2015年 imohoo.com. All rights reserved.
//

#import "HYPhotoKit.h"
#import "HYCameraPickerController.h"
#import "HYBaseNavigationController.h"
#import "ClipImageViewController.h"
#import "HYBaseUIHeader.h"

@interface HYPhotoKit () <NativeAlbumViewControllerDelegate,EditImageViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ClipImageViewControllerDelegate>
@property (nonatomic, strong) UIViewController                  *tempVC;
@end

static HYPhotoKit *_mediaTool = nil;

@implementation HYPhotoKit

/**
 *  @Author 有点坑, 15-08-02 11:08:13
 *
 *  TODO:创建单例
 *
 *  @return
 *
 *  @since 1.0
 */
+ (HYPhotoKit *)shareInstance {
    @synchronized(self) {
        if (!_mediaTool) {
            _mediaTool = [[self alloc] init];
        }
    }
    return _mediaTool;
}

/**
 *  @Author 有点坑, 15-08-02 11:08:13
 *
 *  TODO:释放单例
 *
 *  @return
 *
 *  @since 1.0
 */
+ (void)freeInstance {
    _mediaTool = nil;
}

/**
 *  TODO:选择【相册/拍照】
 */
- (void)addPhotoFromViewController:(UIViewController *)viewController delegate:(id<HYPhotoKitDelegate>)delegate {
    self.tempVC = viewController;
    self.delegate = delegate;
    
    WEAKSELF
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:actionCancel];
    
    //拍照
    UIAlertAction *actionConfirm1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openCamera];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:actionConfirm1];
    
    //相册
    UIAlertAction *actionConfirm2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf openAlbum];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:actionConfirm2];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

/*
 *  直接选择【相册】
 */
- (void)addPhotoWithAlbumFromViewController:(UIViewController *)viewController delegate:(id<HYPhotoKitDelegate>)delegate {
    self.tempVC = viewController;
    self.delegate = delegate;
    
    self.photoType = PHOTO_PROCESS_TYPE_SELECT;
    [self openAlbum];
}

/*
 *  直接选择【拍照】
 */
- (void)addPhotoWithCameraFromViewController:(UIViewController *)viewController delegate:(id<HYPhotoKitDelegate>)delegate {
    self.tempVC = viewController;
    self.delegate = delegate;
    
    [self openCamera];
}

/**
 *  @Author 有点坑, 15-08-02 11:08:01
 *
 *  TODO:打开拍照
 *
 *  @since 1.0
 */
- (void)openCamera {
    HYCameraPickerController *cameraPicker = [[HYCameraPickerController alloc] init];
    cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraPicker.delegate = self;
    cameraPicker.allowsEditing = self.cameraAllowsEditing;
    [self.tempVC presentViewController:cameraPicker animated:YES completion:nil];
}

/**
 *  @Author 有点坑, 15-08-02 11:08:01
 *
 *  TODO:打开相册
 *
 *  @since 1.0
 */
- (void)openAlbum {
    HYAlbumViewController *albumVC = [[HYAlbumViewController alloc] init];
    albumVC.delegate = self;
    albumVC.editDelegate = self;
    albumVC.clipDelegate = self;
    albumVC.isPresent = YES;
    
    HYBaseNavigationController *navi = [[HYBaseNavigationController alloc] initWithRootViewController:albumVC];
    [self.tempVC presentViewController:navi animated:YES completion:nil];
}


#pragma mark =================== NativeAlbumViewControllerDelegate ====================
/**
 *  @author 李诚, 15-04-16 17:04:43
 *
 *  TODO:选完本地相册回调
 */
- (void)nativeAlbumViewController:(HYNativeAlbumViewController *)album didSelectImages:(NSMutableArray *)imageArr {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HYPhotoKit:didFinishChoosePhotos:)]) {
        [self.delegate HYPhotoKit:self didFinishChoosePhotos:imageArr];
    }
}

#pragma mark ======== UIImagePickerControllerDelegate ==========
/**
 *  @author 李诚, 15-04-17 14:04:39
 *
 *  TODO:拍完照回调
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image;
    if (self.cameraAllowsEditing) {
        [info objectForKey:UIImagePickerControllerEditedImage];
    }else {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    //先压缩
    UIImage *handleImage = [image zoomOutImageInMaxWidth:HY_SCREEN_WIDTH*2 MaxHeight:HY_SCREEN_HEIGHT*2];
    //再旋转
    handleImage = [self rotateImage:handleImage];
    
    if (self.photoType == PHOTO_PROCESS_TYPE_EDIT) {
        // 编辑图片
        
        HYEditImageViewController *editViewController = [[HYEditImageViewController alloc] init];
        editViewController.editImage = handleImage;
        editViewController.delegate = self;
        editViewController.isFromCamera = YES;
        [picker pushViewController:editViewController animated:YES];
        
    }else if (self.photoType == PHOTO_PROCESS_TYPE_CLIP) {
        // 裁剪图片
        ClipImageViewController *clipVC = [[ClipImageViewController alloc] init];
        clipVC.delegate = self;
        clipVC.clipImage = handleImage;
        clipVC.isFromCamera = YES;
        [picker pushViewController:clipVC animated:YES];
        
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(HYPhotoKit:didFinishPickingMediaWithInfo:picker:)]) {
            [self.delegate HYPhotoKit:self didFinishPickingMediaWithInfo:info picker:picker];
        }
    }
}

#pragma mark ========= EditImageViewControllerDelegate ========
- (void)editImageViewControllerDidClickbackButton:(HYEditImageViewController *)vc {
    if (vc.isFromCamera) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }else {
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  TODO: 编辑单张照片完成
 */
- (void)editImageViewController:(HYEditImageViewController *)vc didFinishClipImage:(UIImage *)editImage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HYPhotoKit:didFinishEditImage:)]) {
        [self.delegate HYPhotoKit:self didFinishEditImage:editImage];
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ======== ClipImageViewControllerDelegate ====
/**
 *  @author 有点坑, 15-09-22 17:09:13
 *
 *  TODO:返回
 *
 *  @param vc
 *  @param clipImage
 *
 *  @since 1.0
 */
- (void)clipImageViewControllerDidClickbackButton:(ClipImageViewController *)vc {
    if (vc.isFromCamera) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }else {
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

/**
 *  @author 有点坑, 15-09-22 17:09:13
 *
 *  TODO:裁剪完成
 *
 *  @param vc
 *  @param clipImage
 *
 *  @since 1.0
 */
- (void)clipImageViewController:(ClipImageViewController *)vc didFinishClipImage:(UIImage *)clipImage {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HYPhotoKit:didFinishClipImage:)]) {
        [self.delegate HYPhotoKit:self didFinishClipImage:clipImage];
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark =================== 图片处理 ====================
- (UIImage *)rotateImage:(UIImage *)aImage {
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = aImage.imageOrientation;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

@end
