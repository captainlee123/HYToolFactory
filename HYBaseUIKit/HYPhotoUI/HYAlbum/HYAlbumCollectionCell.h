//
//  AlbumCollectionCell.h
//  MEIKU
//
//  Created by 李诚 on 15/4/16.
//  Copyright (c) 2015年 Mrrck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYPhotoAssets.h"

@interface HYAlbumCollectionCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath   *indexPath;

@property (nonatomic, strong) void          (^tapArrow)(NSIndexPath *indexPath, HYPhotoAssets *asset);

/**
 *  @author 李诚, 15-04-16 10:04:15
 *
 *  TODO:配置cell
 */
- (void)configCellWithData:(HYPhotoAssets *)asset isSelect:(BOOL)isSelect;

- (void)configCellWithData:(HYPhotoAssets *)asset;

- (void)canSelectVideo:(BOOL)canSelect;

@end
