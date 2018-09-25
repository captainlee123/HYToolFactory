//
//  HYBaserUITool.m
//  HYToolFactory
//
//  Created by 李诚 on 2018/9/21.
//  Copyright © 2018年 李诚. All rights reserved.
//

#import "HYBaseUITool.h"

@implementation HYBaseUITool

+ (UIImage *)hy_imageNamed:(NSString *)name {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HYBaseUI" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    if (bundle && name){
        //打包成静态库读取方式
        NSString *imagePath = [[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Images/%@.png", name]];
        
        return [UIImage imageWithContentsOfFile:imagePath];
    }
    return nil;
}

@end
