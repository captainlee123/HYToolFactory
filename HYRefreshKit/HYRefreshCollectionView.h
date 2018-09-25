//
//  RefreshCollectionView.h
//  HYToolFactory
//
//  Created by ihooyah on 14-12-11.
//  Copyright (c) 2014年 ihooyah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@protocol HYRefreshCollectionViewDelegate <UICollectionViewDelegate>
@optional

/**
 TODO:触发操作-->下拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)beginLoadData_PullDown:(UIScrollView *)scrollView;

/**
 TODO:触发操作-->上拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)beginLoadData_PullUp:(UIScrollView *)scrollView;

@end

@interface HYRefreshCollectionView : UICollectionView

@property (nonatomic, weak) id<HYRefreshCollectionViewDelegate> delegate;

//refreshControl
@property (nonatomic, strong) EGORefreshTableHeaderView     *refreshHeaderView;
//refreshFooter
@property (nonatomic, strong) EGORefreshTableFooterView     *refreshFooterView;
//是否正在刷新
@property (nonatomic, assign) BOOL              reloading;
//是否允许刷新操作
@property (nonatomic, assign, readonly) BOOL    forbidRefresh;

/**
 TODO:设置是否使用上拉刷新和下拉刷新
 
 @param useHeader 是否使用下拉刷新
 @param useFooter 是否使用上拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)configHeaderUsing:(BOOL)useHeader footer:(BOOL)useFooter;

/**
 TODO:设置是否使用上拉刷新
 
 @param useFooter 是否使用上拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)configFooterUsing:(BOOL)useFooter;

/**
 TODO:完成刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)finishReloadingData;

/**
 TODO:主动下拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)showRefreshHeader;

/**
 TODO:禁止刷新操作
 
 @author ihooyah
 @since 1.0
 */
- (void)forbidRefreshOperation;

/**
 TODO:允许刷新操作
 
 @author ihooyah
 @since 1.0
 */
- (void)allowRefreshOperation;

@end

