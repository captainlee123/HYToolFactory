//
//  HYSystemView.h
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/17.
//  Copyright © 2018年 李诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HYSystemView : NSObject

/// 展示系统弹框
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message fromVC:(UIViewController *)fromVC cancelTitle:(NSString *)cancelTitle otherActions:(NSArray *)otherActions completion:(void (^ __nullable)(NSInteger index))completion;

@end
