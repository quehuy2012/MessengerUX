//
//  TableViewInteractiveActions.m
//  MessengerUX
//
//  Created by CPU11815 on 3/15/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ScrollViewInteractiveActions.h"
#import "SwipeInterativeObject.h"
#import "SwipeInteractiveActions.h"

@interface ScrollViewInteractiveActions ()

@property (nonatomic) SwipeInterativeObject * actionBouncingTop;
@property (nonatomic) SwipeInterativeObject * actionBouncingBottom;

@property (nonatomic, weak) UIViewController * viewController;
@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic) BOOL mInteractionInProgress;

@property (nonatomic) BouncingState currentBouncingState;
@property (nonatomic) ScrollDrirection currentScrollDirection;

@property (nonatomic) BOOL canBouncing;
@property (nonatomic) BOOL scrollViewDecelerating;
@property (nonatomic) NSInteger scrollingWithHighSpeed; // 0: slow speed, 1: fast to top, 2: fast to bottom
@property (nonatomic) NSUInteger bouncingThreadhold;
@property (nonatomic) NSUInteger scrollSpeedThreadhold;
@property (nonatomic) CGFloat fullHeightForProcess;

@property (nonatomic) CGFloat beforeScrollTableViewOffset;
@property (nonatomic) CGFloat currentPanAmount;
@property (nonatomic) CGFloat lastDeleceratingOffset;
@property (nonatomic) CGFloat deceleratingOffsetAmount;

@end

@implementation ScrollViewInteractiveActions

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewController = nil;
        self.scrollView = nil;
        self.canBouncing = NO;
        self.currentPanAmount = 0;
        self.bouncingThreadhold = 250;
        self.scrollSpeedThreadhold = 1000;
        self.mInteractionInProgress = NO;
        self.scrollViewDecelerating = NO;
        self.interactiveWhenDecelerating = YES;
        self.beforeScrollTableViewOffset = 0;
        self.currentBouncingState = BouncingStateNone;
    }
    return self;
}

- (instancetype)initForViewController:(UIViewController *)controller andScrollView:(UIScrollView *)scrollView {
    self = [self init];
    if (self) {
        self.viewController = controller;
        self.scrollView = scrollView;
        self.fullHeightForProcess = controller.view.frame.size.height;

        [self.scrollView.panGestureRecognizer addTarget:self action:@selector(panGestureCallback:)];
    }
    return self;
}

- (void)setTopBouncingAction:(SwipeInterativeObject *)action {
    self.actionBouncingTop = action;
    self.actionBouncingTop.interative = self;
}

- (void)setBottomBouncingAction:(SwipeInterativeObject *)action {
    self.actionBouncingBottom = action;
    self.actionBouncingBottom.interative = self;
}

- (void)startBouncingAction:(SwipeInterativeObject *)action {
    
    if (action && !self.mInteractionInProgress) {
        
        BOOL allowStart = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewInteractiveActions:startAction:)]) {
            allowStart = [self.delegate scrollViewInteractiveActions:self startAction:action];
        }
        
        if (allowStart) {
            self.mInteractionInProgress = YES;
            [action excuteAction];
        }
    }
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    
    if (self.mInteractionInProgress) {
        [super updateInteractiveTransition:percentComplete];
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewInteractiveActions:transferingAction:withProcess:)]) {
            [self.delegate scrollViewInteractiveActions:self transferingAction:[self getCurrentAction] withProcess:percentComplete];
        }
    }
}

- (void)endInteractiveWithSuccess:(BOOL)success {
    
    if (!self.mInteractionInProgress) {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewInteractiveActions:endAction:success:)]) {
        [self.delegate scrollViewInteractiveActions:self endAction:[self getCurrentAction] success:success];
    }
    
    if (success) {
        [self finishInteractiveTransition];
    } else {
        [self cancelInteractiveTransition];
    }
    self.currentBouncingState = BouncingStateNone;
    self.mInteractionInProgress = NO;
    self.scrollViewDecelerating = NO;
    self.canBouncing = NO;
}

- (BOOL)interactionInProgress {
    return self.mInteractionInProgress;
}

- (CGFloat)topBaseValueForScrollView:(UIScrollView *)scrollView {
    return -scrollView.contentInset.top;
}

- (CGFloat)bottomBaseValueForScrollView:(UIScrollView *)scrollView {
    return (scrollView.contentSize.height - scrollView.bounds.size.height) + scrollView.contentInset.bottom;
}

- (SwipeInterativeObject *)getCurrentAction {
    
    if (!self.mInteractionInProgress) {
        return nil;
    }
    
    if (self.currentBouncingState == BouncingStateTop) return self.actionBouncingTop;
    else if (self.currentBouncingState == BouncingStateBottom) return self.actionBouncingBottom;
    else return nil;
}

#pragma mark - UIPanGestureCallBack

- (void)panGestureCallback:(UIPanGestureRecognizer *)gesture {
    
    CGPoint velocityPoint = [gesture velocityInView:self.viewController.view];
    CGPoint translationPoint = [gesture translationInView:self.viewController.view];
    
    // For detect scrolling speed
    if (velocityPoint.y > self.scrollingWithHighSpeed) {
        // To top
        self.scrollingWithHighSpeed = 1;
        
    } else if (-velocityPoint.y > self.scrollingWithHighSpeed) {
        // To bottom
        self.scrollingWithHighSpeed = 2;
        
    } else {
        self.scrollingWithHighSpeed = 0;
    }
    
    if (fabs(velocityPoint.y) > fabs(velocityPoint.x)) {
        // User swipe along vertical axis
        if (velocityPoint.y > 0) {
            // User swipe to down
            self.currentScrollDirection = ScrollDrirectionDown;
        } else {
            // User swipe to up
            self.currentScrollDirection = ScrollDrirectionUp;
        }
    }
    self.currentPanAmount = translationPoint.y;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.beforeScrollTableViewOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    switch (scrollView.panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            [self checkCurrentStateOfScrollView:scrollView];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self checkCurrentStateOfScrollView:scrollView];
            [self checkOffsetChangeAndActionScrollView:scrollView];
            break;
        }
        case UIGestureRecognizerStatePossible: {
            // Decelerating state
            if (self.scrollViewDecelerating) {
                [self checkDeceleratingStateOfScrollView:scrollView];
            }
        }
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // imposible case, will not happen, check dragging event instead
            break;
        }
        default:
            break;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self checkEndStateOffsetChangedOfScrollView:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // Case: when user is not boucing, they release thier finger then scroll view scroll to top with bouncing
    // We need to do a hack to detect change of scroll view offset
    self.scrollViewDecelerating = YES;
    self.deceleratingOffsetAmount = 0;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Scroll view completely stop!
    [self checkEndStateOffsetChangedOfScrollView:scrollView];
    self.scrollViewDecelerating = NO;
}

#pragma mark - State change checker

- (void)checkCurrentStateOfScrollView:(UIScrollView *)scrollView {
    
    BOOL bouncingTop = self.beforeScrollTableViewOffset - self.currentPanAmount < [self topBaseValueForScrollView:scrollView];
    BOOL bouncingBottom = self.beforeScrollTableViewOffset + (-self.currentPanAmount) > [self bottomBaseValueForScrollView:scrollView];
    
    if (self.currentBouncingState != BouncingStateNone) {
        CGFloat amountTop = self.beforeScrollTableViewOffset - self.currentPanAmount + [self topBaseValueForScrollView:scrollView];
        CGFloat amountBottom = self.beforeScrollTableViewOffset + (-self.currentPanAmount) - [self bottomBaseValueForScrollView:scrollView];
        bouncingTop = bouncingTop || (amountTop < 0 && self.currentScrollDirection == ScrollDrirectionDown);
        bouncingBottom = bouncingBottom || (amountBottom > 0 && self.currentScrollDirection == ScrollDrirectionUp);
    }
    
    if (bouncingTop) {
        self.currentBouncingState = BouncingStateTop;
        if (!self.mInteractionInProgress) {
            // On scroll view offset changing and we just want to check state, not start action
            [self startBouncingAction:self.actionBouncingTop];
        }
    } else if (bouncingBottom) {
        self.currentBouncingState = BouncingStateBottom;
        if (!self.mInteractionInProgress) {
            // On scroll view offset changing and we just want to check state, not start action
            [self startBouncingAction:self.actionBouncingBottom];
        }
    } else {
        self.currentBouncingState = BouncingStateNone;
    }
}

- (void)checkOffsetChangeAndActionScrollView:(UIScrollView *)scrollView {
    
    if (self.currentBouncingState != BouncingStateNone
        && self.mInteractionInProgress /* Interactive action started */) {
        
        // Prevent from boucing for interactive action
        if (self.currentBouncingState == BouncingStateTop) {
            [scrollView setContentOffset:CGPointMake(0, [self topBaseValueForScrollView:scrollView])];
        } else if (self.currentBouncingState == BouncingStateBottom){
            [scrollView setContentOffset:CGPointMake(0, [self bottomBaseValueForScrollView:scrollView])];
        }
        
        // Calculate process amount, if user started scrolling with BouncingStateNone to Bouncing state
        // We need to calculate delta bounce among for process
        CGFloat bouncingAmount = 0;
        if (self.currentBouncingState == BouncingStateTop) {
            bouncingAmount = self.currentPanAmount - self.beforeScrollTableViewOffset + [self topBaseValueForScrollView:scrollView];
        } else if (self.currentBouncingState == BouncingStateBottom) {
            CGFloat bottomDistance = [self bottomBaseValueForScrollView:scrollView] - self.beforeScrollTableViewOffset;
            bouncingAmount = -self.currentPanAmount - bottomDistance;
        }
        
        self.canBouncing = fabs(bouncingAmount) >= self.bouncingThreadhold;
        if (self.currentBouncingState == BouncingStateTop) {
            
            // When user is nearly top, they scroll quickly to bottom, this case is needed for start translation too
//            BOOL scrollHighSpeedToTop = self.scrollingWithHighSpeed == 1 && self.beforeScrollTableViewOffset < 200;
//            if (scrollHighSpeedToTop) {
//                [self endInteractiveWithSuccess:YES];
//            }
            
        } else if (self.currentBouncingState == BouncingStateBottom) {
            
            // When user is nearly bottom, they scroll quickly to top, this case is needed for start translation too
//            CGFloat bottomDistance = (scrollView.contentSize.height - scrollView.bounds.size.height) - self.beforeScrollTableViewOffset;
//            BOOL scrollHighSpeedToBottom = self.scrollingWithHighSpeed == 2 && bottomDistance < 200;
//            if (scrollHighSpeedToBottom) {
//                [self endInteractiveWithSuccess:YES];
//            }
        }
        
        CGFloat process = fabs(bouncingAmount) / self.fullHeightForProcess;
        [self updateInteractiveTransition:process];
    }
}

- (void)checkDeceleratingStateOfScrollView:(UIScrollView *)scrollView {
    
    // Decelerating is very different from scrolling events, so we need to handle it by hand
    
    if (!self.interactiveWhenDecelerating) {
        return;
    }
    
    self.deceleratingOffsetAmount = scrollView.contentOffset.y;
    
    BOOL bouncingTop = self.deceleratingOffsetAmount < [self topBaseValueForScrollView:scrollView];
    BOOL bouncingBottom = self.deceleratingOffsetAmount > [self bottomBaseValueForScrollView:scrollView];
    
    if (bouncingTop && !self.mInteractionInProgress) {
        self.currentBouncingState = BouncingStateTop;
        if (!self.mInteractionInProgress) {
            [self startBouncingAction:self.actionBouncingTop];
        }
    } else if (bouncingBottom && !self.mInteractionInProgress) {
        self.currentBouncingState = BouncingStateBottom;
        if (!self.mInteractionInProgress) {
            [self startBouncingAction:self.actionBouncingBottom];
        }
    }
    
    CGFloat process = 0;
    if (bouncingTop) {
        process = (-self.deceleratingOffsetAmount + [self topBaseValueForScrollView:scrollView])/ self.bouncingThreadhold;
        [self updateInteractiveTransition:process*0.8];
    } else if (bouncingBottom) {
        process = (self.deceleratingOffsetAmount - [self bottomBaseValueForScrollView:scrollView]) / self.bouncingThreadhold;
        [self updateInteractiveTransition:process*0.8];
    }
    
    // If the decelerating reach it max process, we need to cancel interactive transition
    // This is nececcery for user when they want to interact with the scrollview during it is decelerating
//    CGFloat delta = 0;
//    BOOL isIncreasing = YES;
//    if (self.currentBouncingState == BouncingStateNone) {
//        self.lastDeleceratingOffset = self.deceleratingOffsetAmount;
//    } else {
//        delta = self.deceleratingOffsetAmount - self.lastDeleceratingOffset;
//        self.lastDeleceratingOffset = self.deceleratingOffsetAmount;
//        if (self.currentBouncingState == BouncingStateTop) {
//            isIncreasing = delta > 0;
//        } else if (self.currentBouncingState == BouncingStateBottom) {
//            isIncreasing = delta < 0;
//        }
//    }
//
//    if (!isIncreasing) {
//        if (self.mInteractionInProgress) {
//            [self endInteractiveWithSuccess:NO];
//        }
//    }
}

- (void)checkEndStateOffsetChangedOfScrollView:(UIScrollView *)scrollView {
    if (self.mInteractionInProgress) {
        [self endInteractiveWithSuccess:self.canBouncing];
    } else {
        self.currentBouncingState = BouncingStateNone;
    }
}

@end
