//
//  NSTimer+Addition.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-24.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "NSTimer+HYAddition.h"

@implementation NSTimer (HYAddition)

/*
 *  暂停定时器 (立即)
 */
-(void)pauseTimer {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


/*
 *  恢复定时器 (立即)
 */
-(void)resumeTimer {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

/*
 *  恢复定时器
 *  interval  延迟时间
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval {
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
