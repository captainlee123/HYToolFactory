//
//  HYRun_BaseTopBar.h
//  Edu_Patriarch
//
//  Created by tom on 13-10-21.
//  Copyright (c) 2013年 imohoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYBaseTopBar : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *centerItemBtn;

@property (nonatomic, strong) UIButton     *leftItemBtn;

@property (nonatomic, strong) UIButton     *rightSecondBtn;


@property (nonatomic, strong) UIButton      *rightItemBtn;

- (void)leftBtnSetTitle:(NSString *)title forState:(UIControlState)state;
- (void)leftBtnSetImage:(UIImage *)image forState:(UIControlState)state;
- (void)leftBtnAddTarget:(id)target selector:(SEL)selector;

- (void)rightSecondBtnSetTitle:(NSString *)title forState:(UIControlState)state;
- (void)rightSecondBtnSetImage:(UIImage *)image forState:(UIControlState)state;
- (void)rightSecondBtnAddTarget:(id)target selector:(SEL)selector;

- (void)centerBtnSetTitle:(NSString *)title forState:(UIControlState)state;
- (void)centerBtnSetImage:(UIImage *)image forState:(UIControlState)state;
- (void)centerBtnAddTarget:(id)target selector:(SEL)selector;

- (void)rightBtnSetTitle:(NSString *)title forState:(UIControlState)state;
- (void)rightBtnSetImage:(UIImage *)image forState:(UIControlState)state;
- (void)rightBtnAddTarget:(id)target selector:(SEL)selector;


/**
 TODO:修改Title的颜色
 
 @param color
 
 @author tom
 @since 1.0
 */
- (void)changeTitleColor:(UIColor *)color;

@end
