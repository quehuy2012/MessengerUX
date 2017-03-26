//
//  StackTrainsitionAnimator.m
//  MessengerUX
//
//  Created by CPU11815 on 3/10/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "StackTrainsitionAnimator.h"
#import <pop/POP.h>

@interface StackTrainsitionAnimator ()

@end

@implementation StackTrainsitionAnimator

+ (instancetype)animationWithOption:(AnimateOption)animOption forPresentionOption:(PresentingOption)presentingOption {
    StackTrainsitionAnimator * animator = [[StackTrainsitionAnimator alloc] init];
    animator.animateOption = animOption;
    animator.presentingOption = presentingOption;
    return animator;
}

- (void)setupBeforeAnimationForFromView:(UIView *)fromView
                                  andToView:(UIView *)toView
                                withContext:(nonnull id<UIViewControllerContextTransitioning>)context {
    
    CGRect initTo = [self getInitialFrameForToView:context];
    CGRect initFrom = [self getInitialFramForFromView:context];
    
    toView.frame = initTo;
    fromView.frame = initFrom;
}

- (void)setupAnimatingForFromView:(UIView *)fromView
                            andToView:(UIView *)toView
                          withContext:(nonnull id<UIViewControllerContextTransitioning>)context {
    
    CGRect finalToFrame = [self getFinalFrameForToView:context];
    CGRect finalFromFrame = [self getFinalFrameForFromView:context];
    
    POPSpringAnimation *toViewAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    toViewAnimation.toValue = [NSValue valueWithCGRect:finalToFrame];
    toViewAnimation.springBounciness = 10.f;
    [toViewAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [context completeTransition:YES];
    }];
    
    POPSpringAnimation *fromViewAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    fromViewAnimation.toValue = [NSValue valueWithCGRect:finalFromFrame];
    fromViewAnimation.springBounciness = 20.f;
    
    [fromView pop_addAnimation:fromViewAnimation forKey:@"fromViewAnimation"];
    [toView pop_addAnimation:toViewAnimation forKey:@"toViewAnimation"];
    
//    toView.frame = finalTo;
//    fromView.frame = finalFrom;
    
//    [context completeTransition:![context transitionWasCancelled]];
}

- (CGRect)getFinalFrameForFromView:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    
    CGRect finalTranslationFrame = self.originalFrame;
    
    switch (self.presentingOption) {
        case PresentingOptionWillShow: {
            
            switch (self.animateOption) {
                case AnimateOptionToDown: {
                    return CGRectOffset(finalTranslationFrame, 0, CGRectGetHeight(finalTranslationFrame));
                }
                case AnimateOptionToUp: {
                    return CGRectOffset(finalTranslationFrame, 0, -CGRectGetHeight(finalTranslationFrame));
                }
                case AnimateOptionToLeft: {
                    return CGRectOffset(finalTranslationFrame, -CGRectGetWidth(finalTranslationFrame), 0);
                }
                case AnimateOptionToRight: {
                    return CGRectOffset(finalTranslationFrame, CGRectGetWidth(finalTranslationFrame), 0);
                }
            }
        }
        case PresentingOptionWillHide: {
            return finalTranslationFrame;
        }
    }
    
    return CGRectZero;
}

- (CGRect)getInitialFramForFromView:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    
    CGRect finalTranslationFrame = self.originalFrame;
    
    switch (self.presentingOption) {
        case PresentingOptionWillShow: {
            return finalTranslationFrame;
        }
        case PresentingOptionWillHide: {
            return finalTranslationFrame;
        }
    }
    
    return CGRectZero;
}

- (CGRect)getFinalFrameForToView:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalTranslationFrame = [transitionContext finalFrameForViewController:toVC];
    
    switch (self.presentingOption) {
        case PresentingOptionWillShow: {
            return finalTranslationFrame;
        }
        case PresentingOptionWillHide: {
            return finalTranslationFrame;
        }
    }
    
    return CGRectZero;
}

- (CGRect)getInitialFrameForToView:(nonnull id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalTranslationFrame = [transitionContext finalFrameForViewController:toVC];
    
    switch (self.presentingOption) {
            
        case PresentingOptionWillShow: {
            return finalTranslationFrame;
        }
        case PresentingOptionWillHide: {
            
            switch (self.animateOption) {
                case AnimateOptionToDown: {
                    return CGRectOffset(finalTranslationFrame, 0, -CGRectGetHeight(finalTranslationFrame));
                }
                case AnimateOptionToUp: {
                    return CGRectOffset(finalTranslationFrame, 0, CGRectGetHeight(finalTranslationFrame));
                }
                case AnimateOptionToLeft: {
                    return CGRectOffset(finalTranslationFrame, CGRectGetWidth(finalTranslationFrame), 0);
                }
                case AnimateOptionToRight: {
                    return CGRectOffset(finalTranslationFrame, -CGRectGetWidth(finalTranslationFrame), 0);
                }
            }
        }
    }
    
    return CGRectZero;
}

@end
