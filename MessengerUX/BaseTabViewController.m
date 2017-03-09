//
//  BaseTabViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 3/9/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "BaseTabViewController.h"

@interface BaseTabViewController ()

@end

@implementation BaseTabViewController

+ (instancetype)viewControllerWithName:(NSString *)name andImage:(UIImage *)image {
    BaseTabViewController * tab = [[BaseTabViewController alloc] init];
    tab.tabBarItem.title = name;
    tab.tabBarItem.image = image;
    return tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.navigationItem.title = self.tabBarItem.title;
    self.view.backgroundColor = [UIColor whiteColor];
}

@end
