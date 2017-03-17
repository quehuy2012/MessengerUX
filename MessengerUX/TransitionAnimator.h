//
//  TransitionAnimator.h
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractiveAnimation.h"

typedef NS_ENUM(NSUInteger, AnimateOption) {
    AnimateOptionToUp = 0,
    AnimateOptionToDown,
    AnimateOptionToLeft,
    AnimateOptionToRight
};

typedef NS_ENUM(NSUInteger, PresentingOption) {
    PresentingOptionWillShow = 0,
    PresentingOptionWillHide
};

@interface TransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning, InteractiveAnimation>

@property (nonatomic) CGRect originalFrame;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) AnimateOption animateOption;
@property (nonatomic) PresentingOption presentingOption;

+ (instancetype)animationWithOption:(AnimateOption)animOption forPresentionOption:(PresentingOption)presentingOption;

- (void)setupBeforeAnimationForFromViewView:(UIView *)fromView
                                  andToView:(UIView *)toView
                          andToViewSnapshot:(UIView *)snapshot
                                withContext:(id <UIViewControllerContextTransitioning>)context;

- (void)setupAnimatingForFromViewView:(UIView *)fromView
                            andToView:(UIView *)toView
                    andToViewSnapshot:(UIView *)snapshot
                          withContext:(id <UIViewControllerContextTransitioning>)context;

@end
