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
#import "GroupViewController.h"
#import "PeopleViewController.h"
#import "CameraViewController.h"
#import "InterativeTranslation.h"
#import "UIView+AutoLayout.h"

static const int CameraButtonWidth = 50;
static const int CameraButtonHeight = 50;

@interface CustomTabBarViewController () <UITabBarControllerDelegate>

@property (nonatomic) SwipeInteractiveActions * swipeActions;

@property (nonatomic) BOOL statusBarHidden;

@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.edgesForExtendedLayout = UIRectEdgeAll;
//    self.extendedLayoutIncludesOpaqueBars = NO;
    
    //[self addSwipeDownToCamera];
    
    [self setupTabBarButton];
    
    [self setupCameraButton];
    
    self.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSwipeDownToCamera {
    
    self.swipeActions = [[SwipeInteractiveActions alloc] initWithController:self];
    
    CameraViewController * cameraVC = [CameraViewController viewController];
    
    StackTrainsitionAnimator * cameraPresentAnimator = [StackTrainsitionAnimator animationWithOption:AnimateOptionToDown
                                                                                 forPresentionOption:PresentingOptionWillShow];
    SwipeInterativeObject * bottomPresentAction = [[SwipeInterativeObject alloc] initPresentViewController:cameraVC fromViewController:self withAnimation:cameraPresentAnimator];
    [self.swipeActions setBottomAction:bottomPresentAction];
    
}

- (void)setupTabBarButton {
    
    BaseTabViewController *homeVC = [HomeViewController viewControllerWithName:@"Home"];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    BaseTabViewController *callVC = [CallViewController viewControllerWithName:@"Calls"];
    UINavigationController *callNav = [[UINavigationController alloc] initWithRootViewController:callVC];
    
    BaseTabViewController *cameraVC = [CallViewController viewControllerWithName:@""];
    UINavigationController *cameraNav = [[UINavigationController alloc] initWithRootViewController:cameraVC];
    
    BaseTabViewController *groupVC = [GroupViewController viewControllerWithName:@"Groups"];
    UINavigationController *groupNav = [[UINavigationController alloc] initWithRootViewController:groupVC];
    
    BaseTabViewController *peopleVC = [PeopleViewController viewControllerWithName:@"People"];
    UINavigationController *peopleNav = [[UINavigationController alloc] initWithRootViewController:peopleVC];
    
    self.viewControllers = @[homeNav, callNav, cameraNav, groupNav, peopleNav];
}

- (void)setupCameraButton {
    
    UIButton *cameraButton = [[UIButton alloc] init];
    [self.view addSubview:cameraButton];
    
    // Auto layout
    [cameraButton atWidth:CameraButtonWidth];
    [cameraButton atHeight:CameraButtonHeight];
    [cameraButton atCenterHorizonalInParent];
    [cameraButton atTopMarginTo:self.view value:-CameraButtonHeight-8];
    cameraButton.layer.cornerRadius = CameraButtonHeight / 2;
    
    [cameraButton setImage:[UIImage imageNamed:@"cameraButtonNormal"] forState:UIControlStateNormal];
    cameraButton.backgroundColor = [UIColor whiteColor];
    
    // Scale mode
    cameraButton.contentMode = UIViewContentModeScaleToFill;
    cameraButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    cameraButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [cameraButton addTarget:self action:@selector(cameraButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cameraButtonAction {
    if (self.swipeActions && self.swipeActions.bottomAction) {
        [self.swipeActions.bottomAction excuteAction];
    }
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
