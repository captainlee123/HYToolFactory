//
//  UIImage+Addition.m
//  ToolLibrary
//
//  Created by fuzhife on 11-11-28.
//  Copyright (c) 2011年 imohoo. All rights reserved.
//

#import "UIImage+HYAddition.h"
#import <AVFoundation/AVFoundation.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (HYAddition)

/*
 *  TODO:切割图片
 *  作用：从左上角开始切割size大小的图片,若图片原始的宽和高小于size的宽，高则使用原图片的宽或高
 *  @param size，需要切割的大小
 */
- (UIImage *)clipImageFromOriginToNewSize:(CGSize)size {
    float x = 0;
    float y = 0;
    
    float w = size.width;
    float h = size.height;
    
    if(self.size.width < w) {
        w = self.size.width;
    }
    
    if(self.size.height < h) {
        h = self.size.height;
    }
    
    CGRect rect = CGRectMake(x, y, w, h);
    
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [[UIImage alloc] initWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    return newImage;
}


//改变图片大小（重绘）
- (UIImage *)resizeImageTo:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    // UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


//根据设置的最大宽度和最大高度等比例缩小图片
- (UIImage *)zoomOutImageInMaxWidth:(float)w_max MaxHeight:(float)h_max {
    float scale = 1.0;
    float w = self.size.width;
    float h = self.size.height;
    
    UIImage *newImg = self;
    
    if(w > w_max && h > h_max) {
        //x,y都要缩放
        float x_scale = w_max/w;
        float y_scale = h_max/h;
        scale = (x_scale < y_scale) ? x_scale : y_scale;
        
        //缩放图片
        newImg = [self resizeImageTo:CGSizeMake(w*scale, h*scale)];
        
    }else if(w > w_max) {
        //只有宽缩放
        //缩放图片
        newImg = [self resizeImageTo:CGSizeMake(w_max, h*(w_max/w))];
    }else if(h > h_max) {
        //只有高缩放
        newImg = [self resizeImageTo:CGSizeMake(w*(h_max/h), h_max)];
    }
    
    return newImg;
}

/*
 放大图片，将图片的宽高，至少有一边放大到目的值(等比例缩放)
 */
- (UIImage *)zoomInImageBaseOn:(float)w_min DestHeight:(float)h_min {
    UIImage *retImg = self;
    
    float w_img = self.size.width;
    float h_img = self.size.height;
    
    float w_scale = w_min/w_img;
    float h_scale = h_min/h_img;
    
    if(w_scale > 1 && h_scale >1) {
        //图片的宽高都比目的宽高大
        if(w_scale >= h_scale) {
            retImg = [self resizeImageTo:CGSizeMake(w_img*w_scale, h_img*w_scale)];
        }
        else {
            retImg = [self resizeImageTo:CGSizeMake(w_img*h_scale, h_img*h_scale)];
        }
        
    }
    else if(w_scale > 1) {
        //图片的宽比目的宽大
        retImg = [self resizeImageTo:CGSizeMake(w_img*w_scale, h_img*w_scale)];
    }
    else if(h_scale > 1) {
        //图片的高比目的高大
        retImg = [self resizeImageTo:CGSizeMake(w_img*h_scale, h_img*h_scale)];
    }
    return retImg;
}

/**
 *  TODO:获取高斯模糊图片
 *
 *  @param oldImage
 *  @param radius
 *  @param iterations
 *  @param tintColor
 */
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor {
    UIImage *oldImage = self;
    //image must be nonzero size
    if (floorf(oldImage.size.width) * floorf(oldImage.size.height) <= 0.0f) return oldImage;
    
    //boxsize must be an odd integer
    uint32_t boxSize = radius * oldImage.scale;
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = oldImage.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    CFIndex bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc(vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                         NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++) {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f) {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:oldImage.scale orientation:oldImage.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}


/**
 *  TODO:颜色生成图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  生成渐变背景色
 *  @param startColor   起始颜色
 *  @param endColor     终止颜色
 *  @param imageSize    生成的图片大小
 *  @param direction    渐变方向
 */
+ (UIImage *)gradientImage:(UIColor *)startColor endColor:(UIColor *)endColor imageSize:(CGSize)imageSize direction:(HYImageDirection)direction {
    
    //创建CGContextRef
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    //创建CGMutablePathRef
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddRect(path, NULL, CGRectMake(0, 0, imageSize.width, imageSize.height));
    
    //绘制渐变
    [self drawLinearGradient:gc path:path startColor:startColor.CGColor endColor:endColor.CGColor direction:direction];
    
    //注意释放CGMutablePathRef
    CGPathRelease(path);
    
    
    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (void)drawLinearGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
                 direction:(HYImageDirection)direction {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGRect pathRect = CGPathGetBoundingBox(path);
    
    
    //具体方向可根据需求修改
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    switch (direction) {
        case HYImageDirectionLeftToRight: {
            //左->右
            startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
            endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
            break;
        }
        case HYImageDirectionTopToBottom: {
            //上->下
            startPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMinY(pathRect));
            endPoint = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
            break;
        }
        case HYImageDirectionLeftTopToRightBottom: {
            //左上->右下
            startPoint = CGPointMake(0, CGRectGetMinY(pathRect));
            endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMaxY(pathRect));
            break;
        }
        case HYImageDirectionLeftBottomToRightTop: {
            //左下->右上
            startPoint = CGPointMake(0, CGRectGetMaxY(pathRect));
            endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect));
            break;
        }
    }
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

//获取视频的第一帧
+ (UIImage*)getVideoPreViewImage:(NSURL *)videoPath {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(1, 30);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}


/// 截取屏幕图片 (适配tableView或者scrollView)
+ (UIImage *)screenshotImageFromView:(UIView *)view {
    if ([view isKindOfClass:[UIScrollView class]]) {
        // 长截图 类型可以是 tableView或者scrollView 等可以滚动的视图 根据需要自己改
        UIScrollView *scrollView = (UIScrollView *)view;
        
        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度。
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, [UIScreen mainScreen].scale);
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
        UIGraphicsEndImageContext();
        
        return screenshotImage;
        
    }else {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [view.layer renderInContext:context];
        UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return screenshotImage;
    }
}

@end
