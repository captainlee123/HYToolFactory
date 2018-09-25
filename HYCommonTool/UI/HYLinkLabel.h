//
//  LeeLinkLabel.h
//  XXLinkLabelDemo
//
//  Created by captain on 2017/12/7.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYLinkLabel : UILabel


@property (nonatomic, strong) void  (^selectLinkAtIndex)(NSInteger index);

@property (nonatomic, strong) UIColor   *linkTextColor;

- (void)setText:(NSString *)text linkRanges:(NSArray *)linkRanges;

@end
