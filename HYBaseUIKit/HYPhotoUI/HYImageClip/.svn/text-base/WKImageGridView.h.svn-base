//
//  WKImageGridView.h
//  WeiKePad
//
//  Created by xuchenyang on 14-11-12.
//  Copyright (c) 2014年 WeiKeGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKImageGridView : UIView

//相对于self.imgView
//当前的裁剪区域
@property (assign, nonatomic) CGRect        clipRect;
//最大的裁剪区域
@property (assign, nonatomic) CGRect        maxClipRect;

/**
 *  @author 有点坑, 15-09-19 12:09:41
 *
 *  TODO:调整最大裁剪区域
 *
 *  @param rect
 *
 *  @since 1.0
 */
- (void)adjustMaxClipRect:(CGRect)rect;

/**
 *  @author 有点坑, 15-09-21 16:09:04
 *
 *  TODO:调整裁剪区域
 *
 *  @param isRotation
 *
 *  @since 1.0
 */
- (void)adjustClipRect;

@end
