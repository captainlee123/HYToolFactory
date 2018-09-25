//
//  TabbarView.h
//  QAService
//
//  Created by captain on 15/11/26.
//  Copyright © 2015年 李诚. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYTabbarView;

@protocol TabbarViewDelegate <NSObject>

@optional
- (void)tabbarView:(HYTabbarView *)tabbar didSelectAtIndex:(NSInteger)index;

@end

@interface HYTabbarView : UIView

@property (nonatomic, weak) id<TabbarViewDelegate>      delegate;

- (void)selectAtIndex:(NSInteger)index;

- (void)showRedDotAtIndex:(NSInteger)index;

- (void)hideRedDotAtIndex:(NSInteger)index;

@end
