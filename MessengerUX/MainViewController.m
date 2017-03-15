//
//  MainViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 3/9/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "MainViewController.h"
#import "BaseTabViewController.h"
#import "CameraViewController.h"
#import "InterativeTranslation.h"

@interface MainViewController ()

@property (nonatomic) SwipeInteractiveActions * swipeActions;

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

    self.swipeActions = [[SwipeInteractiveActions alloc] initWithController:self];
    
    CameraViewController * cameraVC = [CameraViewController viewController];
    // dismis
    StackTrainsitionAnimator * cameraPresentAnimator = [StackTrainsitionAnimator animationWithOption:AnimateOptionToDown
                                                                                 forPresentionOption:PresentingOptionWillShow];
    SwipeInterativeObject * bottomPresentAction = [[SwipeInterativeObject alloc] initPresentViewController:cameraVC fromViewController:self withAnimation:cameraPresentAnimator];
    [self.swipeActions setBottomAction:bottomPresentAction];
    
}

@end
