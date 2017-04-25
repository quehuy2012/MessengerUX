//
//  TableViewInteractiveActions.h
//  MessengerUX
//
//  Created by CPU11815 on 3/15/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionAnimator.h"
#import "SwipeInteractiveActions.h"

NS_ASSUME_NONNULL_BEGIN

@class SwipeInterativeObject;
@protocol SwipeInteractiveActionProgress;

typedef NS_ENUM(NSUInteger, BouncingState) {
    BouncingStateNone = 0,
    BouncingStateTop,
    BouncingStateBottom
};

typedef NS_ENUM(NSUInteger, ScrollDrirection) {
    ScrollDrirectionStill = 0,
    ScrollDrirectionUp,
    ScrollDrirectionDown
};

@class ScrollViewInteractiveActions;

@protocol ScrollViewInteractiveActionsDelegate <NSObject>
/**
 This method will be called when an action is going to be excuted
 
 @param interactiveActions current interactiveActions
 @param action action to be excute
 @return YES for excute action, NO otherwise
 */
- (BOOL)scrollViewInteractiveActions:(ScrollViewInteractiveActions *)interactiveActions startAction:(SwipeInterativeObject *)action;

/**
 Action in interactive process
 
 @param interactiveActions current interactiveActions
 @param action action being excute
 @param process interactive process
 */
- (void)scrollViewInteractiveActions:(ScrollViewInteractiveActions *)interactiveActions transferingAction:(SwipeInterativeObject *)action withProcess:(CGFloat)process;

/**
 End excute action
 
 @param interactiveActions current interactiveActions
 @param action action was excuted
 @param success action was excuted success or not
 */
- (void)scrollViewInteractiveActions:(ScrollViewInteractiveActions *)interactiveActions endAction:(SwipeInterativeObject *)action success:(BOOL)success;

@end

@interface ScrollViewInteractiveActions : UIPercentDrivenInteractiveTransition <SwipeInteractiveActionProgress, UIScrollViewDelegate>

@property (nonatomic) BOOL interactiveWhenDecelerating;
@property (nonatomic, weak) id<ScrollViewInteractiveActionsDelegate> delegate;

/**
 Handy method to create interactive actions

 @param controller interactive controller
 @param scrollView interactive scrollview
 @return interactive actions
 */
- (instancetype)initForViewController:(UIViewController *)controller andScrollView:(UIScrollView *)scrollView;

/**
 Set top action when bouncing at top

 @param action action
 */
- (void)setTopBouncingAction:(SwipeInterativeObject *)action;

/**
 Set bottom action when bouncing at bottom

 @param action action
 */
- (void)setBottomBouncingAction:(SwipeInterativeObject *)action;

/**
 These are set of method need to be re-call by it's scrollview
 */
#pragma mark - Need forward for UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
