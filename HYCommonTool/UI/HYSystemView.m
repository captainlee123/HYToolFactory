//
//  HYSystemView.m
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/17.
//  Copyright © 2018年 李诚. All rights reserved.
//

#import "HYSystemView.h"

@implementation HYSystemView

/// 展示系统弹框
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message fromVC:(UIViewController *)fromVC cancelTitle:(NSString *)cancelTitle otherActions:(NSArray *)otherActions completion:(void (^ __nullable)(NSInteger index))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion(0);
        }
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:actionCancel];
    
    for (NSInteger i = 0; i < otherActions.count; i++) {
        NSString *action = otherActions[i];
        UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:action style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (completion) {
                completion(i+1);
            }
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionConfirm];
    }
    
    
    [fromVC presentViewController:alert animated:YES completion:nil];
}

@end
