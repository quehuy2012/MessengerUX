//
//  TransitionAnimator.m
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "TransitionAnimator.h"

@interface TransitionAnimator ()

@end

@implementation TransitionAnimator

+ (instancetype)animationWithOption:(AnimateOption)animOption forPresentionOption:(PresentingOption)presentingOption {
    TransitionAnimator * animator = [[TransitionAnimator alloc] init];
    animator.animateOption = animOption;
    animator.presentingOption = presentingOption;
    return animator;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.animateOption = AnimateOptionToDown;
        self.presentingOption = PresentingOptionWillHide;
        self.duration = 0.3;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    NSAssert(!CGRectEqualToRect(self.originalFrame, CGRectNull), @"Original frame must be set!");
    
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView * containerView = [transitionContext containerView];
    
    self.originalFrame = containerView.frame;
    
    // We must have enough elements to start animate translation
    if (fromVC && toVC && containerView) {
        
        UIView * finalScreenSnapshot = [toVC.view snapshotViewAfterScreenUpdates:YES];
        finalScreenSnapshot.clipsToBounds = YES;
        
        [self setupBeforeAnimationForFromViewView:fromVC.view
                                        andToView:toVC.view
                                andToViewSnapshot:finalScreenSnapshot
                                      withContext:transitionContext];
        
        [self arrangeToVC:toVC andSnapShot:finalScreenSnapshot inContainer:containerView];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModePaced animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
                
                [self setupAnimatingForFromViewView:fromVC.view
                                          andToView:toVC.view
                                  andToViewSnapshot:finalScreenSnapshot
                                        withContext:transitionContext];
                
            }];
            
        } completion:^(BOOL finished) {
            if (finished) {
                toVC.view.hidden = NO;
                [finalScreenSnapshot removeFromSuperview];
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            } else {
                [transitionContext completeTransition:NO];
            }
        }];
    }
}

- (void)setupBeforeAnimationForFromViewView:(UIView *)fromView
                                  andToView:(UIView *)toView
                          andToViewSnapshot:(UIView *)snapshot
                                withContext:(id <UIViewControllerContextTransitioning>)context {
    snapshot.frame = self.originalFrame;
    toView.frame = self.originalFrame;
    fromView.frame = self.originalFrame;
}

- (void)setupAnimatingForFromViewView:(UIView *)fromView
                            andToView:(UIView *)toView
                    andToViewSnapshot:(UIView *)snapshot
                          withContext:(id <UIViewControllerContextTransitioning>)context {
    snapshot.frame = self.originalFrame;
    toView.frame = self.originalFrame;
    fromView.frame = self.originalFrame;
}

- (void)arrangeToVC:(UIViewController *)toVC andSnapShot:(UIView *)snapshot inContainer:(UIView *)container {
    
    [container addSubview:toVC.view];
    [container addSubview:snapshot];
    
    switch (self.presentingOption) {
        case PresentingOptionWillHide: {
            [container bringSubviewToFront:toVC.view];
            [container bringSubviewToFront:snapshot];
            toVC.view.hidden = YES;
            snapshot.hidden = NO;
            break;
        }
        case PresentingOptionWillShow: {
            [container sendSubviewToBack:snapshot];
            [container sendSubviewToBack:toVC.view];
            toVC.view.hidden = YES;
            snapshot.hidden = YES;
            break;
        }
    }
}

@end
