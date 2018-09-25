//
//  TestViewController.m
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/20.
//  Copyright © 2018年 李诚. All rights reserved.
//

#import "TestViewController.h"


#import "HYLoadMoreTableView.h"

@interface TestViewController () <HYLoadMoreTableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) HYLoadMoreTableView *tableView;

@end

@implementation TestViewController

- (void)loadView {
    [super loadView];
    
    [self showBackButton:YES];
    
    [self.headerBar centerBtnSetTitle:@"二级" forState:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[HYLoadMoreTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerBar.frame), self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.headerBar.frame))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.tableView configHeaderUsing:YES];
    [self.view addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.tableView setTableFooterView:footerView];
}


#pragma mark ======= HYRefreshTableViewDelegate

#pragma mark ======= UITableViewDataSource
-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中");
}


/**
 TODO:触发操作-->下拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)loadMoreTableViewBeganPull_down:(HYLoadMoreTableView *)tableView {
    NSLog(@"下拉刷新");
    [self showLoading:@"加载..."];
    [self performSelector:@selector(finish) withObject:nil afterDelay:2.0];
}

- (void)finish {
    [self.tableView finishLoadData];
//    [self.tableView reloadData];
    
    [self showSuccess:@"成功"];
}

/**
 TODO:触发操作-->上拉刷新
 
 @author ihooyah
 @since 1.0
 */
- (void)beginLoadData_PullUp:(UIScrollView *)scrollView {
    
}


#pragma mark ============ UIScrollViewDelegate ===================
/**
 *  @author 李诚, 15-04-28 14:04:34
 *
 *  TODO:下拉刷新回传数值
 */
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
