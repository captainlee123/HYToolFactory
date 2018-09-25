//
//  HYCountDownTool.h
//  LookUp
//
//  Created by 杨泽 on 2017/6/7.
//  Copyright © 2017年 李诚. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCountDownTool : NSObject

+ (HYCountDownTool *)sharedInstance;

+ (void)freeInstance;
// 倒计时
@property (nonatomic, copy) void(^didCountDown)(NSInteger time);
// 倒计时结束
@property (nonatomic, copy) void(^didEndCountDown)(void);
// 开始倒计时
- (void)beginCountDown:(NSTimeInterval)count;

@end
