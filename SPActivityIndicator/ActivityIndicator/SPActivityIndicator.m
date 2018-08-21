//
//  SPActivityIndicator.m
//  ManagerZP
//
//  Created by wtj on 2018/7/24.
//  Copyright © 2018年 kanzhun. All rights reserved.
//

#import "SPActivityIndicator.h"
#import "SPActivityIndicatorAnimationProtocol.h"
#import "SPActivityIndicatorTwoDotsAnimation.h"

@interface SPActivityIndicatorView : UIView

@property (nonatomic) SPActivityIndicatorAnimationType type;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic) CGFloat size;

@property (nonatomic, readonly) BOOL animating;

- (void)startAnimating;
- (void)stopAnimating;

@end

@implementation SPActivityIndicatorView

#pragma mark -
#pragma mark Methods

- (void)setupAnimation {
    self.layer.sublayers = nil;
    
    id<SPActivityIndicatorAnimationProtocol> animation = [SPActivityIndicatorView activityIndicatorAnimationForAnimationType:_type];
    
    if ([animation respondsToSelector:@selector(setupAnimationInLayer:withSize:tintColor:)]) {
        [animation setupAnimationInLayer:self.layer withSize:CGSizeMake(self.bounds.size.width - 40, self.bounds.size.height - 40) tintColor:_tintColor];
        self.layer.speed = 0.0f;
    }
}

- (void)startAnimating {
    if (!self.layer.sublayers) {
        [self setupAnimation];
    }
    self.layer.speed = 1.0f;
    _animating = YES;
}

- (void)stopAnimating {
    self.layer.speed = 0.0f;
    _animating = NO;
}

#pragma mark -
#pragma mark Setters

- (void)setType:(SPActivityIndicatorAnimationType)type {
    if (_type != type) {
        _type = type;
        
        [self setupAnimation];
    }
}

- (void)setSize:(CGFloat)size {
    if (_size != size) {
        _size = size;
        
        [self setupAnimation];
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![_tintColor isEqual:tintColor]) {
        _tintColor = tintColor;
        
        for (CALayer *sublayer in self.layer.sublayers) {
            sublayer.backgroundColor = tintColor.CGColor;
        }
    }
}

#pragma mark -
#pragma mark Getters

+ (id<SPActivityIndicatorAnimationProtocol>)activityIndicatorAnimationForAnimationType:(SPActivityIndicatorAnimationType)type {
    return [[SPActivityIndicatorTwoDotsAnimation alloc] init];
}

@end

@interface SPActivityIndicator()

@property (strong, nonatomic) UIView * backgroundView;
@property (strong, nonatomic) SPActivityIndicatorView * activityView;
@property (strong, nonatomic) UIView * frontWindow;

@property (assign, nonatomic) SPActivityIndicatorAnimationType type;
@property (assign, nonatomic) UIWindowLevel maxSupportedWindowLevel;
@end

@implementation SPActivityIndicator

+ (SPActivityIndicator *)shareView {
    static dispatch_once_t onceToken;
    static SPActivityIndicator *shareView;
    dispatch_once(&onceToken, ^{
        shareView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
    });
    
    return shareView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundView.alpha = 1.0f;
        self.type = SPActivityIndicatorAnimationTypeTwoDots;
        self.maxSupportedWindowLevel = UIWindowLevelNormal;
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        self.activityView.tintColor = [UIColor whiteColor];
        self.activityView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Show Methods

+ (void)show {
    [self showView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showView:(UIView *)view {
    [[self shareView] showView:view];
}

+ (void)dismiss {
    [[self shareView] dismiss];
}

#pragma mark - Setters

+ (void)setHudColor:(UIColor *)color {
    [self shareView].activityView.backgroundColor = color;
}

+ (void)setTintColor:(UIColor *)color {
    [self shareView].activityView.tintColor = color;
}

+ (void)setAnimationType:(SPActivityIndicatorAnimationType)type {
    [self shareView].activityView.type = type;
}

+ (void)setBackgroundColor:(UIColor *)color {
    [self shareView].backgroundView.backgroundColor = color;
}

#pragma mark - Master show/dismiss methods

- (void)showView:(UIView *)view {
    
    if (![view isKindOfClass:[UIView class]]) {
        return;
    }
    
    if (self.superview) {
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
    }
    
    self.frontWindow = view;
    
    __weak SPActivityIndicator *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong SPActivityIndicator *strongSelf = weakSelf;
        
        if (strongSelf&&strongSelf.frontWindow) {
            [strongSelf.frontWindow addSubview:strongSelf];
            [strongSelf updateFrame];
            strongSelf.activityView.alpha = 1.0f;
            strongSelf.backgroundView.alpha = 1.0f;
            [strongSelf.activityView startAnimating];
        }
    }];
}

- (void)dismiss {
    [self dismiss:0];
}

- (void)dismiss:(NSTimeInterval)delay {
    __weak SPActivityIndicator *weakSelf = self;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        __strong SPActivityIndicator *strongSelf = weakSelf;
        
        if (strongSelf) {
            strongSelf.backgroundView.alpha = 1.0f;
            strongSelf.activityView.alpha = 1.0f;
        
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.25 delay:0 options:(UIViewAnimationOptions) (UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState) animations:^{
                    strongSelf.activityView.alpha = 0.0f;
                    strongSelf.backgroundView.alpha = 0.0f;
                    
                } completion:^(BOOL finished) {
                    [strongSelf.activityView stopAnimating];
                    [strongSelf.activityView removeFromSuperview];
                    [strongSelf.backgroundView removeFromSuperview];
                    [strongSelf removeFromSuperview];
                }];
            });
        }
    }];
}

- (void)updateFrame {
    self.frame = self.frontWindow.bounds;
}

#pragma mark - Getters

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [UIView new];
    }
    
    if (!_backgroundView.superview) {
        [self insertSubview:_backgroundView belowSubview:self.activityView];
    }
    
    if (_backgroundView) {
        _backgroundView.frame = self.bounds;
    }
    
    return _backgroundView;
}

- (SPActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[SPActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _activityView.layer.cornerRadius = 10;
    }
    
    if (_activityView) {
        _activityView.frame = CGRectMake(0, 0, 100, 100);
        _activityView.center = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
    }
    
    if (!_activityView.superview) {
        [self addSubview:_activityView];
    }

    return _activityView;
}

@end
