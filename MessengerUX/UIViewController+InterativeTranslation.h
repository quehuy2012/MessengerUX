//
//  UIViewController+SwipeInterativeTranslation.h
//  MessengerUX
//
//  Created by CPU11815 on 3/9/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeGestureReconizer.h"

@interface UIViewController (InterativeTranslation) <SwipeGestureReconizerDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIViewControllerInteractiveTransitioning>

- (void)setupSwipeInterativeDirection:(NavigationState)direction toViewController:(id<UIViewControllerAnimatedTransitioning>)controller;

@end
