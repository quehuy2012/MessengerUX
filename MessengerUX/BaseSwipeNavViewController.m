//
//  BaseSwipeNavViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 3/9/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "BaseSwipeNavViewController.h"

@interface BaseSwipeNavViewController ()

@end

@implementation BaseSwipeNavViewController

+ (instancetype)viewController {
    BaseSwipeNavViewController * retsult = [[BaseSwipeNavViewController alloc] init];
    return retsult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton * bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
    [bt setTitle:@"Back" forState:UIControlStateNormal];
    bt.backgroundColor = [UIColor blackColor];
    [bt addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bt];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) clickBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
