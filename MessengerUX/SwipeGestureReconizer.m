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
@property (nonatomic) NavigationState navigateDirectionAccept;
@property (nonatomic) NavigationDoingState navigationDoingState;
@property (nonatomic, weak) UIView * attactView;

@end

@implementation SwipeGestureReconizer

- (instancetype)initForDirection:(NavigationState)direction withDelegate:(id<SwipeGestureReconizerDelegate>)delegate toView:(UIView *)view {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        __weak typeof(self) weakSelf = self;
        [self addTarget:weakSelf action:@selector(callSelfAction)];
        self.attactView = view;
        self.swipeThreadhold = 100;
        self.navigateDirectionAccept = direction == NavigationStateNone ? NavigationStateToDown : direction;
    }
    return self;
}

- (NavigationState)direction {
    return self.navigateDirectionAccept;
}

#pragma mark - SwipeGestureReconizerHandle

- (void)callSelfAction {
    
    CGPoint translationPoint = [self translationInView:self.attactView];
    CGPoint velocityPoint = [self velocityInView:self.attactView];
    
    NSLog(@"Trans: %f %f Veloc: %f %f", translationPoint.x, translationPoint.y, velocityPoint.x, velocityPoint.y);
    
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
            switch (self.navigationState) {
                case NavigationStateToDown: {
                    NSLog(@"Down");
                    if (fabs(translationPoint.y) > self.swipeThreadhold) {
                        self.navigationDoingState = NavigationDoingStateCanMove;
                    }
                    break;
                }
                case NavigationStateToUp: {
                    NSLog(@"Up");
                    if (fabs(translationPoint.y) > self.swipeThreadhold) {
                        self.navigationDoingState = NavigationDoingStateCanMove;
                    }
                    break;
                }
                case NavigationStateToRight: {
                    NSLog(@"Right");
                    if (fabs(translationPoint.x) > self.swipeThreadhold) {
                        self.navigationDoingState = NavigationDoingStateCanMove;
                    }
                    break;
                }
                case NavigationStateToLeft: {
                    NSLog(@"Left");
                    if (fabs(translationPoint.x) > self.swipeThreadhold) {
                        self.navigationDoingState = NavigationDoingStateCanMove;
                    }
                    break;
                }
                default:
                    // Do nothing with None
                    break;
            }
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
        [self.swipeDelegate swipeGesture:self beginSwipeWithDirection:self.navigationState];
    }
}

- (void)changeNavigationSwipe {
    if (self.navigationState == self.navigateDirectionAccept) {
        // Do change
        if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeGesture:changeWithDoingState:)]) {
            [self.swipeDelegate swipeGesture:self changeWithDoingState:self.navigationDoingState];
        }
    }
}

- (void)endNavigationSwipe {
    if (self.navigationState == self.navigateDirectionAccept) {
        // Do navigate
        if (self.swipeDelegate && [self.swipeDelegate respondsToSelector:@selector(swipeGesture:endWithDoingState:)]) {
            [self.swipeDelegate swipeGesture:self endWithDoingState:self.navigationDoingState];
        }
    }
}

@end
