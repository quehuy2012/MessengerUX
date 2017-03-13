//
//  MainViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 3/9/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "MainViewController.h"
#import "BaseTabViewController.h"
#import "BaseSwipeNavViewController.h"



@interface MainViewController ()

@property (nonatomic) UIPanGestureRecognizer * navigationGesture;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSwipeDownToCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSwipeDownToCamera {
    
//    self.navigationGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownController)];
//    [self.view addGestureRecognizer:self.navigationGesture];
    
}

@end
