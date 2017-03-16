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

@interface ScrollViewInteractiveActions : UIPercentDrivenInteractiveTransition <SwipeInteractiveActionProgress, UIScrollViewDelegate>

@property (nonatomic) BOOL interactiveWhenDecelerating;

- (instancetype)initForViewController:(UIViewController *)controller andScrollView:(UIScrollView *)scrollView;

- (void)setTopBouncingAction:(SwipeInterativeObject *)action;

- (void)setBottomBouncingAction:(SwipeInterativeObject *)action;

@end

NS_ASSUME_NONNULL_END
