//
//  UIColor+Addition.h
//  MEIKU
//
//  Created by 李诚 on 15/7/21.
//  Copyright (c) 2015年 Mrrck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HYAddition)

/**
 *  @author 李诚, 15-07-21 16:07:14
 *
 *  TODO:16进制转化为UIColor
 *
 *  @param hexValue         16进制数
 *  @param alphaValue       透明度
 */
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;


/**
 *  @author 李诚, 15-07-21 16:07:08
 *
 *  TODO:16进制转化为UIColor
 *
 *  @param stringToConvert 16进制字符串
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
