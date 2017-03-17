//
//  SwipeInterativeObject.h
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InteractiveAnimation.h"
@interface SwipeInterativeObject : NSObject

@property (nonatomic) BOOL isDismiss;

@property (nonatomic) UIViewController * presentViewController;
@property (nonatomic, weak) UIViewController * viewController;

@property (nonatomic) UIPercentDrivenInteractiveTransition * interative;

@property (nonatomic) id<UIViewControllerAnimatedTransitioning, InteractiveAnimation> animator;


- (instancetype)initPresentViewController:(UIViewController *)presentViewController
                       fromViewController:(UIViewController *)viewController
                            withAnimation:(id<UIViewControllerAnimatedTransitioning, InteractiveAnimation>)animator;

- (instancetype)initDismisViewController:(UIViewController *)dismissViewController
                           withAnimation:(id<UIViewControllerAnimatedTransitioning, InteractiveAnimation>)animator;

- (BOOL)excuteAction;

@end
