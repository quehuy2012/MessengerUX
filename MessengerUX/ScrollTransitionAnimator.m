//
//  ScrollTransitionAnimator.m
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ScrollTransitionAnimator.h"

@implementation ScrollTransitionAnimator

+ (instancetype)animationWithOption:(AnimateOption)animOption forPresentionOption:(PresentingOption)presentingOption {
    ScrollTransitionAnimator * animator = [[ScrollTransitionAnimator alloc] init];
    animator.animateOption = animOption;
    animator.presentingOption = presentingOption;
    return animator;
}

- (void)setupBeforeAnimationForFromViewView:(UIView *)fromView
                                  andToView:(UIView *)toView
                          andToViewSnapshot:(UIView *)snapshot
                                withContext:(nonnull id<UIViewControllerContextTransitioning>)context {
    
    CGRect initTo = [self getInitialFrameForToView:context];
    CGRect initFrom = [self getInitialFramForFromView:context];
    
    snapshot.frame = initTo;
    toView.frame = initTo;
    fromView.frame = initFrom;
    
    snapshot.hidden = YES;
}

- (void)setupAnimatingForFromViewView:(UIView *)fromView
                            andToView:(UIView *)toView
                    andToViewSnapshot:(UIView *)snapshot
                          withContext:(nonnull id<UIViewControllerContextTransitioning>)context {
    
    CGRect finalTo = [self getFinalFrameForToView:context];;
    CGRect finalFrom = [self getFinalFrameForFromView:context];
    
    snapshot.frame = finalTo;
    toView.frame = finalTo;
    fromView.frame = finalFrom;
    
    snapshot.hidden = NO;
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
