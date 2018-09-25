//
//  HYLabel.m
//  QAService
//
//  Created by captain on 15/9/6.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import "HYLabel.h"

@implementation HYLabel

- (id)initWithFrame:(CGRect)frame text:(NSString *)text Color:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = textColor;
        self.textAlignment = textAlignment;
        self.font = font;
        self.text = text;
    }
    return self;
}

@end
