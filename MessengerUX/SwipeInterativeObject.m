//
//  SwipeInterativeObject.m
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "SwipeInterativeObject.h"
#import "SwipeInteractiveActions.h"

#import "StackTrainsitionAnimator.h"

@interface SwipeInterativeObject () <UIViewControllerTransitioningDelegate>

@end

@implementation SwipeInterativeObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isDismiss = YES;
        self.presentViewController = nil;
        self.viewController = nil;
        self.animator = nil;
    }
    return self;
}

- (instancetype)initPresentViewController:(UIViewController *)presentViewController
                       fromViewController:(UIViewController *)viewController
                            withAnimation:(id<UIViewControllerAnimatedTransitioning>)animator {
    self = [self init];
    if (self) {
        self.isDismiss = NO;
        self.presentViewController = presentViewController;
        self.viewController = viewController;
        self.animator = animator;
    }
    return self;
}

- (instancetype)initDismisViewController:(UIViewController *)dismissViewController
                           withAnimation:(id<UIViewControllerAnimatedTransitioning>)animator {
    self = [self init];
    if (self) {
        self.isDismiss = YES;
        self.viewController = dismissViewController;
        self.animator = animator;
    }
    return self;
}

- (BOOL)excuteAction {
    if (self.isDismiss) {
        if (self.viewController) {
            self.viewController.transitioningDelegate = self;
            [self.viewController dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        if (self.viewController && self.presentViewController) {
            self.presentViewController.transitioningDelegate = self;
            [self.viewController presentViewController:self.presentViewController animated:YES completion:nil];
        }
    }
    return YES;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                            presentingController:(UIViewController *)presenting
                                                                                sourceController:(UIViewController *)source {
    return self.animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.animator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return [((id<SwipeInteractiveActionProgress>)self.interative) interactionInProgress] ? self.interative : nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    return [((id<SwipeInteractiveActionProgress>)self.interative) interactionInProgress] ? self.interative : nil;
}

@end
