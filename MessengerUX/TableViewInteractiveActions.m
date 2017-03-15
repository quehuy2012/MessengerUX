//
//  TableViewInteractiveActions.m
//  MessengerUX
//
//  Created by CPU11815 on 3/15/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "TableViewInteractiveActions.h"
#import "SwipeInterativeObject.h"
#import "SwipeInteractiveActions.h"

@interface TableViewInteractiveActions ()

@property (nonatomic) SwipeInterativeObject * actionBouncingTop;
@property (nonatomic) SwipeInterativeObject * actionBouncingBottom;

@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic) BOOL _interactionInProgress;

@property (nonatomic) BoucingState currentBoucingState;

@property (nonatomic) BOOL canBoucing;
@property (nonatomic) NSUInteger boucingThreadhold;
@property (nonatomic) CGFloat currentBoucingAmong;
@end

@implementation TableViewInteractiveActions

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewController = nil;
        self.currentBoucingState = BoucingStateNone;
        self._interactionInProgress = NO;
        self.canBoucing = NO;
        self.boucingThreadhold = 50;
        self.currentBoucingAmong = 0;
    }
    return self;
}

- (instancetype)initForViewController:(UIViewController *)controller {
    self = [self init];
    if (self) {
        self.viewController = controller;
    }
    return self;
}

- (void)setTopBoucingAction:(SwipeInterativeObject *)action {
    self.actionBouncingTop = action;
    self.actionBouncingTop.interative = self;
}

- (void)setBottomBoucingAction:(SwipeInterativeObject *)action {
    self.actionBouncingBottom = action;
    self.actionBouncingBottom.interative = self;
}

- (void)startBoundingTop {
    if (self.actionBouncingTop) {
        self._interactionInProgress = YES;
        [self.actionBouncingTop excuteAction];
    }
}

- (void)startBoundingBottom {
    if (self.actionBouncingBottom) {
        self._interactionInProgress = YES;
        [self.actionBouncingBottom excuteAction];
    }
}

- (void)endInteractiveWithSuccess:(BOOL)success {
    if (success) {
        [self finishInteractiveTransition];
    } else {
        [self cancelInteractiveTransition];
    }
    self._interactionInProgress = NO;
    self.canBoucing = NO;
    self.currentBoucingAmong = 0;
    self.currentBoucingState = BoucingStateNone;
}

- (BOOL)interactionInProgress {
    return self._interactionInProgress;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    BOOL boucingTop = scrollView.contentOffset.y < 0;
    
    BOOL boucingBottom = scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.size.height);
    
    if (boucingTop || boucingBottom) {
        if (boucingBottom) {
            // Bottom boucing
            if (self.currentBoucingState != BoucingStateBottom) {
                self.currentBoucingState = BoucingStateBottom;
                [self startBoundingBottom];
            } else if (self._interactionInProgress) {
                // update interative
                self.currentBoucingAmong = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.bounds.size.height);
                if (self.currentBoucingAmong > self.boucingThreadhold) {
                    self.canBoucing = YES;
                } else {
                    self.canBoucing = NO;
                }
                CGFloat process = self.currentBoucingAmong / self.viewController.view.frame.size.height;
                [self updateInteractiveTransition:process];
                
                switch (scrollView.panGestureRecognizer.state) {
                    case UIGestureRecognizerStateEnded:
                    case UIGestureRecognizerStateCancelled:
                    case UIGestureRecognizerStateFailed: {
                        if (self._interactionInProgress && self.canBoucing) {
                            [self endInteractiveWithSuccess:YES];
                        } else {
                            [self endInteractiveWithSuccess:NO];
                        }
                        break;
                    }
                    default:
                        break;
                }
                
                NSLog(@"%f", process);
            }
        } else if (boucingTop) {
            // Top boucing
            if (self.currentBoucingState != BoucingStateTop) {
                self.currentBoucingState = BoucingStateTop;
                [self startBoundingTop];
            } else if (self._interactionInProgress) {
                // update interactive
                self.currentBoucingAmong = scrollView.contentOffset.y;
                if (self.currentBoucingAmong < -self.boucingThreadhold) {
                    self.canBoucing = YES;
                } else {
                    self.canBoucing = NO;
                }
                
                CGFloat process = self.currentBoucingAmong / -self.viewController.view.frame.size.height;
                [self updateInteractiveTransition:process];
                
                switch (scrollView.panGestureRecognizer.state) {
                    case UIGestureRecognizerStateEnded:
                    case UIGestureRecognizerStateCancelled:
                    case UIGestureRecognizerStateFailed: {
                        if (self._interactionInProgress && self.canBoucing) {
                            [self endInteractiveWithSuccess:YES];
                        } else {
                            [self endInteractiveWithSuccess:NO];
                        }
                        break;
                    }
                    default:
                        break;
                }
                
                NSLog(@"%f", process);
            }
        }
    } else {
        // Normal scroll
        self.currentBoucingState = BoucingStateNone;
        self.currentBoucingAmong = 0;
        if (self._interactionInProgress) {
            [self endInteractiveWithSuccess:NO];
        }
    }
}

@end
