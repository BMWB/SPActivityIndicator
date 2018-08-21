//
//  SPActivityIndicatorAnimationProtocol.h
//  SPActivityIndicator
//
//  Created by wtj on 2018/7/20.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol SPActivityIndicatorAnimationProtocol <NSObject>
- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor;
@end
