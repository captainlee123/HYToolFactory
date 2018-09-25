//
//  CATextLayer+NumberJump.h
//  BZNumberJumpDemo
//
//  Created by Bruce on 14-7-1.
//  Copyright (c) 2014年 com.Bruce.Number. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HYBezierCurve.h"
@class HYJumpTextLayer;

@protocol HYJumpTextLayerDelegate <NSObject>

@required
//当前类型转需要展示的类型
- (NSString *)jumpTextLayer:(HYJumpTextLayer *)jumpLayer customJumpString:(CGFloat)currentNumber;

@end

@interface HYJumpTextLayer : CATextLayer

/* 使用DEMO
    self.distanceLayer = [[HYJumpTextLayer alloc] init];
    self.distanceLayer.frame = CGRectMake(0, 10, self.bounds.size.width, 50);
    self.distanceLayer.string = @"";
    self.distanceLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.distanceLayer.foregroundColor = [UIColor whiteColor].CGColor;
    self.distanceLayer.alignmentMode = kCAAlignmentCenter;
    self.distanceLayer.contentsScale = [UIScreen mainScreen].scale;// 这句话使得字体不模糊,这是因为屏幕的分辨率问题
    UIFont *font = [UIFont systemFontOfSize:45];
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    self.distanceLayer.font = fontRef;
    self.distanceLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    [self.layer addSublayer:self.distanceLayer];
 
    //该方法实现跳跃
    [self.distanceLayer jumpNumberWithDuration:1 fromNumber:distance_from toNumber:distance_to];
 
    //实现代理，控制输出格式
    - (NSString *)jumpTextLayer:(HYJumpTextLayer *)jumpLayer customJumpString:(CGFloat)currentNumber {
    NSInteger minutes = currentNumber / 60;
    NSInteger seconds = (NSInteger)currentNumber % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
 }
 */

@property (nonatomic, weak) id<HYJumpTextLayerDelegate> jumpDelegate;

//自定义类型跳动
//使用此方法需实现delegate  如：整形；浮点型；xx′xx″
- (void)jumpNumberWithDuration:(NSInteger)duration
                    fromNumber:(CGFloat)startNumber
                      toNumber:(CGFloat)endNumber;

@end
