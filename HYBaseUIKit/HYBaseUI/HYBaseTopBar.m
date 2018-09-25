//
//  HYRun_BaseTopBar.m
//  Edu_Patriarch
//
//  Created by tom on 13-10-21.
//  Copyright (c) 2013年 imohoo. All rights reserved.
//

#import "HYBaseTopBar.h"
#import "HYBaseUIHeader.h"
#import "HYNumberButton.h"

#define DEFAULT_BTN_COLOR   HY_DEFAULT_TEXT_COLOR
#define DEFAULT_BTN_FONT    HY_DEFAULT_FONT(14)

@interface HYBaseTopBar ()

@property (nonatomic, strong) UIView *headerView;

@end

@implementation HYBaseTopBar

- (void)dealloc
{
    self.leftItemBtn = nil;
    self.rightItemBtn = nil;
    self.centerItemBtn = nil;
    
    self.contentView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initBarHeader];
        CGFloat height = frame.size.height;
        [self initBarContent:height-44];
    }
    return self;
}

- (id)init {
    CGFloat height = 64+[HYCommonTool topReservedSpacing];
    return [self initWithFrame:CGRectMake(0, 0, HY_SCREEN_WIDTH, height)];
}

/**
 TODO:修改Title的颜色
 
 @param color
 
 @author tom
 @since 1.0
 */
- (void)changeTitleColor:(UIColor *)color{
    [self.centerItemBtn setTitleColor:color forState:UIControlStateNormal];
}

/*!
 *  TODO:初始化界面
 *
 *  @author tom
 *  @since 1.0
 */
- (void)initBarHeader{
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    [self.headerView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.headerView];
}


/*!
 *  TODO:初始化导航条的内容
 *
 *  @param y 偏移量
 *
 *  @author tom
 *  @since 1.0
 */
- (void)initBarContent:(int)y{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, y, self.bounds.size.width, 44)];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.contentView];
    
    self.centerItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.centerItemBtn setFrame:CGRectMake(44, 0, (self.frame.size.width-88), 44)];
    self.centerItemBtn.hidden = YES;
    
    [[self.centerItemBtn titleLabel] setFont:HY_DEFAULT_FONT(18.0f)];
    self.centerItemBtn.userInteractionEnabled = NO;
    [self.contentView addSubview:self.centerItemBtn];
    
    self.leftItemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.leftItemBtn.hidden = YES;
    [[self.leftItemBtn titleLabel] setFont:DEFAULT_BTN_FONT];
    self.leftItemBtn.userInteractionEnabled = NO;
    [self.leftItemBtn setTitleColor:DEFAULT_BTN_COLOR forState:UIControlStateNormal];
    [self.leftItemBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.leftItemBtn];
    
    self.rightItemBtn = [[HYNumberButton alloc] initWithFrame:CGRectMake(self.frame.size.width-44, 0, 44, 44)];
    self.rightItemBtn.hidden = YES;
    [[self.rightItemBtn titleLabel] setFont:DEFAULT_BTN_FONT];
    self.rightItemBtn.userInteractionEnabled = NO;
    self.rightItemBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.rightItemBtn setTitleColor:DEFAULT_BTN_COLOR forState:UIControlStateNormal];
    [self.rightItemBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.rightItemBtn];
    
    self.rightSecondBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-89, 0, 44, 44)];
    self.rightSecondBtn.hidden = YES;
    [[self.rightSecondBtn titleLabel] setFont:DEFAULT_BTN_FONT];
    self.rightSecondBtn.userInteractionEnabled = NO;
    self.rightSecondBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.rightSecondBtn setTitleColor:DEFAULT_BTN_COLOR forState:UIControlStateNormal];
    [self.rightSecondBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.rightSecondBtn];
}

- (void)leftBtnSetTitle:(NSString *)title forState:(UIControlState)state{
    self.leftItemBtn.hidden = NO;
    [self.leftItemBtn setTitle:title forState:state];
}
- (void)leftBtnSetImage:(UIImage *)image forState:(UIControlState)state{
    self.leftItemBtn.hidden = NO;
    [self.leftItemBtn setImage:image forState:state];
}
- (void)leftBtnAddTarget:(id)target selector:(SEL)selector{
    self.leftItemBtn.hidden = NO;
    self.leftItemBtn.userInteractionEnabled = YES;
    [self.leftItemBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

//中间按钮
- (void)centerBtnSetTitle:(NSString *)title forState:(UIControlState)state{
    self.centerItemBtn.hidden = NO;
    [self.centerItemBtn setTitle:title forState:state];
}
- (void)centerBtnSetImage:(UIImage *)image forState:(UIControlState)state{
    self.centerItemBtn.hidden = NO;
    [self.centerItemBtn setImage:image forState:state];
}
- (void)centerBtnAddTarget:(id)target selector:(SEL)selector{
    self.centerItemBtn.hidden = NO;
    self.centerItemBtn.userInteractionEnabled = YES;
    [self.centerItemBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

//最右边按钮
- (void)rightBtnSetTitle:(NSString *)title forState:(UIControlState)state{
    CGFloat width = [HYCommonTool getRectFromString:title withRestrictSize:CGSizeMake(80, 44) font:DEFAULT_BTN_FONT].size.width;
    if (width > 44) {
        self.rightItemBtn.frame = CGRectMake(self.frame.size.width-width-15, 0, width, 44);
    }else {
        self.rightItemBtn.frame = CGRectMake(self.frame.size.width-44-(15-(44-width)/2.0), 0, 44, 44);
    }
    
    
    self.rightItemBtn.hidden = NO;
    [self.rightItemBtn setTitle:title forState:state];
}

- (void)rightBtnSetImage:(UIImage *)image forState:(UIControlState)state{
    self.rightItemBtn.hidden = NO;
    [self.rightItemBtn setImage:image forState:state];
}

- (void)rightBtnAddTarget:(id)target selector:(SEL)selector{
    self.rightItemBtn.hidden = NO;
    self.rightItemBtn.userInteractionEnabled = YES;
    
    [self.rightItemBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

//右边第二个按钮
- (void)rightSecondBtnSetTitle:(NSString *)title forState:(UIControlState)state {
    CGFloat width = [HYCommonTool getRectFromString:title withRestrictSize:CGSizeMake(80, 44) font:DEFAULT_BTN_FONT].size.width;
    width = MAX(44, width);
    self.rightSecondBtn.frame = CGRectMake(CGRectGetMinX(self.rightItemBtn.frame)-width, 0, width, 44);
    self.rightSecondBtn.hidden = NO;
    [self.rightSecondBtn setTitle:title forState:state];
}
- (void)rightSecondBtnSetImage:(UIImage *)image forState:(UIControlState)state {
    self.rightSecondBtn.hidden = NO;
    [self.rightSecondBtn setImage:image forState:state];
}
- (void)rightSecondBtnAddTarget:(id)target selector:(SEL)selector {
    self.rightSecondBtn.hidden = NO;
    self.rightSecondBtn.userInteractionEnabled = YES;
    [self.rightSecondBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
