//
//  TabbarItem.m
//  QAService
//
//  Created by captain on 15/11/26.
//  Copyright © 2015年 李诚. All rights reserved.
//

#import "HYTabbarItem.h"
#import "HYBaseUIHeader.h"

@interface HYTabbarItem ()

@property (nonatomic, strong) NSString  *title;

@property (nonatomic, strong) UIImage   *normalImage;

@property (nonatomic, strong) UIImage   *selectImage;
//图标存放button
@property (nonatomic, strong) UIButton  *iconBtn;
//标题
@property (nonatomic, strong) UILabel   *titleLab;
//点击button
@property (nonatomic, strong) UIButton  *clickBtn;
//红点
@property (nonatomic, strong) UIView    *redDot;

@end

@implementation HYTabbarItem

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title normalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.normalImage = normalImage;
        self.selectImage = selectImage;
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.iconBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width-25)/2.0, 7.5, 25, 25)];
    [self.iconBtn setImage:self.normalImage forState:UIControlStateNormal];
    [self.iconBtn setImage:self.selectImage forState:UIControlStateSelected];
    [self addSubview:self.iconBtn];
    
    self.titleLab = [[HYLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.iconBtn.frame), self.bounds.size.width, 17.5) text:self.title Color:HY_DEFAULT_TEXT_COLOR font:HY_DEFAULT_FONT(12) alignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLab];
    
    self.redDot = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconBtn.frame) - 7, 5, 10, 10)];
    self.redDot.backgroundColor = [UIColor redColor];
    self.redDot.layer.borderColor = [UIColor whiteColor].CGColor;
    self.redDot.layer.borderWidth = 2.f;
    self.redDot.layer.cornerRadius = self.redDot.bounds.size.width/2.0;
    self.redDot.layer.masksToBounds = YES;
    self.redDot.hidden = YES;
    [self addSubview:self.redDot];
    
    self.clickBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self.clickBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.clickBtn];
}

- (void)clickAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbarItemDidSelected:)]) {
        [self.delegate tabbarItemDidSelected:self];
    }
}

#pragma mark -
- (void)selectItem {
    [self.iconBtn setSelected:YES];
    self.titleLab.textColor = HY_HEADER_COLOR;
}

- (void)deselectItem {
    [self.iconBtn setSelected:NO];
    self.titleLab.textColor = HY_RGBA(119, 119, 119, 1.0);
}

- (void)shouldShowDot:(BOOL)shouldShow {
    self.redDot.hidden = !shouldShow;
}

@end
