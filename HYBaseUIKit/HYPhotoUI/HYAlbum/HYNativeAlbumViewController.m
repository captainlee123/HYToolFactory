//
//  NativeAlbumViewController.m
//  ImagePicker
//
//  Created by lee on 15-1-22.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "HYNativeAlbumViewController.h"
#import "HYAlbumCollectionCell.h"
#import "HYPhotoDisplayViewController.h"
#import "HYEditImageViewController.h"
#import "HYMoviePlayViewController.h"
#import "HYBaseUIHeader.h"
#import "HYPhotoKit.h"

@interface HYNativeAlbumViewController () <UICollectionViewDataSource,UICollectionViewDelegate,PhotoDisplayViewControllerDelegate,HYMoviePlayViewControllerDelegate>
@property (nonatomic, strong) ALAssetsLibrary       *assetsLibrary;
@property (nonatomic, strong) NSMutableArray        *assetsGroup;

@property (nonatomic, strong) NSMutableArray        *assets;

@property (nonatomic, strong) UICollectionView      *collectionView;
@property (nonatomic, strong) UIButton              *confirmBtn;

@property (nonatomic, strong) NSString              *recordSize;

@property (nonatomic, strong) NSMutableArray        *selectedImageArr;
@end

#define BOTTOM_VIEW_HEIGHT     45.0f

@implementation HYNativeAlbumViewController

- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)loadView {
    [super loadView];
    [self configHeaderBar];
}

- (void)configHeaderBar {
    [self showBackButton:YES];
    
    [self.headerBar rightBtnAddTarget:self selector:@selector(confirmAction:)];
    [self.headerBar rightBtnSetTitle:@"确定" forState:0];
    
    NSString *title = [self.group valueForProperty:ALAssetsGroupPropertyName];
    [self.headerBar centerBtnSetTitle:title forState:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initView];
    
    [self loadAssetsPhotos];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    id new = [change objectForKey:@"new"];
    NSString *size = [NSString stringWithFormat:@"%@",new];
    if ([keyPath isEqualToString:@"contentSize"] && ![self.recordSize isEqualToString:size]) {
        self.recordSize = size;
        [self scrollToBottom];
    }
}

- (void)initData {
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.assetsGroup = [NSMutableArray array];
    
    self.assets = [NSMutableArray array];
    
    self.selectedImageArr = [NSMutableArray array];
}

- (void)initView {
    [self initCollectionViewWithDeltaY:0];
}

/**
 *  @Author licheng, 15-01-22 10:01:51
 *
 *  TODO:初始化 CollectionView
 */
- (void)initCollectionViewWithDeltaY:(CGFloat)y {
    UICollectionViewFlowLayout  *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    CGFloat size = (self.view.bounds.size.width-20-30)/4.0;
    layout.itemSize = CGSizeMake(size, size);
    layout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    
    CGFloat originY = CGRectGetMaxY(self.headerBar.frame);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, originY, self.view.frame.size.width, self.view.bounds.size.height-originY-y) collectionViewLayout:layout];
    self.collectionView.exclusiveTouch = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[HYAlbumCollectionCell class] forCellWithReuseIdentifier:@"AlbumCollectionCell"];
    [self.view addSubview:_collectionView];
    
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 *  @author 李诚, 15-04-16 10:04:16
 *
 *  TODO:初始化 - 确认按钮
 */
- (void)initConfirmBtn {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-BOTTOM_VIEW_HEIGHT, self.view.bounds.size.width, BOTTOM_VIEW_HEIGHT)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [self.view addSubview:view];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.];
    [view addSubview:line];
    
    self.confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(view.bounds.size.width-80, (BOTTOM_VIEW_HEIGHT-38)/2.0, 70, 38)];
    [self.confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    self.confirmBtn.enabled = NO;
    self.confirmBtn.layer.cornerRadius = 3.0f;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.confirmBtn setBackgroundImage:[UIImage createImageWithColor:HY_HEADER_COLOR] forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = HY_DEFAULT_BOLD_FONT(16.0);
    [view addSubview:self.confirmBtn];
}

#pragma mark ==============  UICollectionViewDataSource,UICollectionViewDelegate ====================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HYAlbumCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCollectionCell" forIndexPath:indexPath];
    HYPhotoAssets *photo = [self.assets objectAtIndex:indexPath.item];
    PHOTO_PROCESS_TYPE type = [HYPhotoKit shareInstance].photoType;
    switch (type) {
        case PHOTO_PROCESS_TYPE_SELECT:
        case PHOTO_PROCESS_TYPE_SINGLE_SELECT: {
            //选择图片
            cell.indexPath = indexPath;
            BOOL isSelect = [self.selectedImageArr containsObject:photo];
            [cell configCellWithData:photo isSelect:isSelect];
//            [cell canSelectVideo:(self.selectedImageArr.count == 0)];
            
            __weak HYNativeAlbumViewController *weakSelf = self;
            [cell setTapArrow:^(NSIndexPath *indexPath, HYPhotoAssets *asset) {
                [weakSelf invokeTapArrowBlockWithIndexPath:indexPath data:asset];
            }];
        }
            break;
        case PHOTO_PROCESS_TYPE_EDIT:
        case PHOTO_PROCESS_TYPE_CLIP: {
            //编辑图片 or 裁剪图片
            [cell configCellWithData:photo];
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PHOTO_PROCESS_TYPE type = [HYPhotoKit shareInstance].photoType;
    switch (type) {
        case PHOTO_PROCESS_TYPE_SELECT: {
            HYPhotoDisplayViewController *displayViewController = [[HYPhotoDisplayViewController alloc] init];
            displayViewController.selectIndex = indexPath.item;
            displayViewController.photos = self.assets;
            displayViewController.delegate = self;
            [self.navigationController pushViewController:displayViewController animated:YES];
            break;
        }
            
        case PHOTO_PROCESS_TYPE_EDIT:{
            HYPhotoAssets *photo = [self.assets objectAtIndex:indexPath.item];
            HYEditImageViewController *editViewController = [[HYEditImageViewController alloc] init];
            editViewController.editImage = [UIImage imageWithCGImage:photo.asset.defaultRepresentation.fullScreenImage];
            editViewController.delegate = self.editDelegate;
            [self.navigationController pushViewController:editViewController animated:YES];
        }
            break;
        case PHOTO_PROCESS_TYPE_CLIP:{
            HYPhotoAssets *photo = [self.assets objectAtIndex:indexPath.item];
            ClipImageViewController *clipVC = [[ClipImageViewController alloc] init];
            clipVC.clipImage = [UIImage imageWithCGImage:photo.asset.defaultRepresentation.fullScreenImage];
            clipVC.delegate = self.clipDelegate;
            [self.navigationController pushViewController:clipVC animated:YES];
        }
            break;
        case PHOTO_PROCESS_TYPE_SINGLE_SELECT:{
            HYPhotoAssets *photo = [self.assets objectAtIndex:indexPath.item];
            if (photo.type == IMAGE_TYPE_VIDEO) {
                HYMoviePlayViewController *viewController = [[HYMoviePlayViewController alloc] init];
                viewController.photoAsset = photo;
                viewController.delegate = self;
                [self.navigationController pushViewController:viewController animated:YES];
            }else {
                HYPhotoDisplayViewController *displayViewController = [[HYPhotoDisplayViewController alloc] init];
                displayViewController.selectIndex = indexPath.item;
                displayViewController.photos = self.assets;
                displayViewController.delegate = self;
                [self.navigationController pushViewController:displayViewController animated:YES];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)photoDisplayViewController:(HYPhotoDisplayViewController *)vc didDidSelectIndex:(NSInteger)index photo:(HYPhotoAssets *)photo{

    [self invokeTapArrowBlockWithIndexPath:[NSIndexPath indexPathForItem:index inSection:0] data:photo];
    [vc backPopAction];

}

#pragma mark ======= Private

- (void)loadAssetsPhotos{
    PHOTO_PROCESS_TYPE type = [HYPhotoKit shareInstance].photoType;
    NSInteger allowCount = [HYPhotoKit shareInstance].allowMaxPhotoNum;
    if (self.group) {
        [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result) {
                HYPhotoAssets *photoAssets = [[HYPhotoAssets alloc] init];
                //缩略图
                
                __weak typeof(self) weakself = self;
                
                photoAssets.asset = result;
                
                if ([result valueForProperty:ALAssetPropertyType] == ALAssetTypePhoto) {
                    //照片
                    photoAssets.type = IMAGE_TYPE_PHOTO;
                    [self.assets addObject:photoAssets];
                    
                }else if ([result valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
                    //视频
                    photoAssets.type = IMAGE_TYPE_VIDEO;
                    if (type == PHOTO_PROCESS_TYPE_SINGLE_SELECT) {
                        [self.assets addObject:photoAssets];
                    }
                }
                
            }else {
                [self.collectionView reloadData];
            }
        }];
    }else {
        
    }
}

/// 滚动到底部
- (void)scrollToBottom {
    CGFloat offsetY = MAX(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height);
    [self.collectionView setContentOffset:CGPointMake(0, offsetY)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ========== 选择操作
/**
 *  @author 李诚, 15-04-16 10:04:46
 *
 *  TODO:确认选择照片
 */
- (void)confirmAction:(UIButton *)sender {
    [self showLoading:@"图片处理..."];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //取出大图
        for (HYPhotoAssets *photo in self.selectedImageArr) {
            HYPhotoAssets *handledPhoto = [[HYPhotoAssets alloc] init];
            //压缩缩略图
            UIImage *aspectRatioThumbnail = [UIImage imageWithCGImage:photo.asset.aspectRatioThumbnail];
            handledPhoto.thumbnail = [aspectRatioThumbnail zoomOutImageInMaxWidth:150 MaxHeight:150];
            handledPhoto.type = photo.type;
            //压缩大图
            UIImage *compressionImage = [UIImage imageWithCGImage:photo.asset.defaultRepresentation.fullScreenImage];
            handledPhoto.bigImage = [compressionImage zoomOutImageInMaxWidth:HY_SCREEN_WIDTH MaxHeight:HY_SCREEN_HEIGHT];
            [arr addObject:handledPhoto];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hide:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(nativeAlbumViewController:didSelectImages:)]) {
                [self.delegate nativeAlbumViewController:self didSelectImages:arr];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (void)invokeTapArrowBlockWithIndexPath:(NSIndexPath *)indexPath data:(HYPhotoAssets *)asset {
    if ([self.selectedImageArr containsObject:asset]) {
        [self.selectedImageArr removeObject:asset];
    }else {
        NSInteger allowCount = [HYPhotoKit shareInstance].allowMaxPhotoNum;
        if ([self.selectedImageArr count] >= allowCount) {
            NSString *msg = [NSString stringWithFormat:@"本次最多选择%ld张照片", allowCount];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [self.selectedImageArr addObject:asset];
    }
    
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    //重置确认按钮的状态
    self.confirmBtn.enabled = (self.selectedImageArr.count>0) ? YES : NO;
}

@end
