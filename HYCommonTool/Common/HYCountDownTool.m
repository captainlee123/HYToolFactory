//
//  HYCountDownTool.m
//  LookUp
//
//  Created by 杨泽 on 2017/6/7.
//  Copyright © 2017年 李诚. All rights reserved.
//

#import "HYCountDownTool.h"

@interface HYCountDownTool ()

@property (nonatomic, strong) NSTimer           *timer;

@property (nonatomic, assign) NSInteger         count;

@end

static HYCountDownTool *_countDownTool = nil;


@implementation HYCountDownTool

- (void)dealloc {
    [self removeTimer];
}

+ (HYCountDownTool *)sharedInstance {
    @synchronized(self) {
        if (!_countDownTool) {
            _countDownTool = [[self alloc] init];
        }
    }
    return _countDownTool;
}

+ (void)freeInstance {
    [_countDownTool removeTimer];
    _countDownTool = nil;
}


- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

// 开始倒计时
- (void)beginCountDown:(NSTimeInterval)count {
    [self removeTimer];
    self.count = count;
    [self initTimer];
}

// 添加计时器
- (void)initTimer {
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
}

// 正在倒计时
- (void)timerAction {
    if (self.count == 0) {
        [self removeTimer];
        if (self.didEndCountDown) {
            self.didEndCountDown();
        }
    }else {
        if (self.didCountDown) {
            self.didCountDown(self.count);
        }
    }
    self.count --;
}

// 结束倒计时
- (void)removeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


@end
