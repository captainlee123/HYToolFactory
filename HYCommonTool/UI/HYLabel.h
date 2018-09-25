//
//  HYLabel.h
//  QAService
//
//  Created by captain on 15/9/6.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYLabel : UILabel

/*
 *  Label工厂
 */
- (id)initWithFrame:(CGRect)frame text:(NSString *)text Color:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment;

@end
