//
//  SwipeAction.h
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeGestureReconizer.h"
#import "TransitionAnimator.h"

@class SwipeInterativeObject;
@class SwipeInteractiveActions;

@protocol SwipeInteractiveActionsDelegate <NSObject>

/**
 This method will be called when an action is going to be excuted

 @param interactiveActions current interactiveActions
 @param action action to be excute
 @return YES for excute action, NO otherwise
 */
- (BOOL)swipeInteractiveActions:(SwipeInteractiveActions *)interactiveActions startAction:(SwipeInterativeObject *)action;

/**
 Action in interactive process

 @param interactiveActions current interactiveActions
 @param action action being excute
 @param process interactive process
 */
- (void)swipeInteractiveActions:(SwipeInteractiveActions *)interactiveActions transferingAction:(SwipeInterativeObject *)action withProcess:(CGFloat)process;

/**
 End excute action

 @param interactiveActions current interactiveActions
 @param action action was excuted
 @param success action was excuted success or not
 */
- (void)swipeInteractiveActions:(SwipeInteractiveActions *)interactiveActions endAction:(SwipeInterativeObject *)action success:(BOOL)success;

@end

@protocol SwipeInteractiveActionProgress <NSObject>

- (BOOL)interactionInProgress;

@end

@interface SwipeInteractiveActions : UIPercentDrivenInteractiveTransition <SwipeInteractiveActionProgress>

@property (nonatomic, readonly) SwipeInterativeObject * leftAction;
@property (nonatomic, readonly) SwipeInterativeObject * rightAction;
@property (nonatomic, readonly) SwipeInterativeObject * topAction;
@property (nonatomic, readonly) SwipeInterativeObject * bottomAction;

@property (nonatomic, weak) id<SwipeInteractiveActionsDelegate> delegate;

/**
 Handy method for creating interactive actions

 @param vc interactive controller
 @return interactive actions
 */
- (instancetype)initWithController:(UIViewController *)vc;

/**
 Set current interactive controller

 @param vc controller for interactive
 */
- (void)setViewController:(UIViewController *)vc;

/**
 Set top action

 @param action action
 */
- (void)setTopAction:(SwipeInterativeObject *)action;

/**
 Set bottom action

 @param action action
 */
- (void)setBottomAction:(SwipeInterativeObject *)action;

/**
 Set left action

 @param action action
 */
- (void)setLeftAction:(SwipeInterativeObject *)action;

/**
 Set right action

 @param action action
 */
- (void)setRightAction:(SwipeInterativeObject *)action;

/**
 Check if in the interaction or not

 @return flag value
 */
- (BOOL)interactionInProgress;

@end

