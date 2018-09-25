//
//  WKImageGridView.m
//  WeiKePad
//
//  Created by xuchenyang on 14-11-12.
//  Copyright (c) 2014年 WeiKeGroup. All rights reserved.
//

#import "WKImageGridView.h"

#define VALID_TOUCH_SPACE       30
//最小裁剪大小CGSizeMake(100, 100)
#define RECT_MIN_WIDTH          100
//裁剪的左右边界
#define GRID_EDGE_LENGTH        20
//裁剪的上边界
#define GRID_EDGE_TOP           70
//裁剪的下边界
#define GRID_EDGE_BOT           50


//裁剪角落大小
#define GRID_CORNER_RADUIS      5


//颜色RGBA
#define RGBA(r,g,b,a)                     [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface WKImageGridView ()

//当前的触摸点
@property (assign, nonatomic) CGPoint       touchPoint;

@end

@implementation WKImageGridView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.multipleTouchEnabled = NO;
        self.clipsToBounds = NO;
        self.maxClipRect = self.bounds;
        self.clipRect = CGRectMake(10, 20, self.bounds.size.width-20, self.bounds.size.height-40);
        //放大缩小手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinchGesture];
    }
    return self;
}

/**
 TODO:休整剪切区域
 
 @param x1 左侧x偏移量
 @param x2 右侧x偏移量
 @param y1 上边y偏移量
 @param y2 下边y偏移量
 
 @author 徐晨阳
 @since 1.0
 */
- (void)clipRectEdge:(CGFloat)x1 x2:(CGFloat)x2 y1:(CGFloat)y1 y2:(CGFloat)y2{
    _clipRect.origin.x += x1;
    _clipRect.size.width -= x1;
    _clipRect.origin.y += y1;
    _clipRect.size.height -= y1;
    _clipRect.size.width += x2;
    _clipRect.size.height += y2;
    
//    NSLog(@"***************%@", NSStringFromCGRect(self.clipRect));
//    NSLog(@"***************%@", NSStringFromCGRect(self.maxClipRect));
    
    //裁剪区域左右边界限制
    if (CGRectGetMinX(self.clipRect) < CGRectGetMinX(self.maxClipRect)) {
        if (x1 < 0){
            _clipRect.origin.x -= x1;
            _clipRect.size.width += x1;
        }else{
            _clipRect.origin.x = CGRectGetMinX(self.maxClipRect);
        }
    }else if(CGRectGetMaxX(self.clipRect) > CGRectGetMaxX(self.maxClipRect)){
        if (x2 > 0){
            _clipRect.size.width -= x2;
        }else {
            _clipRect.origin.x = CGRectGetMaxX(self.maxClipRect) - CGRectGetWidth(self.clipRect);
        }
    }
    //裁剪区域上下边界限制
    if (CGRectGetMinY(self.clipRect) < CGRectGetMinY(self.maxClipRect)) {
        if (y1 < 0){
            _clipRect.origin.y -= y1;
            _clipRect.size.height += y1;
        }else {
            _clipRect.origin.y = CGRectGetMinY(self.maxClipRect);
        }
    }else if(CGRectGetMaxY(self.clipRect) > CGRectGetMaxY(self.maxClipRect)){
        if (y2 > 0){
            _clipRect.size.height -= y2;
        }else {
            _clipRect.origin.y = CGRectGetMaxY(self.maxClipRect) - CGRectGetHeight(self.clipRect);
        }
    }
    //限制裁剪区域最小宽度
    if (CGRectGetWidth(self.clipRect) < RECT_MIN_WIDTH) {
        if (x1 > 0.0f) {
            _clipRect.origin.x -= RECT_MIN_WIDTH - CGRectGetWidth(self.clipRect);
        }
        _clipRect.size.width = RECT_MIN_WIDTH;
    }
    //限制裁剪区域最小高度
    if(CGRectGetHeight(self.clipRect) < RECT_MIN_WIDTH) {
        if (y1 > 0.0f) {
            _clipRect.origin.y -= RECT_MIN_WIDTH - CGRectGetHeight(self.clipRect);
        }
        _clipRect.size.height = RECT_MIN_WIDTH;
    }
}

#pragma mark ------------------------------------  Gestures Handle  -------------------------------------------------

/**
 TODO:处理捏合手势
 
 @param gestureRecognizer  捏合手势
 
 @author 徐晨阳
 @since 1.0
 */
- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint center = CGPointMake(CGRectGetMidX(self.clipRect), CGRectGetMidY(self.clipRect));
        float width = self.clipRect.size.width * [gestureRecognizer scale];
        float height = self.clipRect.size.height * [gestureRecognizer scale];
        CGRect newRect = CGRectMake(center.x-width/2, center.y-height/2, width, height);
        //边界和最小宽高检查
        if (CGRectGetMinX(newRect) >= CGRectGetMinX(self.maxClipRect) && CGRectGetMinY(newRect) >= CGRectGetMinY(self.maxClipRect) && CGRectGetMaxX(newRect) <= CGRectGetMaxX(self.maxClipRect) && CGRectGetMaxY(newRect) <= CGRectGetMaxY(self.maxClipRect) && width >= RECT_MIN_WIDTH && height >= RECT_MIN_WIDTH){
            self.clipRect = newRect;
            [self setNeedsDisplay];
        }
        [gestureRecognizer setScale:1];
    }
}

#pragma mark ------------------------------------  Touch Events  -------------------------------------------------

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    self.touchPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"***************%@", NSStringFromCGRect(self.clipRect));
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    CGFloat x1 = 0.0f, x2 = 0.0f, y1 = 0.0f, y2 = 0.0f;
    CGFloat x = self.touchPoint.x;
    CGFloat y = self.touchPoint.y;
    
    if (fabs(x - CGRectGetMinX(self.clipRect)) < VALID_TOUCH_SPACE){ //左
        CGFloat offy = y - CGRectGetMinY(self.clipRect);
        if (fabs(offy) < VALID_TOUCH_SPACE) { //左上角
            x1 = p.x - self.touchPoint.x;
            y1 = p.y - self.touchPoint.y;
        }else if(fabs(offy - CGRectGetMaxY(self.clipRect)) < VALID_TOUCH_SPACE){ //左下角
            x1 = p.x - self.touchPoint.x;
            y2 = p.y - self.touchPoint.y;
        }else if(y > CGRectGetMinY(self.clipRect) && y < CGRectGetMinY(self.clipRect) + CGRectGetHeight(self.clipRect)) { //左中部
            x1 = p.x - self.touchPoint.x;
        }
    }else if(fabs(x - CGRectGetMinX(self.clipRect) - CGRectGetMaxX(self.clipRect)) < VALID_TOUCH_SPACE){ //右
        CGFloat offy = y - CGRectGetMinY(self.clipRect);
        if (fabs(offy) < VALID_TOUCH_SPACE) { //右上角
            x2 = p.x - self.touchPoint.x;
            y1 = p.y - self.touchPoint.y;
        }else if(fabs(offy - CGRectGetMaxY(self.clipRect)) < VALID_TOUCH_SPACE) { //右下角
            x2 = p.x - self.touchPoint.x;
            y2 = p.y - self.touchPoint.y;
        }else if(y > CGRectGetMinY(self.clipRect) && y < CGRectGetMinY(self.clipRect) + CGRectGetHeight(self.clipRect)) { //右中部
            x2 = p.x - self.touchPoint.x;
        }
    }else if(fabs(y - CGRectGetMinY(self.clipRect)) < VALID_TOUCH_SPACE){ //上
        if (x > CGRectGetMinX(self.clipRect) && x < CGRectGetMaxX(self.clipRect)) { //上中
            y1 = p.y - self.touchPoint.y;
        }
    }else if(fabs(y - CGRectGetMinY(self.clipRect) - CGRectGetHeight(self.clipRect)) < VALID_TOUCH_SPACE){ //下
        if (x > CGRectGetMinX(self.clipRect) && x < CGRectGetMaxX(self.clipRect)) { //下中
            y2 = p.y - self.touchPoint.y;
        }
    }else if((x > CGRectGetMinX(self.clipRect) && x < CGRectGetMinX(self.clipRect) + CGRectGetMaxX(self.clipRect)) && (y > CGRectGetMinY(self.clipRect) && y <CGRectGetMinY(self.clipRect) + CGRectGetMaxY(self.clipRect))){ //正中
        _clipRect.origin.x += (p.x - self.touchPoint.x);
        _clipRect.origin.y += (p.y - self.touchPoint.y);
    }else {
        return;
    }
    //修改rect
    [self clipRectEdge:x1 x2:x2 y1:y1 y2:y2];
    [self setNeedsDisplay];
    self.touchPoint = p;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.touchPoint = CGPointZero;
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}

#pragma mark ------------------------------------  Draw Rect  -------------------------------------------------

- (void)drawRect:(CGRect)rect{
//    NSLog(@"***************%@", NSStringFromCGRect(self.clipRect));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*绘制剪裁区域外半透明效果*/
    CGContextSetFillColorWithColor(context, [RGBA(0, 0, 0, 0.6) CGColor]);
    //上
    CGRect r = CGRectMake(0, 0, rect.size.width, CGRectGetMinY(self.clipRect));
    CGContextFillRect(context, r);
    //左
    r = CGRectMake(0, CGRectGetMinY(self.clipRect), CGRectGetMinX(self.clipRect), CGRectGetHeight(self.clipRect));
    CGContextFillRect(context, r);
    //右
    r = CGRectMake(CGRectGetMinX(self.clipRect) + CGRectGetWidth(self.clipRect), CGRectGetMinY(self.clipRect), rect.size.width - CGRectGetMinX(self.clipRect) - CGRectGetWidth(self.clipRect), CGRectGetHeight(self.clipRect));
    CGContextFillRect(context, r);
    //下
    r = CGRectMake(0, CGRectGetMaxY(self.clipRect), rect.size.width, rect.size.height - CGRectGetMaxY(self.clipRect));
    CGContextFillRect(context, r);

    //绘制边角
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextSetLineWidth(context, 4.0);
    CGContextMoveToPoint(context, CGRectGetMinX(self.clipRect), CGRectGetMinY(self.clipRect) + GRID_EDGE_LENGTH);
    CGContextAddLineToPoint(context, CGRectGetMinX(self.clipRect), CGRectGetMinY(self.clipRect) );
    CGContextAddLineToPoint(context, CGRectGetMinX(self.clipRect) + GRID_EDGE_LENGTH, CGRectGetMinY(self.clipRect));
    CGContextMoveToPoint(context, CGRectGetMaxX(self.clipRect) - GRID_EDGE_LENGTH, CGRectGetMinY(self.clipRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.clipRect), CGRectGetMinY(self.clipRect) );
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.clipRect), CGRectGetMinY(self.clipRect) + GRID_EDGE_LENGTH);
    CGContextMoveToPoint(context, CGRectGetMaxX(self.clipRect) - GRID_EDGE_LENGTH, CGRectGetMaxY(self.clipRect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.clipRect), CGRectGetMaxY(self.clipRect) );
    CGContextAddLineToPoint(context, CGRectGetMaxX(self.clipRect), CGRectGetMaxY(self.clipRect) - GRID_EDGE_LENGTH);
    CGContextMoveToPoint(context, CGRectGetMinX(self.clipRect), CGRectGetMaxY(self.clipRect) - GRID_EDGE_LENGTH);
    CGContextAddLineToPoint(context, CGRectGetMinX(self.clipRect), CGRectGetMaxY(self.clipRect) );
    CGContextAddLineToPoint(context, CGRectGetMinX(self.clipRect) + GRID_EDGE_LENGTH, CGRectGetMaxY(self.clipRect));
    CGContextStrokePath(context);
}

#pragma mark ================ lee add ===================
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self.superview convertRect:self.clipRect toView:[UIApplication sharedApplication].keyWindow];
    if (CGRectContainsPoint(rect, point)) {
        return self;
    }else {
        //返回nil，点击事件传递到下一层
        return nil;
    }
}


/**
 *  @author 有点坑, 15-09-19 12:09:41
 *
 *  TODO:调整最大裁剪区域
 *
 *  @param rect
 *
 *  @since 1.0
 */
- (void)adjustMaxClipRect:(CGRect)rect {
    CGFloat screen_w = [UIScreen mainScreen].bounds.size.width;
    CGFloat screen_h = [UIScreen mainScreen].bounds.size.height;
    
    CGRect maxRect = self.maxClipRect;
    //超出左界限
    if (rect.origin.x <= GRID_EDGE_LENGTH) {
        maxRect.origin.x = GRID_EDGE_LENGTH - rect.origin.x;
    }else {
        maxRect.origin.x = 0;
    }
    
    if (CGRectGetMaxX(rect) + GRID_EDGE_LENGTH >= screen_w) {
        //超出右界限
        CGFloat diff = CGRectGetMaxX(rect)-screen_w;
        maxRect.size.width = CGRectGetWidth(rect) - CGRectGetMinX(maxRect) - GRID_EDGE_LENGTH - diff;
    }else {
        maxRect.size.width = CGRectGetWidth(rect) - CGRectGetMinX(maxRect);
    }
    //超出上界限
    if (rect.origin.y <= GRID_EDGE_TOP) {
        maxRect.origin.y = GRID_EDGE_TOP - rect.origin.y;
        maxRect.size.height = CGRectGetMaxY(rect) - maxRect.origin.y;
    }else {
        maxRect.origin.y = 0;
    }
    //超出下界限
    if (CGRectGetMaxY(rect) + GRID_EDGE_BOT >= screen_h) {
        CGFloat diff = CGRectGetMaxY(rect)-screen_h;
        maxRect.size.height = CGRectGetHeight(rect) - CGRectGetMinY(maxRect) - GRID_EDGE_BOT - diff;
    }else {
        maxRect.size.height = CGRectGetHeight(rect) - CGRectGetMinY(maxRect);
    }
    
    self.maxClipRect = maxRect;
    [self setNeedsDisplay];
}

/**
 *  @author 有点坑, 15-09-21 16:09:04
 *
 *  TODO:调整裁剪区域
 *
 *  @param isRotation
 *
 *  @since 1.0
 */
- (void)adjustClipRect {
    //裁剪区域居中
    self.clipRect = CGRectMake(self.maxClipRect.origin.x+10, self.maxClipRect.origin.y+10, self.maxClipRect.size.width-20, self.maxClipRect.size.height-20);
    
    [self setNeedsDisplay];
}

@end
