# JKRShimmeringLabel

## 特征

[![preview](https://github.com/Joker-388/JKRShimmeringLabel/blob/main/LTR.GIF)](https://www.jianshu.com/p/d81725130936?v=1681198297299)&nbsp;
<br>

[![preview](https://github.com/Joker-388/JKRShimmeringLabel/blob/main/RTL.GIF)](https://www.jianshu.com/p/d81725130936?v=1681198297299)&nbsp;
<br>

1. 支持炫彩字
2. 支持炫彩流动字
3. 支持超出显示范围自动滚动文本
4. 支持RTL下的对称显示和滚动
5. 支持Frame布局
6. 支持Xib和StoryBoard内使用
7. 支持AutoLayout布局

## 使用

和原生UILabel一样用，只需要设置mask属性（一张彩色的图片遮罩）即可。

### JKRAutoScrollLabel

超出范围自动滚动的Lable，需要设置attributedText，不能设置text。要同时支持流动彩字，设置mask即可。不需要彩色可以不设置mask，只有自动滚动的特性。

```
// Frame布局，字体支持炫彩闪动，同时超出显示范围自动滚动
NSMutableAttributedString *textForFrameAttr = [[NSMutableAttributedString alloc] initWithString:@"我是滚动测试文本Frame布局，看看我的效果" attributes:@{NSForegroundColorAttributeName: UIColorHex(FFFFFF), NSFontAttributeName: [UIFont systemFontOfSize:19 weight:UIFontWeightBold]}];
self.autoScrollLabelForFrame = [[JKRAutoScrollLabel alloc] initWithFrame:CGRectMake(isRTL ? kScreenWidth - 10 - 300 : 10, CGRectGetMaxY(title0.frame) + 10, 300, 24)];
// 滚动文本需要设置 attributedText 才能生效
self.autoScrollLabelForFrame.attributedText = textForFrameAttr;
// 设置文字颜色的mask图片遮罩，如果不需要字体炫彩，不设置即可
self.autoScrollLabelForFrame.mask = [self maskImage];
[self.view addSubview:self.autoScrollLabelForFrame];
```

### JKRShimmeringLabel

支持流动彩字，设置mask即可，如果还需要超出范围自动滚动，需要使用JKRAutoScrollLabel。

```
// Frame布局，字体支持炫彩闪动
self.shimmerLabelForFrame = [[JKRShimmeringLabel alloc] initWithFrame:CGRectMake(isRTL ? kScreenWidth - 10 - 300 : 10, CGRectGetMaxY(title1.frame) + 10, 300, 24)];
self.shimmerLabelForFrame.text = @"我是彩色不滚动文本Frame布局，看看我的效果";
self.shimmerLabelForFrame.font = [UIFont systemFontOfSize:19];
// 设置文字颜色的mask图片遮罩，如果不需要字体炫彩，不设置即可
self.shimmerLabelForFrame.mask = [self maskImage];
[self.view addSubview:self.shimmerLabelForFrame];
```

### Xib使用

控件支持xib和autolayout的场景，和UILabel一样设置约束即可，自动滚动和彩色动画，会自动支持。只需要正常配置约束，然后设置mask彩色遮罩即可。