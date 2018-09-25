//
//  HYBaseUIHeader.h
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/21.
//  Copyright © 2018年 李诚. All rights reserved.
//

#ifndef HYBaseUIHeader_h
#define HYBaseUIHeader_h

#pragma mark ===================== App 信息 =====================
#define HY_SCREEN_WIDTH                    MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define HY_SCREEN_HEIGHT                   MAX([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define HY_APP_RECT                        CGRectMake(0,0,HY_SCREEN_WIDTH,HY_SCREEN_HEIGHT)

//竖屏下iPhone X上下刘海
#define HY_iPhoneXTopLex                   24.f
#define HY_iPhoneXBotLex                   34.f

#pragma mark ===================== 颜色、字体相关 =====================
//默认字体//Droid Sans Fallback
#define HY_DEFAULT_FONT(s)           [UIFont systemFontOfSize:s]
//默认粗体
#define HY_DEFAULT_BOLD_FONT(s)      [UIFont boldSystemFontOfSize:s]
//默认数字字体
#define HY_DIGITAL_FONT(s)           [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:@"BebasNeueBold" size:s] size:s]

//默认颜色
#define HY_RGB(r,g,b)                [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define HY_RGBA(r,g,b,a)             [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

//app header颜色
#define HY_HEADER_COLOR              [UIColor whiteColor]
//默认背景色
#define HY_DEFAULT_BG_COLOR          HY_RGBA(245, 245, 245, 1.0)
//默认文字颜色
#define HY_DEFAULT_TEXT_COLOR        HY_RGBA(51, 51, 51, 1.0)
#define HY_LIGTH_TEXT_COLOR          HY_RGBA(101, 101, 101, 1.0)

#define HY_LINE_COLOR                HY_RGB(238, 238, 238)

#define HY_COVER_COLOR               [UIColor colorWithWhite:0 alpha:0.6]

//主题绿
#define HY_GREEN_COLOR               HY_RGB(63, 197, 183)
//主题橙色
#define HY_ORANGE_COLOR              HY_RGB(255, 123, 2)
//主题蓝
#define HY_BLUE_COLOR                HY_RGB(0, 180, 220)
//主题红
#define HY_RED_COLOR                 HY_RGB(255, 39, 39)

#define WEAKSELF                        __weak typeof(self) weakSelf = self;

#define Max_Photo_Num 9  //最大相册数

//定义通用的block
typedef void(^commonBlock)(id arg);
typedef void(^noParamsBlock)(void);

#define MAS_SHORTHAND_GLOBALS


#import "HYBaseNavigationController.h"
#import "HYBaseViewController.h"

#import "HYBaseUITool.h"
#import "HYLabel.h"
#import "HYToolKit.h"


#endif /* HYBaseUIHeader_h */
