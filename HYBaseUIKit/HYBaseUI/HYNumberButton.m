//
//  NumberButton.m
//  Fun
//
//  Created by captain on 16/2/26.
//  Copyright © 2016年 李诚. All rights reserved.
//

#import "HYNumberButton.h"
#import "HYBaseUIHeader.h"

@interface HYNumberButton ()

@property (nonatomic, strong) UIButton  *numberBtn;

@end

@implementation HYNumberButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
    self.numberBtn = [[UIButton alloc] initWithFrame:CGRectMake(center.x+5, center.y-15, 15, 15)];
    self.numberBtn.userInteractionEnabled = NO;
    [self.numberBtn setBackgroundImage:[HYBaseUITool hy_imageNamed:@"red_dot"] forState:0];
    self.numberBtn.hidden = YES;
    [self.numberBtn setTitleColor:[UIColor whiteColor] forState:0];
    self.numberBtn.titleLabel.font = HY_DEFAULT_FONT(8);
    [self.numberBtn setTitleEdgeInsets:UIEdgeInsetsMake(-3, -2, 0, 0)];
    [self addSubview:self.numberBtn];
}

- (void)setNumber:(NSInteger)number {
    if (number > 0) {
        self.numberBtn.hidden = NO;
        [self.numberBtn setTitle:[NSString stringWithFormat:@"%ld", (long)number] forState:0];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.numberBtn.transform = CGAffineTransformScale(self.numberBtn.transform, 1.2, 1.2);
        } completion:nil];
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.numberBtn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
        
    }else {
        self.numberBtn.hidden = YES;
    }
}

@end
