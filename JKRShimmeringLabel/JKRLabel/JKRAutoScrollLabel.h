//
//  JKRAutoScrollLabel.h
//  XMScrollCanvas
//
//  Created by Howie on 2021/10/27.
//  Copyright © 2021 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JKRAutoScrollLabel : UILabel

@property (nonatomic, assign) NSTimeInterval scrollDelay;

@property (nonatomic, strong, nullable) UIImage *mask;

@end

NS_ASSUME_NONNULL_END
