//
//  BaseViewController.h
//  BookStore
//
//  Created by 李诚 on 15/8/14.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYProgressHUD.h"
#import "HYBaseTopBar.h"

@interface HYBaseViewController : UIViewController

@property (nonatomic, assign) NSInteger         requestTag;
@property (nonatomic, assign) NSInteger         aRequestTag;

@property (nonatomic, strong) HYBaseTopBar        *headerBar;

@property (nonatomic, strong) HYProgressHUD     *hud;

- (void)backPopAction;
- (void)backDismissAction;
- (void)backRootAction;

- (void)showLoading:(NSString *)text;
- (void)showError:(NSString *)error;
- (void)showSuccess:(NSString *)success;
- (void)showText:(NSString *)text;

- (void)loadHeaderBar;


/**
 *  TODO:获取返回按钮
 */
- (void)showBackButton:(BOOL)isPop;

@end
