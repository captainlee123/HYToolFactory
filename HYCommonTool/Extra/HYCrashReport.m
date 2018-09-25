//
//  HYCrashReport.m
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/17.
//  Copyright © 2018年 李诚. All rights reserved.
//

#import "HYCrashReport.h"
#import "HYFileTool.h"

@implementation HYCrashReport


void hy_uncaughtExceptionHandler(NSException *exception) {
    
    NSArray *stackArry= [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception name:%@\nException reatoin:%@\nException stack :%@",name,reason,stackArry];
    
    NSLog(@"%@",exceptionInfo);
    //保存到本地沙盒中
    NSString *folder = [HYCrashReport getCrashFolder];
    NSString *filePath = [NSString stringWithFormat:@"%@/error_%ld.log", folder, (NSInteger)[[NSDate date] timeIntervalSince1970]];
    
    
    [exceptionInfo writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

//初始日志
+ (void)initReport {
    NSSetUncaughtExceptionHandler(&hy_uncaughtExceptionHandler);
}

//获取奔溃日志目录
+ (NSString *)getCrashFolder {
    NSString *folder = [HYFileTool getLocalFilePath:@"crash"];
    if (![HYFileTool isExistsFilePath:folder]) {
        [HYFileTool createDirectory:folder];
    }
    return folder;
}

//获取所有奔溃日志文件
+ (NSArray *)getAllCrashFiles {
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString *folder = [HYCrashReport getCrashFolder];
    NSArray *pathArray = [manager subpathsAtPath:folder];
    
    NSMutableArray *results = [NSMutableArray array];
    for (NSString *name in pathArray) {
        if ([name hasSuffix:@"log"]) {
            NSString *pathStr = [folder stringByAppendingPathComponent:name];
            [results addObject:pathStr];
        }
        
    }
    return results;
}

//清空所有日志文件
+ (void)clearAllCrashFiles {
    NSFileManager* manager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *folder = [HYCrashReport getCrashFolder];
    NSArray *pathArray = [manager subpathsAtPath:folder];
    
    for (NSString *name in pathArray) {
        if ([name hasSuffix:@"log"]){
            NSString *pathStr = [folder stringByAppendingPathComponent:name];
            if ([[NSFileManager defaultManager] fileExistsAtPath:pathStr]) {
                [manager removeItemAtPath :pathStr error :&error];
            }
        }
    }
}

@end
