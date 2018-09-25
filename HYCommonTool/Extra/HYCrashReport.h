//
//  HYCrashReport.h
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/17.
//  Copyright © 2018年 李诚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCrashReport : NSObject


/**
 ** 使用方法：
    1、初始化initReport
    2、获取所有crash文件提交 getAllCrashFiles：
    3、清空已提交crash文件  clearAllCrashFiles：
 */


void hy_uncaughtExceptionHandler(NSException *exception);

//初始日志
+ (void)initReport;
//获取所有奔溃日志文件
+ (NSArray *)getAllCrashFiles;
//清空所有日志文件
+ (void)clearAllCrashFiles;
//获取奔溃日志目录;
+ (NSString *)getCrashFolder;

@end
