//
//  PhotoAssets.m
//  ImagePicker
//
//  Created by lee on 15-1-22.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "HYPhotoAssets.h"
#import "HYBaseUITool.h"

@implementation HYPhotoAssets

+ (HYPhotoAssets *)addType {
    HYPhotoAssets *photo = [[HYPhotoAssets alloc] init];
    photo.type = IMAGE_TYPE_ADD;
    photo.bigImage = [HYBaseUITool hy_imageNamed:@"hy_add_img"];
    return photo;
}

@end
