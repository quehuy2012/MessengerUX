//
//  TableViewInteractiveActions.h
//  MessengerUX
//
//  Created by CPU11815 on 3/15/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionAnimator.h"

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

@interface ScrollViewInteractiveActions : UIPercentDrivenInteractiveTransition <SwipeInteractiveActionProgress, UITableViewDelegate>

- (instancetype)initForViewController:(UIViewController *)controller;

- (void)setTopBouncingAction:(SwipeInterativeObject *)action;

- (void)setBottomBouncingAction:(SwipeInterativeObject *)action;


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
//// any offset changes
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView;
//
//// called on start of dragging (may require some time and or distance to move)
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
//// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;   // called on finger up as we are moving
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//
//- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;     // return a view that will be scaled. if delegate returns nil, nothing happens
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2); // called before the scroll view begins zooming its content
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum. called after any 'bounce' animations
//
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;   // return a yes if you want to scroll to the top. if not defined, assumes YES
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
