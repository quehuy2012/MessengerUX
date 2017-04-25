//
//  BaseTabBarController.m
//  MessengerUX
//
//  Created by CPU11815 on 4/18/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "BaseTabBarController.h"
#import "JPFPSStatus.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[JPFPSStatus sharedInstance] open];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[JPFPSStatus sharedInstance] close];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
