//
//  LeeLinkLabel.m
//  XXLinkLabelDemo
//
//  Created by captain on 2017/12/7.
//  Copyright © 2017年 王旭. All rights reserved.
//

#import "HYLinkLabel.h"

@interface HYLinkLabel ()

@property (nonatomic , strong ) NSTextStorage *textStorage;         //保存并管理UITextView要展示的文字内容，
@property (nonatomic , strong ) NSLayoutManager *layoutManager;     //用于管理NSTextStorage其中的文字内容的排版布局
@property (nonatomic , strong ) NSTextContainer *textContainer;     //定义了一个矩形区域用于存放已经进行了排版并设置好属性的文字

@property (nonatomic, strong) NSArray   *linkRanges;

@property (nonatomic , assign ) NSRange selectedRange;

@end

@implementation HYLinkLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self prepareLabel]; //添加各种文本管理属性单元
        self.linkTextColor = [UIColor blueColor];
    }
    return self;
}

- (void)prepareLabel {
    _textStorage = [[NSTextStorage alloc]init];
    _layoutManager = [[NSLayoutManager alloc]init];
    _textContainer = [[NSTextContainer alloc]init];
    self.textContainer.size = self.bounds.size;
    
    [self.textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager addTextContainer:self.textContainer];
    
    self.textContainer.lineFragmentPadding = 0;  //是在设置行间距吧
    
    [self setUserInteractionEnabled:YES];
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self prepareLabel]; //添加各种文本管理属性单元
    }
    return self;
}

- (void)setText:(NSString *)text linkRanges:(NSArray *)linkRanges {
    self.linkRanges = linkRanges;
    
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStringM addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, text.length)];
    [attrStringM addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    [attrStringM addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    for (NSString *rangeStr in linkRanges) {
        NSRange range = NSRangeFromString(rangeStr);
        [attrStringM addAttribute:NSForegroundColorAttributeName value:self.linkTextColor range:range];
        [attrStringM addAttribute:NSUnderlineStyleAttributeName value:@(1) range:range];
    }
    
    [self.textStorage setAttributedString:attrStringM];
    
    [self setNeedsDisplay];
}


- (void)drawTextInRect:(CGRect)rect {
    
    NSRange range = [self glyphsRange];
    CGPoint offset = [self glyphsOffset:range];
    [self.layoutManager drawBackgroundForGlyphRange:range atPoint:offset];
    [self.layoutManager drawGlyphsForGlyphRange:range atPoint:offset];
}

- (CGPoint )glyphsOffset:(NSRange )glyphsRange {
    //居中显示
    CGRect rect = [self.layoutManager boundingRectForGlyphRange:glyphsRange inTextContainer:self.textContainer];
    CGFloat height = (self.bounds.size.height - rect.size.height) * 0.5;
    return CGPointMake(0, height);
}

//获取显示范围 glyphs
- (NSRange)glyphsRange {
    return NSMakeRange(0, self.textStorage.length);
}


#pragma mark ================== Touch =================
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self timerBegin];
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    self.selectedRange = [self linkRangeAtLocation:location];
    [self modifySelectedAttribute:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self timerEnd];
//    [self timerBegin];
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    NSRange range = [self linkRangeAtLocation:location];
    
    if (range.length != 0 || range.location != 0) {
        if (!(range.location == self.selectedRange.location && range.length == self.selectedRange.length)) {
            [self modifySelectedAttribute:NO];
            self.selectedRange = range;
            [self modifySelectedAttribute:YES];
        }
    }else {
        [self modifySelectedAttribute:NO];
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self timerEnd];
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
    
    [self modifySelectedAttribute:NO];
    
    for (NSInteger i = 0; i < self.linkRanges.count; i++) {
        NSRange range = NSRangeFromString(self.linkRanges[i]);
        if (range.length == self.selectedRange.length && range.location == self.selectedRange.location) {
            if (self.selectLinkAtIndex) {
                self.selectLinkAtIndex(i);
            }
            break;
        }
    }
    
    self.selectedRange = NSMakeRange(0, 0);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self modifySelectedAttribute:NO];
}

- (NSRange)linkRangeAtLocation:(CGPoint)location {
    if (self.textStorage.length == 0) {
        return NSMakeRange(0, 0);
    }
    NSRange glyphsRange = [self glyphsRange];
    CGPoint offset = [self glyphsOffset:glyphsRange];
    CGPoint point = CGPointMake(location.x - offset.x, location.y - offset.y);
    NSUInteger index = [self.layoutManager glyphIndexForPoint:point inTextContainer:self.textContainer];
    for (NSString *rangeString in self.linkRanges) {
        NSRange range = NSRangeFromString(rangeString);
        if (index >= range.location && index < range.location + range.length) {
            return range;
        }
    }
    return NSMakeRange(0, 0);
    
}

- (void)modifySelectedAttribute:(BOOL)isSet {
    if (self.selectedRange.location == 0 && self.selectedRange.length == 0) {
        return;
    }
    NSRange range0 = NSMakeRange(self.selectedRange.location, self.selectedRange.length);
    
    NSDictionary *dict = [self.textStorage attributesAtIndex:0 effectiveRange:&range0];
    dict = nil;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    attributes[NSForegroundColorAttributeName] = self.linkTextColor;
    NSRange range = self.selectedRange;
    if (self.selectedRange.length > 0) {
        
        if (isSet) {
            attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
        } else {
            attributes[NSForegroundColorAttributeName] = self.linkTextColor;
        }
    }
    [self.textStorage addAttributes:attributes range:range];
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textContainer.size = self.bounds.size;
}

@end
