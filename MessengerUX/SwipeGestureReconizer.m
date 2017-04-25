//
//  SwipeGestureReconizer.m
//  MessengerUX
//
//  Created by CPU11815 on 3/9/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "SwipeGestureReconizer.h"

@interface SwipeGestureReconizer ()

@property (nonatomic) NavigationState navigationState;
@property (nonatomic) NavigationDoingState navigationDoingState;
@property (nonatomic, weak) UIView * attactView;

@end

@implementation SwipeGestureReconizer

- (instancetype)initWithDelegate:(id<SwipeGestureReconizerDelegate>)delegate toView:(UIView *)view {
    self = [super init];
    if (self) {
        self.swipeDelegate = delegate;
        __weak typeof(self) weakSelf = self;
        [self addTarget:weakSelf action:@selector(callSelfAction)];
        self.attactView = view;
        self.swipeThreadhold = 180;
        self.swipeVelocityThreadhold = 1000;
    }
    return self;
}

- (NavigationState)direction {
    return self.navigationState;
}

#pragma mark - SwipeGestureReconizerHandle

- (void)callSelfAction {
    
    CGPoint translationPoint = [self translationInView:self.attactView];
    CGPoint velocityPoint = [self velocityInView:self.attactView];
    
    switch (self.state) {
        case UIGestureRecognizerStateBegan: {
            
            if (fabs(velocityPoint.y) > fabs(velocityPoint.x)) {
                // User swipe along vertical axis
                if (velocityPoint.y > 0) {
                    // User swipe to down
                    self.navigationState = NavigationStateToDown;
                } else {
                    // User swipe to up
                    self.navigationState = NavigationStateToUp;
                }
            } else {
                // User swipe along horizonal axis
                if (velocityPoint.x > 0) {
                    // User swipe to right
                    self.navigationState = NavigationStateToRight;
                } else {
                    // User swipe to left
                    self.navigationState = NavigationStateToLeft;
                }
            }
            self.navigationDoingState = NavigationDoingStateNone;
            [self beginNavigationSwipe];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            
            BOOL canMove = NO;
            switch (self.navigationState) {
                case NavigationStateToDown: {
                    canMove = translationPoint.y > self.swipeThreadhold || velocityPoint.y > self.swipeVelocityThreadhold;
                    break;
                }
                case NavigationStateToUp: {
                    canMove = translationPoint.y < -self.swipeThreadhold || velocityPoint.y < -self.swipeVelocityThreadhold;
                    break;
                }
                case NavigationStateToRight: {
                    canMove = translationPoint.x > self.swipeThreadhold || velocityPoint.x > self.swipeVelocityThreadhold;
                    break;
                }
                case NavigationStateToLeft: {
                    canMove = translationPoint.x < -self.swipeThreadhold || velocityPoint.x < -self.swipeVelocityThreadhold;
                    break;
                }
                default:
                    // Do nothing with None
                    break;
            }
            self.navigationDoingState = canMove ? NavigationDoingStateCanMove : NavigationDoingStateNone;
            [self changeNavigationSwipe];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed: {
            [self endNavigationSwipe];
            self.navigationState = NavigationStateNone;
            self.navigationDoingState = NavigationDoingStateNone;
            break;
        }
        default:
            // Do nothing
            break;
    }
}

- (void)beginNavigationSwipe {
    if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeGesture:beginSwipeWithDirection:)]) {
        if (![self.swipeDelegate swipeGesture:self beginSwipeWithDirection:self.navigationState]) {
            // TODO cancel swipe gesture
        }
    }
}

- (void)changeNavigationSwipe {
    if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeGesture:changeWithDirection:withDoingState:)]) {
        [self.swipeDelegate swipeGesture:self changeWithDirection:self.navigationState withDoingState:self.navigationDoingState];
    }
}

- (void)endNavigationSwipe {
    if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeGesture:endWithDirection:withDoingState:)]) {
        [self.swipeDelegate swipeGesture:self endWithDirection:self.navigationState withDoingState:self.navigationDoingState];
    }
}

@end
