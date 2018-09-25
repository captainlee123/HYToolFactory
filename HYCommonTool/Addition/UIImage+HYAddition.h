//
//  UIImage+Addition.h
//  ToolLibrary
//
//  Created by fuzhifei on 11-11-28.
//  Copyright (c) 2011年 imohoo. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 图片方向
typedef NS_ENUM(NSInteger, HYImageDirection) {
    HYImageDirectionTopToBottom = 1 << 0,  //从上到下
    HYImageDirectionLeftToRight = 1 << 1,    //从左到右
    HYImageDirectionLeftTopToRightBottom = 1 << 2, //左上 -> 右下
    HYImageDirectionLeftBottomToRightTop = 1 << 3, //左下 -> 右上
};

@interface UIImage (HYAddition)

/*
 *  TODO:切割图片
 *  作用：从左上角开始切割size大小的图片,若图片原始的宽和高小于size的宽，高则使用原图片的宽或高
 *  @param size，需要切割的大小
 */
- (UIImage *)clipImageFromOriginToNewSize:(CGSize)size;

/*
 *作用：将图片重绘为size大小
 *参数：size，需要重绘的大小
 *返回值：新图片
 */
- (UIImage *)resizeImageTo:(CGSize)size;

/*
 *作用：在CGSize(w_max,h_max)范围内等比例缩小图片
 *参数：w_max,宽  h_max,高
 *返回值：新图片（若源图片的宽和高都比w_max，h_max小，则返回原图片）
 */
- (UIImage *)zoomOutImageInMaxWidth:(float)w_max MaxHeight:(float)h_max;

/*
 *作用：将图片的宽或高至少一边放大到w_min，h_min
 *参数：w_min,宽  h_min,高
 *返回值：新图片，（若源图片的宽和高都比w_min，h_min大，则返回原图片）
 */
- (UIImage *)zoomInImageBaseOn:(float)w_min DestHeight:(float)h_min;

/**
 *  TODO:获取高斯模糊图片
 *
 *  @param oldImage
 *  @param radius
 *  @param iterations
 *  @param tintColor
 */
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

/**
 *  TODO:颜色生成图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

/**
 *  生成渐变背景色
 *  @param startColor   起始颜色
 *  @param endColor     终止颜色
 *  @param imageSize    生成的图片大小
 *  @param direction    渐变方向
 */
+ (UIImage *)gradientImage:(UIColor *)startColor endColor:(UIColor *)endColor imageSize:(CGSize)imageSize direction:(HYImageDirection)direction;


//获取视频的第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)videoPath;

/// 截取屏幕图片 (适配tableView或者scrollView)
+ (UIImage *)screenshotImageFromView:(UIView *)view;

@end
