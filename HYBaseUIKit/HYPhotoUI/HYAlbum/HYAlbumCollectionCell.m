//
//  AlbumCollectionCell.m
//  MEIKU
//
//  Created by 李诚 on 15/4/16.
//  Copyright (c) 2015年 Mrrck. All rights reserved.
//

#import "HYAlbumCollectionCell.h"
#import "HYBaseUIHeader.h"

@interface HYAlbumCollectionCell ()
@property (nonatomic, strong) UIImageView           *albumImgView;
@property (nonatomic, strong) UIButton              *chooseBtn;
@property (nonatomic, strong) UIButton              *videoBtn;
@property (nonatomic, strong) UILabel               *videoLab;

@property (nonatomic, strong) UIImageView       *disableSelectView;

@property (nonatomic, strong) HYPhotoAssets           *tempAsset;
@end

@implementation HYAlbumCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.albumImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.albumImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.albumImgView.clipsToBounds = YES;
    [self addSubview:self.albumImgView];
    
    self.chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-35, 0, 35, 35)];
    [self.chooseBtn setImage:[HYBaseUITool hy_imageNamed:@"hy_album_no"] forState:UIControlStateNormal];
    [self.chooseBtn setImage:[HYBaseUITool hy_imageNamed:@"hy_album_yes"] forState:UIControlStateSelected];
    [self.chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, -8)];
    [self.chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseBtn.hidden = YES;
    [self addSubview:self.chooseBtn];
    
    self.videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, 30, 30)];
    self.videoBtn.userInteractionEnabled = NO;
    [self.videoBtn setImage:[HYBaseUITool hy_imageNamed:@"hy_video_icon"] forState:0];
    [self addSubview:self.videoBtn];
    
    self.videoLab = [[HYLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.videoBtn.frame), self.bounds.size.height-30, self.bounds.size.width-CGRectGetMaxX(self.videoBtn.frame), 30) text:@"" Color:[UIColor whiteColor] font:HY_DEFAULT_FONT(12) alignment:NSTextAlignmentLeft];
    [self addSubview:self.videoLab];
    
    self.disableSelectView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.disableSelectView.hidden = YES;
    self.disableSelectView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
    [self addSubview:self.disableSelectView];
}

- (CABasicAnimation *)scaleAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.25;
    animation.fromValue = @1.0;
    animation.toValue = @1.1;
    animation.removedOnCompletion = YES;
    return animation;
}

/**
 *  @author 李诚, 15-04-16 10:04:15
 *
 *  TODO:配置cell
 */
- (void)configCellWithData:(HYPhotoAssets *)asset isSelect:(BOOL)isSelect {
    self.tempAsset = asset;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //裁切
        UIImage *image = [UIImage imageWithCGImage:asset.asset.aspectRatioThumbnail];
        dispatch_async(dispatch_get_main_queue(), ^{
            //完成，设置到view
            [self.albumImgView setImage:image];
        });
    });
    
    self.chooseBtn.hidden = NO;
    self.chooseBtn.selected = isSelect;
    
    if (isSelect) {
        [self.chooseBtn.layer addAnimation:[self scaleAnimation] forKey:nil];
    }
    
    [self configVideoType:asset];
}

- (void)configCellWithData:(HYPhotoAssets *)asset {
    self.chooseBtn.hidden = YES;
    
//    self.albumImgView.image = asset.thumbnail;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //裁切
        UIImage *image = [UIImage imageWithCGImage:asset.asset.aspectRatioThumbnail];
        dispatch_async(dispatch_get_main_queue(), ^{
            //完成，设置到view
            [self.albumImgView setImage:image];
        });
    });
    
    [self configVideoType:asset];
}

- (void)configVideoType:(HYPhotoAssets *)asset {
    if (asset.type == IMAGE_TYPE_VIDEO) {
        self.videoBtn.hidden = NO;
        self.videoLab.hidden = NO;
        NSInteger duration = llroundf([[asset.asset valueForProperty:ALAssetPropertyDuration] integerValue]);
        if (duration == 0) {
            duration = 1;
        }
        NSInteger minutes = duration/60;
        NSInteger seconds = duration%60;
        self.videoLab.text = [NSString stringWithFormat:@"%02ld:%02ld", minutes, seconds];
    }else {
        self.videoBtn.hidden = YES;
        self.videoLab.hidden = YES;
    }
}

- (void)canSelectVideo:(BOOL)canSelect {
    if (self.tempAsset.type == IMAGE_TYPE_VIDEO) {
        self.disableSelectView.hidden = canSelect;
    }else {
        self.disableSelectView.hidden = YES;
    }
}



/**
 *  @author 李诚, 15-04-16 10:04:06
 *
 *  TODO:选择照片
 */
- (void)chooseAction:(UIButton *)sender {
    if (self.tapArrow) {
        self.tapArrow(self.indexPath, self.tempAsset);
    }
}

@end
