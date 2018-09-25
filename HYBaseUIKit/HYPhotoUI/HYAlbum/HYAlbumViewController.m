//
//  AlbumViewController.m
//  WeiKePad
//
//  Created by lee on 15-1-29.
//  Copyright (c) 2015年 WeiKeGroup. All rights reserved.
//

#import "HYAlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "HYBaseUIHeader.h"
#import "HYPhotoKit.h"

@interface HYAlbumViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView                *headerView;
@property (nonatomic, strong) UITableView           *tableView;

@property (nonatomic, strong) ALAssetsLibrary       *assetsLibrary;
@property (nonatomic, strong) NSMutableArray        *assetsGroup;
@end

@implementation HYAlbumViewController

- (id) init {
    self = [super init];
    if (self) {
        self.title = @"相册";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self configHeaderBar];
}

- (void)configHeaderBar {
    [self.headerBar leftBtnSetTitle:@"取消" forState:0];
    [self.headerBar leftBtnAddTarget:self selector:@selector(leftAction)];
    
    [self.headerBar centerBtnSetTitle:@"相册" forState:0];
}

#pragma mark ===================== 按钮 ========================
/**
 *  @Author 有点坑, 15-07-25 08:07:30
 *
 *  TODO:导航条左边按钮
 *
 *  @since 1.0
 */
- (void)leftAction {
    if (self.isPresent) {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    [self initView];
}

- (void)initData {
    [self loadAssetsGroups];
}

- (void)initView {
    [self initTableView];
}

- (void)initTableView {
    CGFloat originY = CGRectGetMaxY(self.headerBar.frame);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, originY, self.view.bounds.size.width, self.view.bounds.size.height-originY)];
    self.tableView.exclusiveTouch = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = HY_RGBA(231, 237, 240, 1.0f);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = view;
    [self.view addSubview:self.tableView];
}


#pragma mark ================= UITableViewDataSource,UITableViewDelegate =================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetsGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    ALAssetsGroup *group = [self.assetsGroup objectAtIndex:indexPath.row];
    PHOTO_PROCESS_TYPE type = [HYPhotoKit shareInstance].photoType;
    NSInteger allowCount = [HYPhotoKit shareInstance].allowMaxPhotoNum;
    if (type == PHOTO_PROCESS_TYPE_SINGLE_SELECT) {
        [group setAssetsFilter:[ALAssetsFilter allAssets]];
    }else if (type == PHOTO_PROCESS_TYPE_SELECT) {
        if (allowCount == Max_Photo_Num) {
            [group setAssetsFilter:[ALAssetsFilter allAssets]];
        }else {
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        }
    }
    else {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    }
    NSUInteger numberOfAssets = group.numberOfAssets;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)",[group valueForProperty:ALAssetsGroupPropertyName],(int)numberOfAssets];
    [cell.imageView setImage:[UIImage imageWithCGImage:[group posterImage]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self goToNativeViewControllerWithData:[self.assetsGroup objectAtIndex:indexPath.row] animation:YES];
}

/**
 *  @Author licheng, 15-01-22 09:01:30
 *
 *  TODO:获取本地相册
 */
- (void)loadAssetsGroups{
    PHAuthorizationStatus photo_status = [PHPhotoLibrary authorizationStatus];
    if (photo_status == PHAuthorizationStatusAuthorized || photo_status == PHAuthorizationStatusNotDetermined) {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        self.assetsGroup = [[NSMutableArray alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (group) {
                    if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                        [self.assetsGroup insertObject:group atIndex:0];
                    }else if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] > ALAssetsGroupSavedPhotos){
                        [self.assetsGroup insertObject:group atIndex:1];
                    }else{
                        [self.assetsGroup addObject:group];
                    }
                }else {
                    //直接进入next viewcontroller
                    [self goToNativeViewControllerWithData:[self.assetsGroup objectAtIndex:0] animation:NO];
                    //reload
                    [self.tableView reloadData];
                }
            } failureBlock:^(NSError *error) {
                NSLog(@"Group not found!n");
            }];
        });
    }else {
        NSString *message = @"没有相册访问权限，请前往“设置”->“隐私”允许访问";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)goToNativeViewControllerWithData:(ALAssetsGroup *)group animation:(BOOL)animated {
    HYNativeAlbumViewController *nativeViewController = [[HYNativeAlbumViewController alloc] init];
    nativeViewController.delegate = self.delegate;
    nativeViewController.group = group;
    nativeViewController.editDelegate = self.editDelegate;
    nativeViewController.clipDelegate = self.clipDelegate;
    [self.navigationController pushViewController:nativeViewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}

@end
