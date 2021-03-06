//
//  EGORefreshTableHeaderView.m
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

#import "EGORefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "RefreshCircleView.h"

@interface EGORefreshTableHeaderView ()

@property (strong, nonatomic) UILabel                      *lastUpdatedLabel;

@property (strong, nonatomic) UILabel                      *statusLabel;

@property (nonatomic, strong) RefreshCircleView             *circleView;

@end

@implementation EGORefreshTableHeaderView

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];

		self.lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		self.lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.lastUpdatedLabel.font = [UIFont systemFontOfSize:11.0];
		self.lastUpdatedLabel.textColor = textColor;
		self.lastUpdatedLabel.backgroundColor = [UIColor clearColor];
		self.lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
        self.lastUpdatedLabel.hidden = YES;
		[self addSubview:self.lastUpdatedLabel];
		
		self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 38.0f, self.frame.size.width, 30.0f)];
		self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.statusLabel.font = [UIFont systemFontOfSize:14.0];
		self.statusLabel.textColor = textColor;
		self.statusLabel.backgroundColor = [UIColor clearColor];
		self.statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:self.statusLabel];
        
        self.circleView = [[RefreshCircleView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-78., frame.size.height - 38.0f, REFRESH_CIRCLE_SIZE, REFRESH_CIRCLE_SIZE)];
        [self addSubview:self.circleView];
		
		[self setState:EGOOPullRefreshNormal];
    }
    return self;
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
            self.statusLabel.text = @"松开刷新...";
        }
			break;
        case EGOOPullRefreshNormal:{
            _statusLabel.text = @"下拉刷新...";
            
            self.circleView.progress = 0;
            [self.circleView.layer removeAllAnimations];
            
            [self refreshLastUpdatedDate];
        }
			break;
        case EGOOPullRefreshLoading:{
            _statusLabel.text = @"加载中...";
            self.circleView.progress = 1;
            [self.circleView.layer addAnimation:[self rotationAnination] forKey:@"rotation"];
        }
			break;
		default:
			break;
	}
	_state = aState;
}

- (void)resetArrowFrame {
    NSString *text = @"下拉刷新...";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:self.statusLabel.font range:NSMakeRange(0, text.length)];
    CGFloat width = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size.width+10;
    
    CGRect rect = self.circleView.frame;
    rect.origin.x = ([UIScreen mainScreen].bounds.size.width - width)/2.0 - REFRESH_CIRCLE_SIZE;
    self.circleView.frame = rect;
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
		offset = MIN(offset, REFRESH_REGION_HEIGHT);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	} else if (scrollView.isDragging) {
		BOOL _loading = NO;
		if ([self.delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
			_loading = [self.delegate egoRefreshTableDataSourceIsLoading:self];
		}
		
		if (self.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -REFRESH_REGION_HEIGHT && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (self.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -REFRESH_REGION_HEIGHT && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
        float progress = (float)fabs(scrollView.contentOffset.y) / REFRESH_REGION_HEIGHT;
        self.circleView.progress = MIN(1, progress);
        
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
    }else {
        float progress = (float)fabs(scrollView.contentOffset.y) / REFRESH_REGION_HEIGHT;
        self.circleView.progress = MIN(1, progress);
    }
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	BOOL _loading = NO;
	if ([self.delegate respondsToSelector:@selector(egoRefreshTableDataSourceIsLoading:)]) {
		_loading = [self.delegate egoRefreshTableDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - REFRESH_REGION_HEIGHT && !_loading) {
		
		if ([self.delegate respondsToSelector:@selector(egoRefreshTableDidTriggerRefresh:)]) {
			[self.delegate egoRefreshTableDidTriggerRefresh:EGORefreshHeader];
		}
		
		[self setState:EGOOPullRefreshLoading];
        
        scrollView.bounces = NO;
        [UIView animateWithDuration:0.2 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(REFRESH_REGION_HEIGHT, 0.0f, 0.0f, 0.0f);
        } completion:^(BOOL finished) {
            scrollView.bounces = YES;
        }];
	}
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            
            [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        } completion:^(BOOL finished) {
            
        }];
    });
    
	[self setState:EGOOPullRefreshNormal];
}


#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    self.delegate = nil;
}


@end
