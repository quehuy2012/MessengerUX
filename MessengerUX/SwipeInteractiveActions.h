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

- (BOOL)swipeInteractiveActions:(SwipeInteractiveActions *)interactiveActions startAction:(SwipeInterativeObject *)action;

- (void)swipeInteractiveActions:(SwipeInteractiveActions *)interactiveActions transferingAction:(SwipeInterativeObject *)action withProcess:(CGFloat)process;

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

- (instancetype)initWithController:(UIViewController *)vc;

- (void)setViewController:(UIViewController *)vc;

- (void)setTopAction:(SwipeInterativeObject *)action;

- (void)setBottomAction:(SwipeInterativeObject *)action;

- (void)setLeftAction:(SwipeInterativeObject *)action;

- (void)setRightAction:(SwipeInterativeObject *)action;

- (BOOL)interactionInProgress;

@end

