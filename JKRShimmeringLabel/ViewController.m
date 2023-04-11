//
//  ViewController.m
//  JKRShimmeringLabel
//
//  Created by 胡怀刈 on 2023/4/11.
//

#import "ViewController.h"
#import "JKRAutoScrollLabel.h"
#import "JKRShimmeringLabel.h"
#import "YYKit.h"

@interface ViewController ()

@property (nonatomic, strong) JKRAutoScrollLabel *autoScrollLabelForFrame;
@property (nonatomic, strong) JKRShimmeringLabel *shimmerLabelForFrame;

@property (weak, nonatomic) IBOutlet JKRAutoScrollLabel *autoScrollLabelForXib;
@property (weak, nonatomic) IBOutlet JKRShimmeringLabel *shimmerLabelForXib;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL isRTL = NO;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    UISemanticContentAttribute attr = window.semanticContentAttribute;
    UIUserInterfaceLayoutDirection layoutDirection = [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:attr];
    if (layoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        isRTL = YES;
    }
    
    
    UILabel *title0 = [UILabel new];
    title0.text = @"Frame布局，炫彩流动，超出范围自动滚动";
    title0.font = [UIFont systemFontOfSize:12];
    title0.textColor = [UIColor blackColor];
    title0.frame = CGRectMake(10, 100, kScreenWidth - 20, 15);
    [self.view addSubview:title0];
    
    // Frame布局，字体支持炫彩闪动，同时超出显示范围自动滚动
    NSMutableAttributedString *textForFrameAttr = [[NSMutableAttributedString alloc] initWithString:@"我是滚动测试文本Frame布局，看看我的效果" attributes:@{NSForegroundColorAttributeName: UIColorHex(FFFFFF), NSFontAttributeName: [UIFont systemFontOfSize:19 weight:UIFontWeightBold]}];
    self.autoScrollLabelForFrame = [[JKRAutoScrollLabel alloc] initWithFrame:CGRectMake(isRTL ? kScreenWidth - 10 - 300 : 10, CGRectGetMaxY(title0.frame) + 10, 300, 24)];
    // 滚动文本需要设置 attributedText 才能生效
    self.autoScrollLabelForFrame.attributedText = textForFrameAttr;
    // 设置文字颜色的mask图片遮罩，如果不需要字体炫彩，不设置即可
    self.autoScrollLabelForFrame.mask = [self maskImage];
    [self.view addSubview:self.autoScrollLabelForFrame];
    
    
    UILabel *title1 = [UILabel new];
    title1.text = @"Frame布局，炫彩流动，超出范围省略显示";
    title1.font = [UIFont systemFontOfSize:12];
    title1.textColor = [UIColor blackColor];
    title1.frame = CGRectMake(10, CGRectGetMaxY(self.autoScrollLabelForFrame.frame) + 10, kScreenWidth - 20, 15);
    [self.view addSubview:title1];

    // Frame布局，字体支持炫彩闪动
    self.shimmerLabelForFrame = [[JKRShimmeringLabel alloc] initWithFrame:CGRectMake(isRTL ? kScreenWidth - 10 - 300 : 10, CGRectGetMaxY(title1.frame) + 10, 300, 24)];
    self.shimmerLabelForFrame.text = @"我是彩色不滚动文本Frame布局，看看我的效果";
    self.shimmerLabelForFrame.font = [UIFont systemFontOfSize:19];
    // 设置文字颜色的mask图片遮罩，如果不需要字体炫彩，不设置即可
    self.shimmerLabelForFrame.mask = [self maskImage];
    [self.view addSubview:self.shimmerLabelForFrame];
    
    
    // Xib布局，字体支持炫彩闪动，同时超出显示范围自动滚动
    NSMutableAttributedString *textForXibAttr = [[NSMutableAttributedString alloc] initWithString:@"我是滚动测试文本Xib布局，看看我的效果" attributes:@{NSForegroundColorAttributeName: UIColorHex(FFFFFF), NSFontAttributeName: [UIFont systemFontOfSize:19 weight:UIFontWeightBold]}];
    // 滚动文本需要设置 attributedText 才能生效
    self.autoScrollLabelForXib.attributedText = textForXibAttr;
    // 设置文字颜色的mask图片遮罩
    self.autoScrollLabelForXib.mask = [self maskImage];
    
    
    // Xib布局，字体支持炫彩闪动
    self.shimmerLabelForXib.text = @"我是彩色不滚动文本Xib布局";
    self.shimmerLabelForXib.font = [UIFont systemFontOfSize:19];
    // 设置文字颜色的mask图片遮罩，如果不需要字体炫彩，不设置即可
    self.shimmerLabelForXib.mask = [self maskImage];
}

- (UIImage *)maskImage {
    static UIImage *img;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIColor *c1 = [UIColor colorWithRed:101/255.0 green:241/255.0 blue:255/255.0 alpha:1];//  青
        UIColor *c2 = [UIColor colorWithRed:246/255.0 green:202/255.0 blue:59/255.0 alpha:1]; // 黄
        UIColor *c3 = [UIColor colorWithRed:255/255.0 green:48/255.0 blue:173/255.0 alpha:1]; // 红
        img = [self __jkr_getGradientImageFromColors:@[c3, c1, c2, c3, c1, c3, c2, c1, c3, c1, c2, c3, c1, c3, c2, c1, c3] imgSize:CGSizeMake(100, 40)];
    });
    return img;
}

- (UIImage *)__jkr_getGradientImageFromColors:(NSArray*)colors imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    start = CGPointMake(0.0, 0.0);
    end = CGPointMake(imgSize.width, 0.0);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
