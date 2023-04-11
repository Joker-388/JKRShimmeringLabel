//
//  JKRShimmeringLabel.m
//  SoldierShimmering
//
//  Created by 胡怀刈 on 2022/12/7.
//  Copyright © 2022 Soldier. All rights reserved.
//  

#import "JKRShimmeringLabel.h"

@interface JKRShimmeringLabel ()

@property (nonatomic, strong) UILabel *innerLabel;

@property (nonatomic, strong) UIImageView *colorBg;

@end

@implementation JKRShimmeringLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.colorBg addSubview:self.innerLabel];
        [self addSubview:self.colorBg];
        self.colorBg.layer.mask = self.innerLabel.layer;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.colorBg addSubview:self.innerLabel];
    [self addSubview:self.colorBg];
    self.colorBg.layer.mask = self.innerLabel.layer;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self.innerLabel setTextAlignment:textAlignment];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self.innerLabel setText:text];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self.innerLabel setAttributedText:attributedText];
}

- (void)setTextColor:(UIColor *)textColor {
    [super setTextColor:textColor];
    [self.innerLabel setTextColor:textColor];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self.innerLabel setFont:font];
}

- (void)setMask:(UIImage *)mask {
    _mask = mask;
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_mask) {
        self.innerLabel.hidden = NO;
        self.colorBg.hidden = NO;
        self.colorBg.image = _mask;
        
        BOOL isRTL = NO;
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        if (window) {
            UISemanticContentAttribute attr = window.semanticContentAttribute;
            UIUserInterfaceLayoutDirection dir = [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:attr];
            if (dir == UIUserInterfaceLayoutDirectionRightToLeft) {
                isRTL = YES;
            }
        }

        if (isRTL) {
            self.innerLabel.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
            self.colorBg.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width * 4, self.frame.size.height);
            
            [self.innerLabel.layer removeAllAnimations];
            [self.colorBg.layer removeAllAnimations];
            
            {
                CABasicAnimation * base = [CABasicAnimation animationWithKeyPath:@"position.x"];
                base.beginTime = 0.f;
                base.fillMode = kCAFillModeForwards;
                base.removedOnCompletion = NO;
                base.byValue = @(self.frame.size.width * 2);
                [base setDuration:2];
                [base setRepeatCount:CGFLOAT_MAX];
                [self.innerLabel.layer addAnimation:base forKey:@"123213123"];
            }
            {
                CABasicAnimation * base = [CABasicAnimation animationWithKeyPath:@"position.x"];
                base.beginTime = 0.f;
                base.fillMode = kCAFillModeForwards;
                base.removedOnCompletion = NO;
                base.byValue = @(-self.frame.size.width * 2);
                [base setDuration:2];
                [base setRepeatCount:CGFLOAT_MAX];
                [self.colorBg.layer addAnimation:base forKey:@"123213123"];
            }
        } else {
            self.innerLabel.frame = CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height);
            self.colorBg.frame = CGRectMake(-self.frame.size.width * 2, 0, self.frame.size.width * 4, self.frame.size.height);
            
            [self.innerLabel.layer removeAllAnimations];
            [self.colorBg.layer removeAllAnimations];
            
            {
                CABasicAnimation * base = [CABasicAnimation animationWithKeyPath:@"position.x"];
                base.beginTime = 0.f;
                base.fillMode = kCAFillModeForwards;
                base.removedOnCompletion = NO;
                base.byValue = @(-self.frame.size.width * 2);
                [base setDuration:2];
                [base setRepeatCount:CGFLOAT_MAX];
                [self.innerLabel.layer addAnimation:base forKey:@"123213123"];
            }
            {
                CABasicAnimation * base = [CABasicAnimation animationWithKeyPath:@"position.x"];
                base.beginTime = 0.f;
                base.fillMode = kCAFillModeForwards;
                base.removedOnCompletion = NO;
                base.byValue = @(self.frame.size.width * 2);
                [base setDuration:2];
                [base setRepeatCount:CGFLOAT_MAX];
                [self.colorBg.layer addAnimation:base forKey:@"123213123"];
            }
        }
        
    } else {
        [self.innerLabel.layer removeAllAnimations];
        [self.colorBg.layer removeAllAnimations];
        
        self.innerLabel.hidden = YES;
        self.colorBg.hidden = YES;
    }
}

- (UILabel *)innerLabel {
    if (!_innerLabel) {
        _innerLabel = [UILabel new];
        _innerLabel.font = self.font;
        _innerLabel.text = self.text;
        _innerLabel.attributedText = self.attributedText;
        _innerLabel.textColor = self.textColor;
    }
    return _innerLabel;
}

- (UIImageView *)colorBg {
    if (!_colorBg) {
        _colorBg = [UIImageView new];
        _colorBg.contentMode = UIViewContentModeScaleToFill;
    }
    return _colorBg;
}

- (void)dealloc {
//    NSLog(@"JKRShimmeringLabel dealloc");
}

@end
