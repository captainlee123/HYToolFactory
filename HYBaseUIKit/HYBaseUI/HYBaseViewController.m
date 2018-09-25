//
//  BaseViewController.m
//  BookStore
//
//  Created by 李诚 on 15/8/14.
//  Copyright (c) 2015年 李诚. All rights reserved.
//

#import "HYBaseViewController.h"
#import "HYBaseUIHeader.h"

@interface HYBaseViewController ()

@property (nonatomic, assign) BOOL  isVisible; //当前页面是否可见

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_semaphore_t sema;

@end

@implementation HYBaseViewController

- (void)dealloc {
//    [[HttpDataLogic shareInstance] cancelRequestWithTag:self.requestTag];
//    [[HttpDataLogic shareInstance] cancelRequestWithTag:self.aRequestTag];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc from :%@", NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:HY_APP_RECT];
    view.backgroundColor = HY_RGBA(245, 245, 245, 1.0);
    self.view = view;

    [self loadHeaderBar];
}

- (void)loadHeaderBar{
    self.headerBar = [[HYBaseTopBar alloc] init];
    
    self.headerBar.backgroundColor = HY_HEADER_COLOR;
    [self.headerBar changeTitleColor:HY_RGBA(8, 14, 31, 1.0)];
    [self.view addSubview:self.headerBar];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerBar.bounds.size.height-1, self.headerBar.bounds.size.width, 1)];
    line.backgroundColor = HY_RGB(238, 238, 238);
    [self.headerBar addSubview:line];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initProgressView];
    
    self.automaticallyAdjustsScrollViewInsets = NO; //automaticallyAdjustsScrollViewInsets，当设置为YES时（默认YES），如果视图里面存在唯一一个UIScrollView或其子类View，那么它会自动设置相应的内边距，这样可以让scroll占据整个视图，又不会让导航栏遮盖，
    self.extendedLayoutIncludesOpaqueBars = NO; //这个属性指定了当Bar使用了不透明图片时，视图是否延伸至Bar所在区域，默认值时NO。
    //所以我们如果自定义了导航栏的背景图片，那么视图会从导航栏以下开始，/。
    self.edgesForExtendedLayout = UIRectEdgeNone; //edgesForExtendedLayout是一个类型为UIExtendedEdge的属性，指定边缘要延伸的方
    
    [self configUserInteraction];
}


- (void)configUserInteraction {
    if (@available(iOS 11.0, *)) {
        //解决 reloadData“乱跑”的问题
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
}

/**
 *  @author 有点坑, 15-08-21 13:08:05
 *
 *  TODO:初始化- loading view
 *
 *  @since 1.0
 */
- (void)initProgressView {
    if (!self.hud) {
        self.hud = [[HYProgressHUD alloc] initWithView:self.view];
        //返回按钮一直可点
        self.hud.touchableAreas = @[NSStringFromCGRect(self.headerBar.leftItemBtn.frame)];
        [self.view addSubview:self.hud];
    }
}

- (void)showLoading:(NSString *)text {
    [self.hud show:YES];
    [self.hud setMode:HY_MBProgressHUDModeIndeterminate];
    [self.hud setDetailsLabelText:text];
}

- (void)showError:(NSString *)error {
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:1.0];
    [self.hud setMode:HY_MBProgressHUDModeCustomViewWarning];
    [self.hud setDetailsLabelText:error];
}

- (void)showSuccess:(NSString *)success {
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:1.5];
    [self.hud setMode:HY_MBProgressHUDModeCustomViewSuccess];
    [self.hud setDetailsLabelText:success];
}

- (void)showText:(NSString *)text {
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:1.0];
    [self.hud setMode:HY_MBProgressHUDModeText];
    [self.hud setDetailsLabelText:text];
}

- (void)backPopAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backDismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backRootAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  TODO:获取返回按钮
 */
- (void)showBackButton:(BOOL)isPop {
    [self.headerBar leftBtnSetImage:[HYBaseUITool hy_imageNamed:@"hy_return_btn"] forState:0];
    if (isPop) {
        [self.headerBar leftBtnAddTarget:self selector:@selector(backPopAction)];
    }else {
        [self.headerBar leftBtnAddTarget:self selector:@selector(backDismissAction)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


#pragma mark ================= touches ==================
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
