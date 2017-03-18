//
//  CameraViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CameraViewController.h"
#import "GalleryViewController.h"
#import "DrawViewController.h"
#import "InterativeTranslation.h"

#import "UIView+AutoLayout.h"

@interface CameraViewController ()

@property (nonatomic) SwipeInteractiveActions * swipeActions;

@end

@implementation CameraViewController

+ (instancetype)viewController {
    CameraViewController * retsult = [[CameraViewController alloc] init];
    return retsult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cameraThumb"]];
    [self.view addSubview:imageView];
    
    [imageView atLeadingWith:self.view value:0];
    [imageView atTrailingWith:self.view value:0];
    [imageView atTopingWith:self.view value:0];
    [imageView atBottomingWith:self.view value:0];
    
    [self addSwipeNavigation];
}

- (void)addSwipeNavigation {
    
    self.swipeActions = [[SwipeInteractiveActions alloc] initWithController:self];
    
    // dismis
    StackTrainsitionAnimator * cameraDismissAnimator = [StackTrainsitionAnimator animationWithOption:AnimateOptionToUp
                                                                                 forPresentionOption:PresentingOptionWillHide];
    SwipeInterativeObject * topDismissAction = [[SwipeInterativeObject alloc] initDismisViewController:self withAnimation:cameraDismissAnimator];
    [self.swipeActions setTopAction:topDismissAction];
    
    // present gallery
    GalleryViewController * galleryVC = [GalleryViewController viewController];
    ScrollTransitionAnimator * galleryPresentAnimator = [ScrollTransitionAnimator animationWithOption:AnimateOptionToRight
                                                                                  forPresentionOption:PresentingOptionWillShow];
    SwipeInterativeObject * leftPresentAction = [[SwipeInterativeObject alloc] initPresentViewController:galleryVC
                                                                                      fromViewController:self
                                                                                           withAnimation:galleryPresentAnimator];
    [self.swipeActions setRightAction:leftPresentAction];
    
    // present draw
    DrawViewController * drawVC = [DrawViewController viewController];
    ScrollTransitionAnimator * drawPresentAnimator = [ScrollTransitionAnimator animationWithOption:AnimateOptionToLeft
                                                                               forPresentionOption:PresentingOptionWillShow];
    SwipeInterativeObject * rightPresentAction = [[SwipeInterativeObject alloc] initPresentViewController:drawVC
                                                                                       fromViewController:self
                                                                                            withAnimation:drawPresentAnimator];
    [self.swipeActions setLeftAction:rightPresentAction];
}

@end
