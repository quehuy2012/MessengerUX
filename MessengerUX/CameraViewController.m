//
//  CameraViewController.m
//  MessengerUX
//
//  Created by CPU11808 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)viewControllerWithName:(NSString *)name {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Camera" bundle:nil];
    CameraViewController * tab = [storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    
    tab.tabBarItem.title = name;
    
    return tab;
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
