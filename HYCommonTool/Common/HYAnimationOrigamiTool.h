//
//  AniTool.h
//  testOrigaml
//
//  Created by tom on 13-12-3.
//  Copyright (c) 2013年 tom. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UIView+Origami.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

enum {
	XYOrigamiDirectionFromRight     = 0,
	XYOrigamiDirectionFromLeft      = 1,
    XYOrigamiDirectionFromTop       = 2,
    XYOrigamiDirectionFromBottom    = 3,
};
typedef NSUInteger XYOrigamiDirection;

typedef double (^KeyframeParametricBlock)(double);


@interface CAKeyframeAnimation (Parametric)

+ (id)animationWithKeyPath:(NSString *)path
                  function:(KeyframeParametricBlock)block
                 fromValue:(double)fromValue
                   toValue:(double)toValue;

@end

@interface HYAnimationOrigamiTool : NSObject


+(void)showOrigamiTransitionWith:(UIView *)view1
                           view2:(UIView *)view2
                    NumberOfFolds:(NSInteger)folds
                         Duration:(CGFloat)duration
                        Direction:(XYOrigamiDirection)direction
                       completion:(void (^)(BOOL finished))completion;


+(void)hideOrigamiTransitionWith:(UIView *)view1
                           view2:(UIView *)view2
                    NumberOfFolds:(NSInteger)folds
                         Duration:(CGFloat)duration
                        Direction:(XYOrigamiDirection)direction
                       completion:(void (^)(BOOL finished))completion;

@end
