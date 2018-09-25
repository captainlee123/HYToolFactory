//
//  SM_MediaTool.h
//  ShanPao
//
//  Created by captain on 15-8-2.
//  Copyright (c) 2015年 imohoo.com. All rights reserved.
//

/*
 Attention:
 在info.plist中添加
 （使用相册）NSPhotoLibraryUsageDescription
 （使用相机）NSCameraUsageDescription
 */

#import <UIKit/UIKit.h>
#import "HYPhotoAssets.h"
#import "HYAlbumViewController.h"
@class HYPhotoKit;


typedef NS_ENUM(NSInteger, PHOTO_PROCESS_TYPE) {
    PHOTO_PROCESS_TYPE_SELECT = 0,      //多张图片选择
    PHOTO_PROCESS_TYPE_EDIT,            //图片编辑
    
    PHOTO_PROCESS_TYPE_CLIP,            //图片裁剪 addTime:2015-9-22
    
    PHOTO_PROCESS_TYPE_SINGLE_SELECT,   //单张相册、视频选择  addTime:2017-11-17
};

@protocol HYPhotoKitDelegate <NSObject>

@optional
/**
 *  @Author 有点坑, 15-08-02 11:08:48
 *
 *  TODO:拍照完成
 *
 *  @param tool
 *  @param info
 */
- (void)HYPhotoKit:(HYPhotoKit *)tool didFinishPickingMediaWithInfo:(NSDictionary *)info picker:(UIImagePickerController *)picker;

/**
 *  @Author 有点坑, 15-08-02 11:08:51
 *
 *  TODO:选完本地相册
 *
 *  @param tool
 *  @param imgArr
 */
- (void)HYPhotoKit:(HYPhotoKit *)tool didFinishChoosePhotos:(NSMutableArray *)imgArr;

/**
 *  @author 有点坑, 15-09-06 15:09:28
 *
 *  TODO:编辑单张照片完成
 *
 *  @param tool
 *  @param editImage
 */
- (void)HYPhotoKit:(HYPhotoKit *)tool didFinishEditImage:(UIImage *)editImage;

/**
 *  @author 有点坑, 15-09-22 17:09:16
 *
 *  TODO:裁剪图片完成
 *
 *  @param tool
 *  @param clipImage
 */
- (void)HYPhotoKit:(HYPhotoKit *)tool didFinishClipImage:(UIImage *)clipImage;

@end

@interface HYPhotoKit : NSObject

@property (nonatomic, weak) id<HYPhotoKitDelegate>       delegate;

//选择照片方式   default is PHOTO_PROCESS_TYPE_SELECT 照片选择
@property (nonatomic, assign) PHOTO_PROCESS_TYPE    photoType;
//拍照是否允许编辑  default is NO
@property (nonatomic, assign) BOOL          cameraAllowsEditing;
//允许选择照片 的最大数
@property (nonatomic, assign) NSInteger     allowMaxPhotoNum;

@property (nonatomic, assign) CGFloat       clipRatio; //裁剪尺寸

//唯一标示
@property (nonatomic, assign) NSInteger     tag;

/**
 *  @Author 有点坑, 15-08-02 11:08:13
 *
 *  TODO:创建单例
 */
+ (HYPhotoKit *)shareInstance;

/**
 *  @Author 有点坑, 15-08-02 11:08:13
 *
 *  TODO:释放单例
 */
+ (void)freeInstance;

/**
 *  TODO:选择【相册/拍照】
 */
- (void)addPhotoFromViewController:(UIViewController *)viewController delegate:(id<HYPhotoKitDelegate>)delegate;

/*
 *  直接选择【相册】
 */
- (void)addPhotoWithAlbumFromViewController:(UIViewController *)viewController delegate:(id<HYPhotoKitDelegate>)delegate;

/*
 *  直接选择【拍照】
 */
- (void)addPhotoWithCameraFromViewController:(UIViewController *)viewController delegate:(id<HYPhotoKitDelegate>)delegate;

@end
