//
//  UIColor+Addition.m
//  MEIKU
//
//  Created by 李诚 on 15/7/21.
//  Copyright (c) 2015年 Mrrck. All rights reserved.
//

#import "UIColor+HYAddition.h"

@implementation UIColor (HYAddition)

/**
 *  @author 李诚, 15-07-21 16:07:14
 *
 *  TODO:16进制转化为UIColor
 *
 *  @param hexValue     16进制数
 *  @param alphaValue
 */
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}


/**
 *  @author 李诚, 15-07-21 16:07:08
 *
 *  TODO:16进制转化为UIColor
 *
 *  @param stringToConvert 16进制字符串
 *
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return nil;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return nil;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

@end
