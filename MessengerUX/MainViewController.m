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
    
    [self initTabBarContent];
    
    [self addSwipeDownToCamera];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTabBarContent {
    BaseTabViewController * vc1 = [BaseTabViewController viewControllerWithName:@"Tab1" andImage:[UIImage imageNamed:@"tabThumbIcon"]];
    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    
    BaseTabViewController * vc2 = [BaseTabViewController viewControllerWithName:@"Tab2" andImage:[UIImage imageNamed:@"tabThumbIcon"]];
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    
    BaseTabViewController * vc3 = [BaseTabViewController viewControllerWithName:@"Tab3" andImage:[UIImage imageNamed:@"tabThumbIcon"]];
    UINavigationController * nav3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    
    self.viewControllers = @[nav1, nav2, nav3];
}

- (void)addSwipeDownToCamera {
    
//    self.navigationGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownController)];
//    [self.view addGestureRecognizer:self.navigationGesture];
    
}

@end
