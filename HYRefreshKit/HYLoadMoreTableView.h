//
//  LoadMoreTableView.h
//  LoadMore
//
//  Created by 李诚 on 15/4/20.
//  Copyright (c) 2015年 李诚. All rights reserved.
//


/*
 【init】使用方法：
 self.tableView = [[HYLoadMoreTableView alloc] initWithFrame:self.view.bounds];
 self.tableView.delegate = self;
 self.tableView.dataSource = self;
 [self.tableView configHeaderUsing:YES];
 
 【required】需要实现回调方法：
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView tableViewDisScroll:self.tableView];
    
    if (self.tableView.refreshHeaderView) {
        [self.tableView.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.tableView.refreshHeaderView) {
        [self.tableView.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}
 */
 

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@class HYLoadMoreTableView;

@protocol HYLoadMoreTableViewDelegate <UITableViewDelegate>

@optional
/**
 *  @author 李诚, 15-04-20 14:04:00
 *
 *  TODO:下拉刷新
 *
 *  @param tableView
 */
- (void)loadMoreTableViewBeganPull_down:(HYLoadMoreTableView *)tableView;

/**
 *  @author 李诚, 15-04-20 14:04:00
 *
 *  TODO:上拉刷新
 *
 *  @param tableView
 */
- (void)loadMoreTableViewBeganPull_up:(HYLoadMoreTableView *)tableView;

@end


/**
 *  @author 李诚, 15-04-20 15:04:58
 *
 *  点击加载更多样式
 */
@interface HYLoadMoreTableView : UITableView

@property (nonatomic, weak) id<HYLoadMoreTableViewDelegate> delegate;

@property (nonatomic, strong) EGORefreshTableHeaderView     *refreshHeaderView;

@property (nonatomic, assign) BOOL                  canLoadMore;
//@"正在搜索附近位置"
@property (nonatomic, strong) NSString              *desString;

@property (nonatomic, assign, readonly) BOOL        isLoading;


/**
 *  @author 李诚, 15-04-20 14:04:47
 *
 *  TODO:完成刷新
 */
- (void)finishLoadData;


- (void)tableViewDisScroll:(UITableView *)tableView;

/**
 *  @author 李诚, 15-04-28 14:04:13
 *
 *  TODO:设置是否使用下拉刷新
 *
 *  @param useHeader
 */
- (void)configHeaderUsing:(BOOL)useHeader;

/**
 *  @author 李诚, 15-04-28 15:04:55
 *
 *  TODO:主动加载
 */
- (void)showRefreshHeader;

/**
 *  @author 李诚, 15-06-10 16:06:59
 *
 *  TODO:禁用下拉刷新
 */
- (void)forbidPull_down;

/**
 *  @author 李诚, 15-06-10 16:06:59
 *
 *  TODO:回复使用下拉刷新
 */
- (void)restorePull_down;

@end
