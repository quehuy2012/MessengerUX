//
//  TransitionAnimator.m
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "TransitionAnimator.h"

@interface TransitionAnimator ()

@property (nonatomic) CGFloat quickActionDuration;
@property (nonatomic) CGFloat normalActionDuration;

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
        self.quickActionDuration = 0.1;
        self.normalActionDuration = 0.4;
        self.duration = self.normalActionDuration;
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
        
        [self setupBeforeAnimationForFromView:fromVC.view
                                        andToView:toVC.view
                                      withContext:transitionContext];
        
        [self arrangeToVC:toVC inContainer:containerView];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        
        NSUInteger animOption = UIViewKeyframeAnimationOptionAllowUserInteraction;
        
        if ([transitionContext isInteractive]) {
            animOption = animOption | UIViewKeyframeAnimationOptionCalculationModeLinear;
        }
        
        [UIView animateWithDuration:duration delay:0 options:animOption animations:^{
            [self setupAnimatingForFromView:fromVC.view
                                  andToView:toVC.view
                                withContext:transitionContext];
        } completion:^(BOOL finished) {
            if (finished) {
                toVC.view.hidden = NO;
                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            } else {
                [transitionContext completeTransition:NO];
            }
        }];
        
//        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:animOption animations:^{
//            [self setupAnimatingForFromView:fromVC.view
//                                  andToView:toVC.view
//                                withContext:transitionContext];
//        } completion:^(BOOL finished) {
//            if (finished) {
//                toVC.view.hidden = NO;
//                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            } else {
//                [transitionContext completeTransition:NO];
//            }
//        }];
        
        
//        [UIView animateKeyframesWithDuration:duration delay:0 options:animOption animations:^{
//            
//            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
//                
//                [self setupAnimatingForFromView:fromVC.view
//                                          andToView:toVC.view
//                                        withContext:transitionContext];
//                
//            }];
//            
//        } completion:^(BOOL finished) {
//            if (finished) {
//                toVC.view.hidden = NO;
//                [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            } else {
//                [transitionContext completeTransition:NO];
//            }
//        }];
    }
}

- (void)setupBeforeAnimationForFromView:(UIView *)fromView
                                  andToView:(UIView *)toView
                                withContext:(id <UIViewControllerContextTransitioning>)context {
    toView.frame = self.originalFrame;
    fromView.frame = self.originalFrame;
}

- (void)setupAnimatingForFromView:(UIView *)fromView
                            andToView:(UIView *)toView
                          withContext:(id <UIViewControllerContextTransitioning>)context {
    toView.frame = self.originalFrame;
    fromView.frame = self.originalFrame;
}

- (void)arrangeToVC:(UIViewController *)toVC inContainer:(UIView *)container {
    
    [container addSubview:toVC.view];
    
    switch (self.presentingOption) {
        case PresentingOptionWillHide: {
            [container bringSubviewToFront:toVC.view];
            break;
        }
        case PresentingOptionWillShow: {
            [container sendSubviewToBack:toVC.view];
            break;
        }
    }
}

@end
