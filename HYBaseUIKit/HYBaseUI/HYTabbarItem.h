//
//  TabbarItem.h
//  QAService
//
//  Created by captain on 15/11/26.
//  Copyright © 2015年 李诚. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HYTabbarItem;

@protocol HYTabbarItemDelegate <NSObject>

@optional
/**
 *  @author 有点坑, 15-11-26 10:11:46
 *
 *  TODO:选中 tabbar item
 *
 *  @param item
 *
 *  @since 1.0
 */
- (void)tabbarItemDidSelected:(HYTabbarItem *)item;

@end

@interface HYTabbarItem : UIView

@property (nonatomic, weak) id<HYTabbarItemDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                  normalImage:(UIImage *)normalImage
                  selectImage:(UIImage *)selectImage;

- (void)selectItem;

- (void)deselectItem;

- (void)shouldShowDot:(BOOL)shouldShow;

@end
