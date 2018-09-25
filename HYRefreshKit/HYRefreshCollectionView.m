//
//  RefreshCollectionView.m
//  HYToolFactory
//
//  Created by ihooyah on 14-12-11.
//  Copyright (c) 2014年 ihooyah. All rights reserved.
//

#import "HYRefreshCollectionView.h"

@interface HYRefreshCollectionView ()<EGORefreshTableDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) NSString  *dataRecord;

@end


@implementation HYRefreshCollectionView

@dynamic delegate;
- (id<UICollectionViewDelegate>)delegate {
    id curDelegate = [super delegate];
    return curDelegate;
}

- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    [super setDelegate:delegate];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        // Initialization code
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc{
    self.delegate = nil;
    [self removeObserver:self forKeyPath:@"contentSize"];
}

#pragma mark ------------------------------------  init  -------------------------------------------------

/**
 TODO:初始化RefreshControl
 
 @author ihooyah
 @since 1.0
 */
- (void)initHeaderView{
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height,self.frame.size.width, self.bounds.size.height)];
    self.refreshHeaderView.delegate = self;
    
    [self addSubview:self.refreshHeaderView];
    
    [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)removeHeaderView{
    [self.refreshHeaderView removeFromSuperview];
    self.refreshHeaderView = nil;
}

/**
 TODO:设置刷新的footer
 
 @author ihooyah
 @since 1.0
 */
- (void)setFooterView{
    CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
    if (self.refreshFooterView && [self.refreshFooterView superview]) {
        self.refreshFooterView.frame = CGRectMake(0.0f, height, self.frame.size.width, self.bounds.size.height);
    }else {
        self.refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.frame.size.width, self.bounds.size.height)];
        self.refreshFooterView.delegate = self;
        self.refreshFooterView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.refreshFooterView];
    }
    
    [self.refreshFooterView refreshLastUpdatedDate];
}

/**
 TODO:重置footer的位置
 
 @author ihooyah
 @since 1.0
 */
- (void)resetFooterFrame{
    CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
    self.refreshFooterView.frame = CGRectMake(0.0f, height, self.frame.size.width, self.bounds.size.height);
}

#pragma mark ------------------------------------  KVO  -------------------------------------------------

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    id new = [change objectForKey:@"new"];
    NSString *size = [NSString stringWithFormat:@"%@",new];
    if ([keyPath isEqualToString:@"contentSize"] && ![self.dataRecord isEqualToString:size] && _refreshFooterView){
        self.dataRecord = size;
        [self resetFooterFrame];
    }
}

#pragma mark ------------------------------------  Public Methods  -------------------------------------------------

/**
 TODO:设置是否使用上拉刷新和下拉刷新
 
 @param useHeader 是否使用下拉刷新
 @param useFooter 是否使用上拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)configHeaderUsing:(BOOL)useHeader footer:(BOOL)useFooter{
    [self.refreshHeaderView removeFromSuperview];
    self.refreshHeaderView = nil;
    
    [self.refreshFooterView removeFromSuperview];
    self.refreshFooterView = nil;
    
    if (useHeader){
        [self initHeaderView];
    }
    if (useFooter){
        [self setFooterView];
    }
}

/**
 TODO:设置是否使用上拉刷新
 
 @param useFooter 是否使用上拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)configFooterUsing:(BOOL)useFooter{
    [self.refreshFooterView removeFromSuperview];
    self.refreshFooterView = nil;
    if (useFooter){
        [self setFooterView];
    }
}

/**
 TODO:完成刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)finishReloadingData{
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    }
    
    if (self.contentOffset.y > 0) {
        //上啦刷新结束后，将scrollView向上移动60，使其能看到新加载出来的数据
        [self setContentOffset:CGPointMake(0, self.contentOffset.y+60)];
    }
}

/**
 TODO:禁止刷新操作
 
 @author ihooyah
 @since 1.0
 */
- (void)forbidRefreshOperation{
    _forbidRefresh = YES;
    [_refreshHeaderView removeFromSuperview];
    [_refreshFooterView removeFromSuperview];
}

/**
 TODO:允许刷新操作
 
 @author ihooyah
 @since 1.0
 */
- (void)allowRefreshOperation{
    _forbidRefresh = NO;
    [self addSubview:_refreshFooterView];
    [self addSubview:_refreshHeaderView];
}

/**
 TODO:主动下拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)showRefreshHeader{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    self.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
    // scroll the table view to the top region
    [self scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    [UIView commitAnimations];
    
    [self.refreshHeaderView setState:EGOOPullRefreshLoading];
    [self beginToReloadData:EGORefreshHeader];
}

- (void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        //下拉刷新
        if (self.delegate && [self.delegate respondsToSelector:@selector(beginLoadData_PullDown:)]) {
            [self.delegate beginLoadData_PullDown:self];
        }
    }else if(aRefreshPos == EGORefreshFooter){
        if (self.delegate && [self.delegate respondsToSelector:@selector(beginLoadData_PullUp:)]) {
            //上拉刷新
            [self.delegate beginLoadData_PullUp:self];
        }
    }
}

#pragma mark ------------------------------------  EGORefreshTableDelegate  -------------------------------------------------

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view{
    return _reloading;
}

- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view{
    return [NSDate date];
}


@end
