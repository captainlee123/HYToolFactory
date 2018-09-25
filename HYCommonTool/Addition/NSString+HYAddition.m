//
//  NSString+Addition.m
//  HYToolFactory
//
//  Created by lee on 15-1-15.
//  Copyright (c) 2015年 ihooyah. All rights reserved.
//

#import "NSString+HYAddition.h"

@implementation NSString (HYAddition)

/**
 *  TODO:得到字符串的字符数 (英文长度记1，中文记2)
 */
- (NSInteger)numberOfCharacter {
    NSUInteger len = self.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return len + numMatch;
}

/**
 *  TODO:将字符串首尾的空格去除
 */
- (NSString *)stringByTrimmingInvalidCharacter {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
