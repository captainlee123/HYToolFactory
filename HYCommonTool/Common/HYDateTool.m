//
//  URDateTool.m
//  Steward
//
//  Created by ihooyah on 13-5-4.
//  Copyright (c) 2013年 ihooyah. All rights reserved.
//

#import "HYDateTool.h"

@implementation HYDateTool

//函数作用 :date根据formatter转换成string
+(NSString*)dateToString:(NSString *)formatter date:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return[dateFormatter stringFromDate:date];
}

//函数作用 :date根据formatter转换成string
+(NSString*)dateToString:(NSString *)formatter sece:(NSInteger)sece
{
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:sece];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return[dateFormatter stringFromDate:date];
}

//函数作用 :将日期字符串转换成date
+(NSDate *)stringToDate:(NSString *)formatter dateString:(NSString *)dateString{
	NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatter];
	return [dateFormatter dateFromString:dateString];
}

//函数作用 :将日期字符串转换成时间戳
+(NSTimeInterval)stringToTimeInterval:(NSString *)formatter dateString:(NSString *)dateString{
	NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:formatter];
	NSDate *date=[dateFormatter dateFromString:dateString];
    return [date timeIntervalSince1970];
}

//类似微信消息的时间
+ (NSString *)messageTimeWithTimestamp:(long long)timestamp {
    NSInteger totalTimestamp = [[NSDate date] timeIntervalSince1970];
    timestamp = timestamp/1000;
    //当前共有多少天
    NSInteger currentTotalDays = totalTimestamp/86400 + 1;
    //传入时间共有多少天
    NSInteger serverTotalDays = timestamp/86400 + 1;
    
    NSDate *startD = [NSDate dateWithTimeIntervalSince1970:timestamp];
    /*
     * 显示规则
     *  今天，显示”上午HH:mm、下午HH:mm“
        昨天，显示“昨天HH:mm”
        7天内显示“星期-、二、三”
        其余显示“yyyy-MM-dd”
     */
    NSInteger diff = currentTotalDays - serverTotalDays;
    if (diff == 0) {
        //今天
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.AMSymbol = @"上午";
        format.PMSymbol = @"下午";
        format.dateFormat = @"aaahh:mm";
        
        NSString *timeStr = [format stringFromDate:startD];
        return timeStr;
    }else if (diff == 1) {
        return @"昨天";
    }else if (diff < 7) {
        return [HYDateTool weekdayStringFromTimestamp:timestamp];
    }else {
        return [HYDateTool dateToString:@"yyyy/MM/dd" sece:timestamp];
    }
}

//类似微信朋友圈的标准化时间
+ (NSString *)timeLineWithServerTime:(NSString *)serverTime format:(NSString *)format {

    NSInteger timestamp = [HYDateTool stringToTimeInterval:@"yyyy-MM-dd HH:mm:ss" dateString:serverTime];
    
    NSInteger currentInterval = (NSInteger)[[NSDate date] timeIntervalSince1970];
    NSInteger interval = currentInterval - timestamp;
    
    NSString *standardTime = @"";
    if (interval<1*60){
        standardTime = @"刚刚";
    }else if (interval<60*60){
        standardTime = [NSString stringWithFormat:@"%d分钟前",(int)interval/60];
    }else if (interval<24*60*60){
        standardTime = [NSString stringWithFormat:@"%d小时前",(int)interval/(60*60)];
    }else if(interval<3*24*60*60){
        standardTime = [NSString stringWithFormat:@"%d天前",(int)interval/(24*60*60)];
    }else {
        standardTime = [HYDateTool dateToString:format sece:timestamp];
    }
    return standardTime;
}

+ (NSString *)timeZoneName {
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    return timeZone.name;
}


//函数作用 :date根据formatter转换成string
+ (NSString*)dateToString:(NSString *)formatter date:(NSDate *)date timeZone:(NSString *)timeZone
{
    if (timeZone.length == 0) {
        timeZone = [self timeZoneName];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    [dateFormatter setDateFormat:formatter];
    return[dateFormatter stringFromDate:date];
}

//函数作用 :将日期字符串转换成时间戳
+(NSTimeInterval)stringToTimeInterval:(NSString *)formatter dateString:(NSString *)dateString timeZone:(NSString *)timeZone {
    
    if (timeZone.length == 0) {
        timeZone = [self timeZoneName];
    }
    
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    NSDate *date =[dateFormatter dateFromString:dateString];
    return [date timeIntervalSince1970];
}

//函数作用 :date根据formatter转换成string
+(NSString*)dateToString:(NSString *)formatter sece:(NSInteger)sece timeZone:(NSString *)timeZone
{
    if (timeZone.length == 0) {
        timeZone = [self timeZoneName];
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:sece];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    [dateFormatter setDateFormat:formatter];
    return[dateFormatter stringFromDate:date];
}

//函数作用 :将日期字符串转换成date
+(NSDate *)stringToDate:(NSString *)formatter dateString:(NSString *)dateString timeZone:(NSString *)timeZone{
    if (timeZone.length == 0) {
        timeZone = [self timeZoneName];
    }
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter dateFromString:dateString];
}


//服务器时间2017-10-20 15:32:22 转 自定义如2017-10-20
+ (NSString *)serverDateString:(NSString *)dateString toBirthdayWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *serverDate = [formatter dateFromString:dateString];
    
    [formatter setDateFormat:format];
    return [formatter stringFromDate:serverDate];
}



/*
 *  判断星期X
 *  timestamp  s级时间戳
 */
+ (NSString *)weekdayStringFromTimestamp:(NSInteger)timestamp {
    
    //    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //    [format setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *inputDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSArray *weekdays = @[[NSNull null] ,
                          @"星期日",
                          @"星期一",
                          @"星期二",
                          @"星期三",
                          @"星期四",
                          @"星期五",
                          @"星期六"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    
    NSString *weekday = [weekdays objectAtIndex:theComponents.weekday];
    
    //    [format setDateFormat:@"MM/dd"];
    //    NSString *weekDate = [format stringFromDate:inputDate];
    //
    //    NSString *string = [NSString stringWithFormat:@"%@\n%@", weekday, weekDate];
    
    return weekday;
    
}


@end
