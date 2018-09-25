//
//  PhotoDisplayCollectionCell.m
//  MEIKU
//
//  Created by 李诚 on 15/4/17.
//  Copyright (c) 2015年 Mrrck. All rights reserved.
//

#import "HYPhotoDisplayCollectionCell.h"

@interface HYPhotoDisplayCollectionCell () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView                  *scrollView;
@property (nonatomic, strong) UIImageView                   *imgView;
@end

@implementation HYPhotoDisplayCollectionCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}

- (void)initView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = 2.0;
    self.scrollView.minimumZoomScale = 0.5;
    self.scrollView.zoomScale = 1.0;
    [self.contentView addSubview:self.scrollView];
    
    self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imgView.backgroundColor = [UIColor clearColor];
    self.imgView.center = self.scrollView.center;
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imgView];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
}

/**
 *  @author 李诚, 15-04-17 14:04:28
 *
 *  TODO:配置cell
 *
 *  @param image
 */
- (void)configCellWithData:(UIImage *)image {
    self.scrollView.zoomScale = 1.0;
    
    self.imgView.image = image;
}

#pragma mark ============= UIScrollViewDelegate =============
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    //居中
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?(scrollView.bounds.size.width - scrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height)/2 : 0.0;
    self.imgView.center = CGPointMake(scrollView.contentSize.width/2 + offsetX,scrollView.contentSize.height/2 + offsetY);
}


/**
 *  @Author licheng, 15-01-14 13:01:52
 *
 *  TODO:双击 图片放大缩小
 */
- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
    if (self.scrollView.zoomScale == 1.0){
        float newScale = self.scrollView.zoomScale * 1.5;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

@end
