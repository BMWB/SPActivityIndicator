//
//  SPActivityIndicatorTwoDotsAnimation.m
//  SPActivityIndicator
//
//  Created by wtj on 2018/7/20.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "SPActivityIndicatorTwoDotsAnimation.h"

@implementation SPActivityIndicatorTwoDotsAnimation

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    NSTimeInterval duration = 1.5f;
    
    CGFloat circleSize = size.width / 5.0f;
    CGFloat oY = (layer.bounds.size.height - circleSize) / 2.0f;
    CGFloat oX = (layer.bounds.size.width - circleSize) / 2.0f;
    {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake(oX, oY, circleSize, circleSize);
        circle.backgroundColor = [UIColor orangeColor].CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 1.0f;
        circle.cornerRadius = circle.bounds.size.height / 2.0f;
        
        CATransform3D t1 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t1 = CATransform3DScale(t1, 1.1f, 1.1f, 0.0f);
        
        CATransform3D t2 = CATransform3DMakeTranslation(-2 * circleSize,0.0f, 0.0f);
        t2 = CATransform3DScale(t2, 1.0f, 1.0f, 0.0f);
        
        CATransform3D t3 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t3 = CATransform3DScale(t3, 0.3f, 0.3f, 0.0f);
        
        CATransform3D t4 = CATransform3DMakeTranslation(2 * circleSize,0.0f, 0.0f);
        t4 = CATransform3DScale(t4, 1.0f, 1.0f, 0.0f);
        
        CATransform3D t5 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t5 = CATransform3DScale(t5, 1.1f, 1.1f, 0.0f);
        
        CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        transformAnimation.values = @[[NSValue valueWithCATransform3D:t1],
                                      [NSValue valueWithCATransform3D:t4],
                                      [NSValue valueWithCATransform3D:t3],
                                      [NSValue valueWithCATransform3D:t2],
                                      [NSValue valueWithCATransform3D:t5]];
        transformAnimation.removedOnCompletion = NO;
        transformAnimation.beginTime = CACurrentMediaTime();
        transformAnimation.repeatCount = HUGE_VALF;
        transformAnimation.duration = duration;
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [layer addSublayer:circle];
        [circle addAnimation:transformAnimation forKey:@"animation"];
    }
    
    {
        CALayer *circle = [CALayer layer];
        circle.frame = CGRectMake(oX, (layer.bounds.size.height - circleSize) / 2.0f, circleSize, circleSize);
        circle.backgroundColor = [UIColor redColor].CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 1.0f;
        circle.cornerRadius = circle.bounds.size.height / 2.0f;
        
        CATransform3D t1 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t1 = CATransform3DScale(t1, 0.3f, 0.3f, 0.0f);
        
        CATransform3D t2 = CATransform3DMakeTranslation(2 * circleSize,0.0f, 0.0f);
        t2 = CATransform3DScale(t2, 1.0f, 1.0f, 0.0f);
        
        CATransform3D t3 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t3 = CATransform3DScale(t3, 1.1f, 1.1f, 0.0f);
        
        CATransform3D t4 = CATransform3DMakeTranslation(-2 * circleSize,0.0f, 0.0f);
        t4 = CATransform3DScale(t4, 1.f, 1.0f, 0.0f);
        
        CATransform3D t5 = CATransform3DMakeTranslation(0.0f, 0.0f, 0.0f);
        t5 = CATransform3DScale(t5, 0.3f, 0.3f, 0.0f);
        
        CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        transformAnimation.values = @[[NSValue valueWithCATransform3D:t1],
                                      [NSValue valueWithCATransform3D:t4],
                                      [NSValue valueWithCATransform3D:t3],
                                      [NSValue valueWithCATransform3D:t2],
                                      [NSValue valueWithCATransform3D:t5]];
    
        transformAnimation.duration = duration;
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.keyTimes = @[@0.0f,@0.3f,@1.2f,@1.5f];
        opacityAnimation.values = @[@0.0f,@1.0f,@1.0f,@0.0f];
        opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        CAAnimationGroup *animation = [CAAnimationGroup animation];
        animation.animations = @[transformAnimation,opacityAnimation];
        animation.removedOnCompletion = NO;
        animation.beginTime = CACurrentMediaTime();
        animation.repeatCount = HUGE_VALF;
        animation.duration = duration;
        
        [layer addSublayer:circle];
        [circle addAnimation:animation forKey:@"animation"];
    }
}
@end
