//
//  CATextLayer+NumberJump.m
//  BZNumberJumpDemo
//
//  Created by Bruce on 14-7-1.
//  Copyright (c) 2014年 com.Bruce.Number. All rights reserved.
//

#import "HYJumpTextLayer.h"

#define kPointsNumber 100 // 即数字跳100次
#define kDurationTime 5.0 // 动画时间

@interface HYJumpTextLayer()

@property (nonatomic, assign) NSInteger     pointsNumber;
@property (nonatomic, assign) CGFloat       durationTime;
@property (nonatomic, assign) CGFloat       startNumber;
@property (nonatomic, assign) CGFloat       endNumber;


@property (nonatomic, retain) NSMutableArray *numberPoints;//记录每次textLayer更改值的间隔时间及输出值。
@property (nonatomic, assign) CGFloat lastTime;
@property (nonatomic, assign) NSInteger indexNumber;

@property (nonatomic, assign) Point2D startPoint;
@property (nonatomic, assign) Point2D controlPoint1;
@property (nonatomic, assign) Point2D controlPoint2;
@property (nonatomic, assign) Point2D endPoint;

@end

@implementation HYJumpTextLayer

- (void)cleanUpValue {
    _lastTime = 0;
    _indexNumber = 0;
    self.string = @"";
}

- (void)jumpNumberWithDuration:(NSInteger)duration
                    fromNumber:(CGFloat)startNumber
                      toNumber:(CGFloat)endNumber {
    if (startNumber== endNumber) {
        [self configString:endNumber];
        return;
    }
    
    
    _durationTime = duration;
    _startNumber = startNumber;
    _endNumber = endNumber;
    
    [self cleanUpValue];
    [self initPoints];
    [self changeNumberBySelector];
}


- (void)initPoints {
    // 贝塞尔曲线
    [self initBezierPoints];
    Point2D bezierCurvePoints[4] = {_startPoint, _controlPoint1, _controlPoint2, _endPoint};
    _numberPoints = [[NSMutableArray alloc] init];
    CGFloat dt;
    dt = 1.0 / (kPointsNumber - 1);
    for (NSInteger i = 0; i < kPointsNumber; i++) {
        Point2D point = PointOnCubicBezier(bezierCurvePoints, i*dt);
        CGFloat durationTime = point.x * _durationTime;
        CGFloat value = point.y * (_endNumber - _startNumber) + _startNumber;
        [_numberPoints addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:durationTime], [NSNumber numberWithFloat:value], nil]];
    }
}

- (void)initBezierPoints {
    // 可到http://cubic-bezier.com自定义贝塞尔曲线
    
    _startPoint.x = 0;
    _startPoint.y = 0;
    
    _controlPoint1.x = 0.25;
    _controlPoint1.y = 0.1;
    
    _controlPoint2.x = 0.25;
    _controlPoint2.y = 1;
    
    _endPoint.x = 1;
    _endPoint.y = 1;
}

- (void)changeNumberBySelector {
    if (_indexNumber >= kPointsNumber) {
        [self configString:_endNumber];
        return;
    } else {
        NSArray *pointValues = [_numberPoints objectAtIndex:_indexNumber];
        _indexNumber++;
        
        
        
        CGFloat value = [(NSNumber *)[pointValues objectAtIndex:1] floatValue];// 有时要改成floatValue
        CGFloat currentTime = [(NSNumber *)[pointValues objectAtIndex:0] floatValue];
        CGFloat timeDuration = currentTime - _lastTime;
        _lastTime = currentTime;
        [self configString:value];
        [self performSelector:@selector(changeNumberBySelector) withObject:nil afterDelay:timeDuration];
    }
}

- (void)configString:(CGFloat)value {
    NSAssert(self.jumpDelegate != nil, @"请实现customJumpString:方法");
    self.string = [self.jumpDelegate jumpTextLayer:self customJumpString:value];
}

@end
