//
//  SwipeInterativeObject.h
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeInterativeObject : NSObject

@property (nonatomic) BOOL isDismiss;
@property (nonatomic) UIViewController * presentViewController;
@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic) UIPercentDrivenInteractiveTransition * interative;
@property (nonatomic) id<UIViewControllerAnimatedTransitioning> animator;


/**
 Prepare action for present view controller

 @param presentViewController view controller need to be presented
 @param viewController view controller does the presenting
 @param animator transition animation
 @return action object
 */
- (instancetype)initPresentViewController:(UIViewController *)presentViewController
                       fromViewController:(UIViewController *)viewController
                            withAnimation:(id<UIViewControllerAnimatedTransitioning>)animator;

/**
 Prepapre action for dismiss view controller

 @param dismissViewController view controller need to be dismissed
 @param animator transition animation
 @return action object
 */
- (instancetype)initDismisViewController:(UIViewController *)dismissViewController
                           withAnimation:(id<UIViewControllerAnimatedTransitioning>)animator;

/**
 Excute action

 @return YES for excute successfully, NO for otherwise
 */
- (BOOL)excuteAction;

@end
