//
//  WKImageClipView.h
//  WeiKePad
//
//  Created by xuchenyang on 14-11-12.
//  Copyright (c) 2014年 WeiKeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WKImageClipViewDelegate <NSObject>
@optional

/**
 TODO:图片裁剪界面取消回调
 
 @author 徐晨阳
 @since 1.0
 */
- (void)WKImageClipViewDidCancelClip;

/**
 TODO:图片裁剪界面取消回调
 
 @param clippedImage 裁剪后的图片
 
 @author 徐晨阳
 @since 1.0
 */
- (void)WKImageClipViewDidConfirmClipWithImage:(UIImage *)clippedImage;

@end

@interface WKImageClipView : UIView

@property (assign, nonatomic) id<WKImageClipViewDelegate>    delegate;

/**
 TODO:创建实例
 
 @param image 图片
 @param frame 大小
 
 @return 实例对象
 
 @author 徐晨阳
 @since 1.0
 */
- (instancetype)initWithImage:(UIImage *)image frame:(CGRect)frame;

/**
 TODO:获取当前裁剪的图片
 
 @return 实例对象
 
 @author 徐晨阳
 @since 1.0
 */
- (UIImage *)getClippedImage;

@end
