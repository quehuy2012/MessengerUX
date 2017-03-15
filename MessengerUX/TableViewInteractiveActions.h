//
//  TableViewInteractiveActions.h
//  MessengerUX
//
//  Created by CPU11815 on 3/15/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionAnimator.h"

@class SwipeInterativeObject;
@protocol SwipeInteractiveActionProgress;

typedef NS_ENUM(NSUInteger, BoucingState) {
    BoucingStateNone = 0,
    BoucingStateTop,
    BoucingStateBottom
};

@interface TableViewInteractiveActions : UIPercentDrivenInteractiveTransition <SwipeInteractiveActionProgress>

- (instancetype)initForViewController:(UIViewController *)controller;

- (void)setTopBoucingAction:(SwipeInterativeObject *)action;

- (void)setBottomBoucingAction:(SwipeInterativeObject *)action;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
