//
//  NSTimer+Addition.h
//  PagedScrollView
//
//  Created by 陈政 on 14-1-24.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (HYAddition)

/*
 *  暂停定时器 (立即)
 */
- (void)pauseTimer;

/*
 *  恢复定时器 (立即)
 */
- (void)resumeTimer;

/*
 *  恢复定时器
 *  interval  延迟时间
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
