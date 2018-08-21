//
//  SPActivityIndicator.h
//  ManagerZP
//
//  Created by wtj on 2018/7/24.
//  Copyright © 2018年 kanzhun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SPActivityIndicatorAnimationType) {
    SPActivityIndicatorAnimationTypeTwoDots,
};

@interface SPActivityIndicator : UIView

+ (void)setHudColor:(UIColor *)color;
+ (void)setTintColor:(UIColor *)color;
+ (void)setBackgroundColor:(UIColor *)color;
+ (void)setAnimationType:(SPActivityIndicatorAnimationType)type;
+ (void)show;
+ (void)showView:(UIView *)view;
+ (void)dismiss;

@end
