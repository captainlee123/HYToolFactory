//
//  LoadMoreTableView.m
//  LoadMore
//
//  Created by 李诚 on 15/4/20.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import "HYLoadMoreTableView.h"

#define FOOTER_VIEW_HEIGHT          40.0f

@interface HYLoadMoreTableView () <UIScrollViewDelegate,EGORefreshTableDelegate>
@property (nonatomic, strong) UILabel                       *statusLab;

@property (nonatomic, strong) UIActivityIndicatorView       *indicatorView;

//是否禁用下拉刷新
@property (nonatomic, assign) BOOL                          isForbiddenPull_down;
@end

@implementation HYLoadMoreTableView

#pragma mark ===================== 设置方法 =========================
- (void)setCanLoadMore:(BOOL)canLoadMore {
    _canLoadMore = canLoadMore;
    if (canLoadMore) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        self.tableFooterView = footerView;
        [self showFooterView];
    }else {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        self.tableFooterView = footerView;
    }
}

- (void)setIsLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    
    if (isLoading) {
        self.statusLab.text = self.desString;
        [self adjustIndicatorViewFrame];
        [self.indicatorView startAnimating];
        self.indicatorView.hidden = NO;
    }else {
        [self.indicatorView stopAnimating];
        self.indicatorView.hidden = YES;
    }
}

/**
 *  @author 李诚, 15-04-28 14:04:13
 *
 *  TODO:设置是否使用下拉刷新
 *
 *  @param useHeader
 */
- (void)configHeaderUsing:(BOOL)useHeader {
    if (useHeader) {
        [self showHeaderView];
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
//    if (@available(iOS 11.0, *)) {
//        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    self.desString = @"正在加载...";
    self.isForbiddenPull_down = NO;
}

/**
 *  @author 李诚, 15-04-28 14:04:17
 *
 *  TODO:加载 下拉刷新header
 */
- (void)showHeaderView {
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height,self.frame.size.width, self.bounds.size.height)];
    self.refreshHeaderView.delegate = self;
    
    [self addSubview:self.refreshHeaderView];
    
    [self.refreshHeaderView refreshLastUpdatedDate];
}

/**
 *  @author 李诚, 15-04-28 14:04:17
 *
 *  TODO:加载 上拉刷新footer
 */
- (void)showFooterView {
    UIButton *footerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, FOOTER_VIEW_HEIGHT)];
    [footerView addTarget:self action:@selector(clickLoadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.statusLab = [[UILabel alloc] initWithFrame:footerView.bounds];
    self.statusLab.textColor = [UIColor darkGrayColor];
    self.statusLab.textAlignment = NSTextAlignmentCenter;
    self.statusLab.text = @"点击加载更多";
    self.statusLab.font = [UIFont systemFontOfSize:14];
    [footerView addSubview:self.statusLab];
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicatorView.frame = CGRectMake((self.bounds.size.width-160)/2.0, (FOOTER_VIEW_HEIGHT-20)/2.0, 20, 20);
    [footerView addSubview:self.indicatorView];
    self.indicatorView.hidden = YES;
    
    [self adjustIndicatorViewFrame];
    
    self.tableFooterView = footerView;
}

/**
 *  @author 李诚, 15-04-28 16:04:16
 *
 *  TODO:调整小菊花位置
 */
- (void)adjustIndicatorViewFrame {
    NSString *string = self.statusLab.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSFontAttributeName value:self.statusLab.font range:NSMakeRange(0, string.length)];
    
    CGFloat width = [attributedString boundingRectWithSize:CGSizeMake(1000, FOOTER_VIEW_HEIGHT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
    
    self.statusLab.frame = CGRectMake((self.bounds.size.width-width)/2.0, 0, width, FOOTER_VIEW_HEIGHT);
    
    self.indicatorView.frame = CGRectMake(CGRectGetMinX(self.statusLab.frame)-25, (FOOTER_VIEW_HEIGHT-20)/2.0, 20, 20);
}

- (void)tableViewDisScroll:(UITableView *)tableView {
    CGFloat offsetY = tableView.contentOffset.y;
    CGFloat height1 = tableView.bounds.size.height;
    CGFloat height2 = tableView.contentSize.height;
    if ((height1 >= height2 && offsetY > 20) || (height1 < height2 && (offsetY + height1) > (height2+20))) {
        //滑动超出最底部
        if (_canLoadMore && !_isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadMoreTableViewBeganPull_up:)]) {
            self.isLoading = YES;
            [self.delegate loadMoreTableViewBeganPull_up:self];
        }
    }
}

- (void)clickLoadMoreAction {
    if (_canLoadMore && !_isLoading && self.delegate && [self.delegate respondsToSelector:@selector(loadMoreTableViewBeganPull_up:)]) {
        self.isLoading = YES;
        [self.delegate loadMoreTableViewBeganPull_up:self];
    }
}

/**
 *  @author 李诚, 15-04-20 14:04:47
 *
 *  TODO:完成刷新
 */
- (void)finishLoadData {
    self.isLoading = NO;
    
    if (self.refreshHeaderView) {
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
}

/**
 *  @author 李诚, 15-04-28 15:04:55
 *
 *  TODO:主动加载
 */
- (void)showRefreshHeader {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    // scroll the table view to the top region
    [self scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    [UIView commitAnimations];
    
    [self.refreshHeaderView setState:EGOOPullRefreshLoading];
    [self beginToReloadData:EGORefreshHeader];
}

/**
 *  @author 李诚, 15-04-28 14:04:49
 *
 *  TODO:开始加载数据 - 下拉刷新
 *
 *  @param aRefreshPos
 */
- (void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    _isLoading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        //下拉刷新
        if (!self.isForbiddenPull_down && self.delegate && [self.delegate respondsToSelector:@selector(loadMoreTableViewBeganPull_down:)]) {
            [self.delegate loadMoreTableViewBeganPull_down:self];
        }
    }
}


/**
 *  @author 李诚, 15-06-10 16:06:59
 *
 *  TODO:禁用下拉刷新
 */
- (void)forbidPull_down {
    [self.refreshHeaderView removeFromSuperview];
    self.refreshHeaderView = nil;
    
    self.isForbiddenPull_down = YES;
}

/**
 *  @author 李诚, 15-06-10 16:06:59
 *
 *  TODO:回复使用下拉刷新
 */
- (void)restorePull_down {
    [self showHeaderView];
    
    self.isForbiddenPull_down = NO;
}

#pragma mark ------------------------------------  EGORefreshTableDelegate  -------------------------------------------------

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view{
    return _isLoading;
}

- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view{
    return [NSDate date];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark ========= Override ===========
@dynamic delegate;

- (void)setDelegate:(id<HYLoadMoreTableViewDelegate>)delegate {
    [super setDelegate:delegate];
}

- (id<HYLoadMoreTableViewDelegate>)delegate {
    id curDelegate = [super delegate];
    return curDelegate;
}

@end
