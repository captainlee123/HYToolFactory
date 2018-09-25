//
//  HYDateTool.h
//  Steward
//
//  Created by ihooyah on 13-5-4.
//  Copyright (c) 2013年 ihooyah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYDateTool : NSObject

//函数作用 :date根据formatter转换成string
+(NSString*)dateToString:(NSString *)formatter date:(NSDate *)date;

//函数作用 :date根据formatter转换成string
+(NSString*)dateToString:(NSString *)formatter sece:(NSInteger)sece;

//函数作用 :将日期字符串转换成date
+(NSDate *)stringToDate:(NSString *)formatter dateString:(NSString *)dateString;

//函数作用 :将日期字符串转换成时间戳
+(NSTimeInterval)stringToTimeInterval:(NSString *)formatter dateString:(NSString *)dateString;

//类似微信消息的时间
+ (NSString *)messageTimeWithTimestamp:(long long)timestamp;
//类似微信朋友圈的标准化时间
+ (NSString *)timeLineWithServerTime:(NSString *)serverTime format:(NSString *)format;

// 系统所在时区
+ (NSString *)timeZoneName;

//函数作用 :date根据formatter转换成string
+ (NSString*)dateToString:(NSString *)formatter date:(NSDate *)date timeZone:(NSString *)timeZone;

//函数作用 :将日期字符串转换成时间戳
+(NSTimeInterval)stringToTimeInterval:(NSString *)formatter dateString:(NSString *)dateString timeZone:(NSString *)timeZone;

//函数作用 :date根据formatter转换成string
+(NSString*)dateToString:(NSString *)formatter sece:(NSInteger)sece timeZone:(NSString *)timeZone;

//函数作用 :将日期字符串转换成date
+(NSDate *)stringToDate:(NSString *)formatter dateString:(NSString *)dateString timeZone:(NSString *)timeZone;


//服务器时间2017-10-20 15:32:22 转 自定义如2017-10-20
+ (NSString *)serverDateString:(NSString *)dateString toBirthdayWithFormat:(NSString *)format;


@end
