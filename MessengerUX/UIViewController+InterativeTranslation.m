//
//  UIViewController+SwipeInterativeTranslation.m
//  MessengerUX
//
//  Created by CPU11815 on 3/9/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UIViewController+InterativeTranslation.h"

@implementation UIViewController (InterativeTranslation)

- (void)setupSwipeInterativeDirection:(NavigationState)direction toViewController:(id<UIViewControllerAnimatedTransitioning>)controller {
    SwipeGestureReconizer * gesture = [[SwipeGestureReconizer alloc] initForDirection:direction withDelegate:self toView:self.view];
    [self.view addGestureRecognizer:gesture];
}

- (void)swipeGesture:(SwipeGestureReconizer *)gesture beginSwipeWithDirection:(NavigationState)direction {
    
}

- (void)swipeGesture:(SwipeGestureReconizer *)gesture changeWithDoingState:(NavigationDoingState)doingState {
    
}

- (void)swipeGesture:(SwipeGestureReconizer *)gesture endWithDoingState:(NavigationDoingState)doingState {
    
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return nil;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return nil;
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
}

@end
