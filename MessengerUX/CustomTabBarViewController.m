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

static const int CameraButtonWidth = 50;
static const int CameraButtonheight = 50;

@interface CustomTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabBarButton];
    
    [self setupCameraButton];
    
    self.delegate = self;
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

- (void)setupCameraButton {
    
    UIButton *cameraButton = [[UIButton alloc] init];

    CGRect buttonFrame = CGRectMake(0, 0, CameraButtonWidth, CameraButtonheight);
    buttonFrame.origin.y = self.view.bounds.size.height - buttonFrame.size.height - 8;
    buttonFrame.origin.x = self.view.bounds.size.width / 2 - buttonFrame.size.width / 2;
    cameraButton.frame = buttonFrame;

    cameraButton.backgroundColor = [UIColor whiteColor];
    
    [cameraButton setImage:[UIImage imageNamed:@"cameraButtonNormal"] forState:UIControlStateNormal];
    cameraButton.contentMode = UIViewContentModeScaleToFill;
    cameraButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    cameraButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    cameraButton.layer.cornerRadius = buttonFrame.size.height / 2;
    [self.view addSubview:cameraButton];

    [cameraButton addTarget:self action:@selector(cameraButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cameraButtonAction {
    NSLog(@"button pressed");
}

#pragma mark - UITabBarDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([viewController.tabBarItem.title isEqualToString:@""])
        return NO;
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
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
