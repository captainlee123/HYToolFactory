//
//  PhotoDisplayViewController.m
//  MEIKU
//
//  Created by 李诚 on 15/4/17.
//  Copyright (c) 2015年 Mrrck. All rights reserved.
//

#import "HYPhotoDisplayViewController.h"
#import "HYPhotoDisplayCollectionCell.h"
#import "HYBaseUIHeader.h"

@interface HYPhotoDisplayViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView          *collectionView;

@property (nonatomic, strong) UILabel                   *pageLab;


@end

@implementation HYPhotoDisplayViewController

- (void)loadView {
    [super loadView];
    [self configHeaderBar];
}

- (void)configHeaderBar {
    [self showBackButton:YES];
    
    [self.headerBar centerBtnSetTitle:@"选择图片" forState:0];
    
    [self.headerBar rightBtnSetTitle:@"选择" forState:0];
    [self.headerBar rightBtnAddTarget:self selector:@selector(clickCompletion)];
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
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickCompletion {
    
    if ([self.delegate respondsToSelector:@selector(photoDisplayViewController:didDidSelectIndex:photo:)]) {
        [self.delegate photoDisplayViewController:self didDidSelectIndex:self.selectIndex photo:self.photos[self.selectIndex]];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-64)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumLineSpacing:0];
    [flowLayout setMinimumInteritemSpacing:0];
    
    //CGRectMake(0, CGRectGetMaxY(self.headerBar.frame), self.view.bounds.size.width, self.view.bounds.size.height-CGRectGetMaxY(self.headerBar.frame))
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerBar.frame), HY_SCREEN_WIDTH, self.view.bounds.size.height-CGRectGetMaxY(self.headerBar.frame)) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.exclusiveTouch = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[HYPhotoDisplayCollectionCell class] forCellWithReuseIdentifier:@"PhotoDisplayCollectionCell"];
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:self.collectionView];
    
    //页码
    NSString *page = [NSString stringWithFormat:@"%ld/%ld", (long)(self.selectIndex+1), (long)self.photos.count];
    self.pageLab = [[HYLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30) text:page Color:[UIColor whiteColor] font:HY_DEFAULT_FONT(14) alignment:NSTextAlignmentCenter];
    self.navigationItem.titleView = self.pageLab;
    if (self.photos.count <= 1) {
        self.pageLab.hidden = YES;
    }else {
        self.pageLab.hidden = NO;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0] atScrollPosition:0 animated:NO];
}

#pragma mark ================== UICollectionViewDataSource,UICollectionViewDelegate =================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYPhotoDisplayCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoDisplayCollectionCell" forIndexPath:indexPath];
    HYPhotoAssets *photo = [self.photos objectAtIndex:indexPath.item];
    if (photo.bigImage) {
        [cell configCellWithData:photo.bigImage];
    }else {
        [cell configCellWithData:[UIImage imageWithCGImage:photo.asset.defaultRepresentation.fullScreenImage]];
    }
    
    return cell;
}


#pragma mark ================== UIScrollViewDelegate =================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.selectIndex = page;
    NSString *pageTitle = [NSString stringWithFormat:@"%ld/%ld", (long)(self.selectIndex+1), (long)self.photos.count];
    self.pageLab.text = pageTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deletePhoto {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoDisplayViewController:didDeletePhoto:)]) {
        [self.delegate photoDisplayViewController:self didDeletePhoto:[self.photos objectAtIndex:self.selectIndex]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
