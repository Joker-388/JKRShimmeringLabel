//
//  JKRAutoScrollLabel.m
//  XMScrollCanvas
//
//  Created by Howie on 2021/10/27.
//  Copyright © 2021 wxm. All rights reserved.
//

#import "JKRAutoScrollLabel.h"
#import "YYKit.h"
#import "JKRShimmeringLabel.h"

#define SCROLL_DISTANCE 100

@interface JKRAutoScrollLabel ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) BOOL hasLayout;

@property (nonatomic, assign) BOOL needReset;

@property (nonatomic, strong) NSAttributedString *myAttr;

@property (nonatomic, strong) NSMutableArray<JKRShimmeringLabel *> *playingLabels;

@property (nonatomic, assign) BOOL shouldAnimate;

@end

@implementation JKRAutoScrollLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.textColor = [UIColor clearColor];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _scrollView.frame = self.bounds;
    self.hasLayout = YES;
    //    [self startScroll];
    [self checkPlay];
}

- (void)setMask:(UIImage *)mask {
    _mask = mask;
    
    [self layoutIfNeeded];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    self.myAttr = attributedText;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:attributedText];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithDictionary:attributedText.attributes];
    attrs[NSForegroundColorAttributeName] = [UIColor clearColor];
    [attr setAttributes:attrs];
    
    [super setAttributedText:attr];
    self.needReset = YES;
    //    [self startScroll];
    [self checkPlay];
}

- (void)startScroll {
    if (self.hasLayout == NO || self.needReset == NO) {
        if (self.playingLabels.count) {
            [self.playingLabels enumerateObjectsUsingBlock:^(JKRShimmeringLabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.mask = self.mask;
            }];
        }
        return;
    }
    
    self.needReset = NO;
    
    if (self.timer) {
        [self.timer invalidate];
    }
    [self removeAllSubviews];
    _scrollView = nil;
    [self.playingLabels removeAllObjects];
    
    if (!self.myAttr) {
        return;
    }
    
    CGSize textSize = [self.myAttr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = NO;
    _scrollView.delegate = self;
    
    if (textSize.width <= self.width) {
        _scrollView.frame = self.bounds;
        [self addSubview:_scrollView];
        
        JKRShimmeringLabel *textLabel = [JKRShimmeringLabel new];
        textLabel.mask = self.mask;
        textLabel.attributedText = self.myAttr;
        textLabel.frame = _scrollView.bounds;
        textLabel.textAlignment = self.textAlignment;
        [_scrollView addSubview:textLabel];
        _scrollView.contentSize = CGSizeMake(0, 0);
        [self.playingLabels addObject:textLabel];
        
        if ([self isRightToLeft]) {
            _scrollView.transform = CGAffineTransformMakeRotation(M_PI);
            
            [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
    } else {
        _scrollView.frame = self.bounds;
        [self addSubview:_scrollView];
        
        for (NSInteger i = 0; i < 2; i++) {
            JKRShimmeringLabel *textLabel = [JKRShimmeringLabel new];
            textLabel.mask = self.mask;
            textLabel.attributedText = self.myAttr;
            textLabel.frame = CGRectMake((textSize.width + 30) * i, 0, textSize.width + 30, self.height);
            [_scrollView addSubview:textLabel];
            [self.playingLabels addObject:textLabel];
        }
        _scrollView.contentSize = CGSizeMake((textSize.width + 30) * 2, 0);
        
        if ([self isRightToLeft]) {
            _scrollView.transform = CGAffineTransformMakeRotation(M_PI);

            [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:(_scrollView.contentSize.width / 2.0 / SCROLL_DISTANCE + self.scrollDelay) target:[YYWeakProxy proxyWithTarget:self] selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[NSDate date] timeIntervalSince1970]];
        [self.timer setFireDate:date];
    }
}

- (void)endScroll {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    _scrollView = nil;
    [_scrollView removeFromSuperview];
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.userInteractionEnabled = NO;
    _scrollView.delegate = self;
    _scrollView.frame = self.bounds;
    [self addSubview:_scrollView];
    
    JKRShimmeringLabel *textLabel = [JKRShimmeringLabel new];
    textLabel.mask = self.mask;
    textLabel.attributedText = self.myAttr;
    textLabel.frame = _scrollView.bounds;
    textLabel.textAlignment = self.textAlignment;
    [_scrollView addSubview:textLabel];
    _scrollView.contentSize = CGSizeMake(0, 0);
    [self.playingLabels addObject:textLabel];
    
    if ([self isRightToLeft]) {
        _scrollView.transform = CGAffineTransformMakeRotation(M_PI);
        
        [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
}

- (BOOL)isRightToLeft {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window) {
        return UIUserInterfaceLayoutDirectionLeftToRight;
    }
    UISemanticContentAttribute attr = window.semanticContentAttribute;
    UIUserInterfaceLayoutDirection dir = [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:attr];
    return dir == UIUserInterfaceLayoutDirectionRightToLeft;
}

- (void)autoScroll{
    CGFloat textWidth = [self.myAttr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size.width;
    /// 兼容xib，xib初始化时设置字符串，width不准
    if (self.width >= textWidth) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        return;
    }
    
    CGFloat offSet = _scrollView.contentSize.width / 2.0;
    
    _scrollView.contentOffset=CGPointMake(0, 0);
    
    [UIView animateWithDuration:(_scrollView.contentSize.width / 2.0 / SCROLL_DISTANCE) delay:self.scrollDelay options:UIViewAnimationOptionCurveLinear animations:^{
        self->_scrollView.contentOffset=CGPointMake(self->_scrollView.contentOffset.x+offSet, self->_scrollView.contentOffset.y);
    } completion:nil];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self checkPlay];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    [self checkPlay];
}

- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    [self checkPlay];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [self checkPlay];
}

- (void)checkPlay {
    [self updateShouldAnimate];
    if (self.shouldAnimate) {
        [self startScroll];
    } else {
        [self endScroll];
    }
}

- (void) updateShouldAnimate {
    BOOL isVisible = self.window && self.superview && ![self isHidden] && self.alpha > 0.0;
    self.shouldAnimate = isVisible;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (NSMutableArray<JKRShimmeringLabel *> *)playingLabels {
    if (!_playingLabels) {
        _playingLabels = [NSMutableArray array];
    }
    return _playingLabels;
}

@end
