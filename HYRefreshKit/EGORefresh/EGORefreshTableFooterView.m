//
//  EGORefreshTableFooterView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableFooterView.h"
#import <QuartzCore/QuartzCore.h>
#import "RefreshCircleView.h"

@interface EGORefreshTableFooterView ()

@property (strong, nonatomic) UILabel                      *lastUpdatedLabel;

@property (strong, nonatomic) UILabel                      *statusLabel;

@property (strong, nonatomic) CALayer                      *arrowImage;

@property (strong, nonatomic) RefreshCircleView             *circleView;

@end

@implementation EGORefreshTableFooterView

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];

		self.lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.frame.size.width, 20.0f)];
		self.lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.lastUpdatedLabel.font = [UIFont systemFontOfSize:11.0];
		self.lastUpdatedLabel.textColor = textColor;
//		self.lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		self.lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		self.lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
        self.lastUpdatedLabel.hidden = YES;
		[self addSubview:self.lastUpdatedLabel];
		
		self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 20.0f, self.frame.size.width, 30.0f)];
		self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.statusLabel.font = [UIFont systemFontOfSize:14.0];
		self.statusLabel.textColor = textColor;
//		self.statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		self.statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		self.statusLabel.backgroundColor = [UIColor clearColor];
		self.statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:self.statusLabel];
		
		self.arrowImage = [CALayer layer];
		self.arrowImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-90, 20.0f, 16.5f, 28.5f);
		self.arrowImage.contentsGravity = kCAGravityResizeAspect;
        self.arrowImage.hidden = YES;
		self.arrowImage.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			self.arrowImage.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		[self.layer addSublayer:self.arrowImage];
        NSString *str = NSLocalizedString(@"RefreshCircleView_x_short", nil);
        NSInteger shortX = [str integerValue];
		self.circleView = [[RefreshCircleView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-shortX, 20.0f, REFRESH_CIRCLE_SIZE, REFRESH_CIRCLE_SIZE)];
        self.circleView.progress = 1.0;
		[self addSubview:self.circleView];
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

- (void)resetArrowFrame {
    NSString *text = @"下拉刷新...";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:self.statusLabel.font range:NSMakeRange(0, text.length)];
    CGFloat width = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size.width+10;
    
    CGRect rect = self.circleView.frame;
    rect.origin.x = (self.bounds.size.width - width)/2.0 - REFRESH_CIRCLE_SIZE;
    self.circleView.frame = rect;
    
    CGRect rect2 = self.arrowImage.frame;
    rect2.origin.x = (self.bounds.size.width - width)/2.0 - 22;
    self.arrowImage.frame = rect2;
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"Arrow.png" textColor:TEXT_COLOR];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	if ([self.delegate respondsToSelector:@selector(egoRefreshTableDataSourceLastUpdated:)]) {
		NSDate *date = [self.delegate egoRefreshTableDataSourceLastUpdated:self];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
//		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];

		self.lastUpdatedLabel.text = [NSString stringWithFormat:@"更新于: %@", [dateFormatter stringFromDate:date]];
		[[NSUserDefaults standardUserDefaults] setObject:self.lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
	} else {
		self.lastUpdatedLabel.text = nil;
	}
}

- (void)setState:(EGOPullRefreshState)aState{
	switch (aState) {
        case EGOOPullRefreshPulling:{
            self.statusLabel.text = NSLocalizedString(@"release_load_more", nil);
            [CATransaction begin];
            [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
            self.arrowImage.transform = CATransform3DIdentity;
            [CATransaction commit];
        }
			break;
        case EGOOPullRefreshNormal:{
            if (_state == EGOOPullRefreshPulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                self.arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            
            self.statusLabel.text = NSLocalizedString(@"pull_up_load_more", nil);
            self.circleView.progress = 0;
            [self.circleView.layer removeAllAnimations];
//            [CATransaction begin];
//            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//            self.arrowImage.hidden = NO;
//            self.arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//            [CATransaction commit];
            
            [self refreshLastUpdatedDate];
        }
			break;
        case EGOOPullRefreshLoading:{
            self.statusLabel.text = NSLocalizedString(@"common_loading", nil);
            self.circleView.progress = 1;
            [self.circleView.layer addAnimation:[self rotationAnination] forKey:@"rotation"];
//            [CATransaction begin];
//            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//            self.arrowImage.hidden = YES;
//            [CATransaction commit];
        }
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (CABasicAnimation *)rotationAnination{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:2*M_PI];
    animation.autoreverses = NO;
    animation.duration = 0.6;
    animation.repeatCount = FLT_MAX;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.state == EGOOPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_FOOTER_REGION_HEIGHT, 0.0f);
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([self.delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
			_loading = [self.delegate egoRefreshTableDataSourceIsLoading:self];
		}
        
        CGFloat contenHeight = MAX(scrollView.contentSize.height, scrollView.frame.size.height);
		
		if (self.state == EGOOPullRefreshPulling && (scrollView.contentOffset.y+scrollView.frame.size.height) < contenHeight+REFRESH_FOOTER_REGION_HEIGHT && scrollView.contentOffset.y > 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (self.state == EGOOPullRefreshNormal && scrollView.contentOffset.y+(scrollView.frame.size.height) > contenHeight+REFRESH_FOOTER_REGION_HEIGHT && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
        
        float offsetY = (scrollView.bounds.size.height>scrollView.contentSize.height) ? scrollView.contentOffset.y : (float)fabs(scrollView.contentOffset.y+scrollView.bounds.size.height-scrollView.contentSize.height);
        float progress = offsetY / REFRESH_REGION_HEIGHT;
        self.circleView.progress = MIN(1, progress);
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
    }else {
        float offsetY = (scrollView.bounds.size.height>scrollView.contentSize.height) ? scrollView.contentOffset.y : (float)fabs(scrollView.contentOffset.y+scrollView.bounds.size.height-scrollView.contentSize.height);
        float progress = offsetY / REFRESH_REGION_HEIGHT;
        self.circleView.progress = MIN(1, progress);
    }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
		_loading = [self.delegate egoRefreshTableDataSourceIsLoading:self];
	}
	
    //这里由于iOS7对contentSize做了改变 故加上这段代码
    CGFloat contentSizeHeight = scrollView.contentSize.height;
    if (contentSizeHeight < scrollView.frame.size.height){
        contentSizeHeight = scrollView.frame.size.height;
    }
    
	if (scrollView.contentOffset.y+(scrollView.frame.size.height) > contentSizeHeight+REFRESH_FOOTER_REGION_HEIGHT  && !_loading) {
		if ([self.delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
			[self.delegate egoRefreshTableDidTriggerRefresh:EGORefreshFooter];
		}
		[self setState:EGOOPullRefreshLoading];
        
//        scrollView.bounces = NO;
        [UIView animateWithDuration:0.2 animations:^{
            if (scrollView.contentSize.height < scrollView.frame.size.height){
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, scrollView.frame.size.height-scrollView.contentSize.height+REFRESH_FOOTER_REGION_HEIGHT, 0.0f);
            }else{
                scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, REFRESH_FOOTER_REGION_HEIGHT, 0.0f);
            }
        } completion:^(BOOL finished) {
//            scrollView.bounces = YES;
        }];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.2];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
    //不懂为什么要这么改。。bug的确没有了。。
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    self.delegate = nil;
}


@end
