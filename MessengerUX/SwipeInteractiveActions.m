//
//  SwipeAction.m
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "SwipeInteractiveActions.h"
#import "SwipeInterativeObject.h"

@interface SwipeInteractiveActions () <SwipeGestureReconizerDelegate>

@property (nonatomic, weak) UIViewController * currentViewController;

@property (nonatomic) SwipeInterativeObject * actionLeft;
@property (nonatomic) SwipeInterativeObject * actionRight;
@property (nonatomic) SwipeInterativeObject * actionTop;
@property (nonatomic) SwipeInterativeObject * actionBottom;
@property (nonatomic) SwipeInterativeObject * internalCurrentAction;

@property (nonatomic) SwipeGestureReconizer * gesture;

@property (nonatomic) BOOL mInteractionInProgress;

@end

@implementation SwipeInteractiveActions

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentViewController = nil;
    }
    return self;
}

- (instancetype)initWithController:(UIViewController *)vc {
    self = [self init];
    if (self) {
        [self setViewController:vc];
    }
    return self;
}

- (void)setViewController:(UIViewController *)vc {
    if (self.currentViewController && self.gesture) {
        [self.currentViewController.view removeGestureRecognizer:self.gesture];
    }
    self.currentViewController = vc;
    [self connectGestureToCurrentVC];
    [self removeAllNavigationViewController];
}

- (void)setTopAction:(SwipeInterativeObject *)action {
    self.actionTop = action;
    self.actionTop.interative = self;
}

- (void)setBottomAction:(SwipeInterativeObject *)action {
    self.actionBottom = action;
    self.actionBottom.interative = self;
}

- (void)setLeftAction:(SwipeInterativeObject *)action {
    self.actionLeft = action;
    self.actionLeft.interative = self;
}

- (void)setRightAction:(SwipeInterativeObject *)action {
    self.actionRight = action;
    self.actionRight.interative = self;
}

- (SwipeInterativeObject *)topAction {
    return self.actionTop;
}

- (SwipeInterativeObject *)bottomAction {
    return self.actionBottom;
}

- (SwipeInterativeObject *)leftAction {
    return self.actionLeft;
}

- (SwipeInterativeObject *)rightAction {
    return self.actionRight;
}

#pragma mark - Action

- (void)connectGestureToCurrentVC {
    self.gesture = [[SwipeGestureReconizer alloc] initWithDelegate:self toView:self.currentViewController.view];
    [self.currentViewController.view addGestureRecognizer:self.gesture];
}

- (void)removeAllNavigationViewController {
    self.actionTop = nil;
    self.actionLeft = nil;
    self.actionRight = nil;
    self.actionBottom = nil;
}

#pragma mark - SwipeGestureReconizerDelegate

- (BOOL)swipeGesture:(SwipeGestureReconizer *)gesture beginSwipeWithDirection:(NavigationState)direction {
    self.mInteractionInProgress = YES;
    switch (direction) {
        case NavigationStateToUp:
            self.internalCurrentAction = self.actionTop;
            break;
        case NavigationStateToDown:
            self.internalCurrentAction = self.actionBottom;
            break;
        case NavigationStateToLeft:
            self.internalCurrentAction = self.actionLeft;
            break;
        case NavigationStateToRight:
            self.internalCurrentAction = self.actionRight;
            break;
        default:
            break;
    }
    
    if (self.internalCurrentAction) {
        [self.internalCurrentAction excuteAction];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeInteractiveActions:startAction:)]) {
        [self.delegate swipeInteractiveActions:self startAction:self.internalCurrentAction];
    }
    
    return YES;
}

- (void)swipeGesture:(SwipeGestureReconizer *)gesture changeWithDirection:(NavigationState)direction withDoingState:(NavigationDoingState)doingState {
    CGPoint translationPoint = [gesture translationInView:self.currentViewController.view];
    CGFloat progress = 0.0;
    
    switch (direction) {
        case NavigationStateToUp:
            progress = translationPoint.y / -self.currentViewController.view.frame.size.height;
            break;
        case NavigationStateToDown:
            progress = translationPoint.y / self.currentViewController.view.frame.size.height;
            break;
        case NavigationStateToLeft:
            progress = translationPoint.x / -self.currentViewController.view.frame.size.width;
            break;
        case NavigationStateToRight: {
            progress = translationPoint.x / self.currentViewController.view.frame.size.width;
            break;
        }
        default: {
            return;
        }
    }
    
    [self updateInteractiveTransition:progress*0.9];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeInteractiveActions:transferingAction:withProcess:)]) {
        [self.delegate swipeInteractiveActions:self transferingAction:self.internalCurrentAction withProcess:progress];
    }
}

- (void)swipeGesture:(SwipeGestureReconizer *)gesture endWithDirection:(NavigationState)direction withDoingState:(NavigationDoingState)doingState {
    BOOL success = doingState == NavigationDoingStateCanMove;
    
    if (success) {
        [self finishInteractiveTransition];
    } else {
        [self cancelInteractiveTransition];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeInteractiveActions:endAction:success:)]) {
        [self.delegate swipeInteractiveActions:self endAction:self.internalCurrentAction success:success];
    }
    
    self.internalCurrentAction = nil;
    self.mInteractionInProgress = NO;
}

- (BOOL)interactionInProgress {
    return self.mInteractionInProgress;
}

@end
