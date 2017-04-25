//
//  SwipeGestureReconizer.h
//  MessengerUX
//
//  Created by CPU11815 on 3/9/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NavigationState) {
    NavigationStateNone = 0,
    
    NavigationStateToDown,
    NavigationStateToUp,
    NavigationStateToLeft,
    NavigationStateToRight
};

typedef NS_ENUM(NSUInteger, NavigationDoingState) {
    NavigationDoingStateCanMove,
    NavigationDoingStateNone
};

@class SwipeGestureReconizer;

@protocol SwipeGestureReconizerDelegate <UIGestureRecognizerDelegate>

- (BOOL)swipeGesture:(SwipeGestureReconizer *)gesture beginSwipeWithDirection:(NavigationState)direction;

- (void)swipeGesture:(SwipeGestureReconizer *)gesture changeWithDirection:(NavigationState)direction withDoingState:(NavigationDoingState)doingState;

- (void)swipeGesture:(SwipeGestureReconizer *)gesture endWithDirection:(NavigationState)direction withDoingState:(NavigationDoingState)doingState;

@end

@interface SwipeGestureReconizer : UIPanGestureRecognizer

@property (nonatomic, weak) id<SwipeGestureReconizerDelegate> swipeDelegate;

@property (nonatomic, readonly) NavigationState direction;

@property (nonatomic) CGFloat swipeThreadhold;
@property (nonatomic) CGFloat swipeVelocityThreadhold;

- (instancetype)initWithDelegate:(id<SwipeGestureReconizerDelegate>)delegate toView:(UIView *)view;

@end
