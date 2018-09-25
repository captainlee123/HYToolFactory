//
//  TabbarView.m
//  QAService
//
//  Created by captain on 15/11/26.
//  Copyright © 2015年 李诚. All rights reserved.
//

#import "HYTabbarView.h"
#import "HYTabbarItem.h"
#import "HYBaseUIHeader.h"

@interface HYTabbarView () <HYTabbarItemDelegate>

@property (nonatomic, strong) UIImageView   *indicatorLine;

@end

@implementation HYTabbarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, -2, HY_SCREEN_WIDTH, self.bounds.size.height)];
//    line.backgroundColor = DEFAULT_LINE_COLOR;
    line.image = [[HYBaseUITool hy_imageNamed:@"tab_shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
    [self addSubview:line];
    
    NSArray *arr = @[@{@"title":@"首页", @"normalImage":@"tab_home", @"selectImage":@"tab_home_s"},
                     @{@"title":@"发现", @"normalImage":@"tab_share", @"selectImage":@"tab_share_s"},
                     @{@"title":@"好友", @"normalImage":@"tab_contact", @"selectImage":@"tab_contact_s"},
                     @{@"title":@"更多", @"normalImage":@"tab_person", @"selectImage":@"tab_person_s"}];
    
    CGFloat itemWidth = HY_SCREEN_WIDTH/arr.count;
    CGFloat itemHeight = 50;
    for (NSInteger i = 0; i < arr.count; i++) {
        NSDictionary *dict = [arr objectAtIndex:i];
        NSString *title = [dict objectForKey:@"title"];
        UIImage *normalImage = [HYBaseUITool hy_imageNamed:[dict objectForKey:@"normalImage"]];
        UIImage *selectImage = [HYBaseUITool hy_imageNamed:[dict objectForKey:@"selectImage"]];
        HYTabbarItem *item = [[HYTabbarItem alloc] initWithFrame:CGRectMake(itemWidth*i, 0, itemWidth, itemHeight) title:title normalImage:normalImage selectImage:selectImage];
        item.delegate = self;
        item.tag = 1000+i;
        [self addSubview:item];
    }
}

#pragma mark ===================== HYRun_TabbarItemDelegate =================
/**
 *  @author 有点坑, 15-11-26 10:11:46
 *
 *  TODO:选中 tabbar item
 *
 *  @param item
 *
 *  @since 1.0
 */
- (void)tabbarItemDidSelected:(HYTabbarItem *)item {
    NSInteger index = item.tag-1000;
    [self selectAtIndex:index];
}

- (void)selectAtIndex:(NSInteger)index {
    HYTabbarItem *item = [self viewWithTag:1000+index];
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[HYTabbarItem class]]) {
            HYTabbarItem *subItem = (HYTabbarItem *)subView;
            [subItem deselectItem];
        }
    }
    [item selectItem];
    
    CGRect indicatorFrame = self.indicatorLine.frame;
    indicatorFrame.origin.x = CGRectGetMinX(item.frame)+(item.bounds.size.width-self.indicatorLine.bounds.size.width)/2.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorLine.frame = indicatorFrame;
    } completion:^(BOOL finished) {
        //
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabbarView:didSelectAtIndex:)]) {
        [self.delegate tabbarView:self didSelectAtIndex:index];
    }
}

#pragma mark -
- (void)showRedDotAtIndex:(NSInteger)index {
    HYTabbarItem *item = (HYTabbarItem *)[self viewWithTag:1000+index];
    [item shouldShowDot:YES];
}

- (void)hideRedDotAtIndex:(NSInteger)index {
    HYTabbarItem *item = (HYTabbarItem *)[self viewWithTag:1000+index];
    [item shouldShowDot:NO];
}

@end
