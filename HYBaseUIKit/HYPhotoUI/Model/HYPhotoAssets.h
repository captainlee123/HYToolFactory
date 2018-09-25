//
//  PhotoAssets.h
//  ImagePicker
//
//  Created by lee on 15-1-22.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, IMAGE_TYPE) {
    IMAGE_TYPE_PHOTO,               //本地照片
    IMAGE_TYPE_CAMERA,              //拍摄照片
    IMAGE_TYPE_ADD,                  //添加符号
    IMAGE_TYPE_VIDEO,               //视频
};

@interface HYPhotoAssets : NSObject

//缩略图
@property (nonatomic ,strong) UIImage       *thumbnail;
//原图(大图)
@property (nonatomic, strong) UIImage       *bigImage;

@property (nonatomic ,strong) ALAsset       *asset;

@property (nonatomic, assign) IMAGE_TYPE    type;

@property (nonatomic, strong) NSData    *videoData;
@property (nonatomic, strong) NSURL     *videoURL;

+ (HYPhotoAssets *)addType;

@end
