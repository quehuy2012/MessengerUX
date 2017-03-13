//
//  CustomTabBarViewController.m
//  MessengerUX
//
//  Created by CPU11808 on 3/10/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "BaseTabViewController.h"
#import "HomeViewController.h"
#import "CallViewController.h"
#import "CameraViewController.h"
#import "GroupViewController.h"
#import "PeopleViewController.h"

@interface CustomTabBarViewController ()

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBarButton];
    
    [self setupMiddleButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupTabBarButton {
    
    BaseTabViewController *homeVC = [HomeViewController viewControllerWithName:@"Home" andImage:[UIImage imageNamed:@"homeTabIcon" ]];
    
    BaseTabViewController *callVC = [CallViewController viewControllerWithName:@"Calls" andImage:[UIImage imageNamed:@"callTabIcon" ]];
    
    BaseTabViewController *cameraVC = [CameraViewController viewControllerWithName:@"" andImage:[UIImage imageNamed:@"tabThumbIcon" ]];
    
    BaseTabViewController *groupVC = [GroupViewController viewControllerWithName:@"Groups" andImage:[UIImage imageNamed:@"groupTabIcon" ]];
    
    BaseTabViewController *peopleVC = [PeopleViewController viewControllerWithName:@"People" andImage:[UIImage imageNamed:@"peopleTabIcon" ]];
    
    self.viewControllers = @[homeVC, callVC, cameraVC, groupVC, peopleVC];

}

- (void)setupMiddleButton{
    
    UIButton *middleButton = [[UIButton alloc] init];
    middleButton.frame = CGRectMake(0, 0, 64, 64);
    
    CGRect buttonFrame = middleButton.frame;
    buttonFrame.origin.y = self.view.bounds.size.height - buttonFrame.size.height - 8;
    buttonFrame.origin.x = self.view.bounds.size.width / 2 - buttonFrame.size.width / 2;
    middleButton.frame = buttonFrame;
    
    
    middleButton.backgroundColor = [UIColor whiteColor];
    
    [middleButton setImage:[UIImage imageNamed:@"cameraButtonNormal"] forState:UIControlStateNormal];
    middleButton.contentMode = UIViewContentModeScaleToFill;
    middleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    middleButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    middleButton.backgroundColor = [UIColor redColor];
    
    middleButton.layer.cornerRadius = buttonFrame.size.height / 2;
    [self.view addSubview:middleButton];

    [middleButton addTarget:self action:@selector(middleButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)middleButtonAction {
    NSLog(@"button pressed");
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
