//
//  ViewController.m
//  SPActivityIndicator
//
//  Created by wtj on 2018/7/20.
//  Copyright © 2018年 wtj. All rights reserved.
//

#import "ViewController.h"
#import "SPActivityIndicator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup {
    self.view.backgroundColor = [UIColor orangeColor];
    
    [SPActivityIndicator showView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SPActivityIndicator dismiss];
    });
    
    {
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:view];
        
        view.frame = CGRectMake(100, 200, 50, 30);
        view.backgroundColor = [UIColor greenColor];
        
        [view addTarget:self action:@selector(tapEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)tapEvent:(UIButton *)sender {
    [self presentViewController:[ViewController new] animated:YES completion:nil];
}

@end
