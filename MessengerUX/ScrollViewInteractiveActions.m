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
@property (nonatomic) BOOL mInteractionInProgress;

@property (nonatomic) BouncingState currentBouncingState;
@property (nonatomic) ScrollDrirection currentScrollDirection;

@property (nonatomic) BOOL canBouncing;
@property (nonatomic) BOOL scrollViewDecelerating;
@property (nonatomic) CGFloat currentBouncingAmong;
@property (nonatomic) CGFloat fullHeightForProcess;
@property (nonatomic) CGFloat lastYOffset;
@property (nonatomic) NSUInteger bouncingThreadhold;

@end

@implementation ScrollViewInteractiveActions

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewController = nil;
        self.currentBouncingState = BouncingStateNone;
        self.mInteractionInProgress = NO;
        self.scrollViewDecelerating = NO;
        self.canBouncing = NO;
        self.bouncingThreadhold = 300;
        self.currentBouncingAmong = 0;
        self.lastYOffset = 0;
    }
    return self;
}

- (instancetype)initForViewController:(UIViewController *)controller {
    self = [self init];
    if (self) {
        self.viewController = controller;
        self.fullHeightForProcess = controller.view.frame.size.height;
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
    if (action) {
        self.mInteractionInProgress = YES;
        [action excuteAction];
    }
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    if (self.mInteractionInProgress) {
        [super updateInteractiveTransition:percentComplete];
    }
}

- (void)endInteractiveWithSuccess:(BOOL)success {
    if (success) {
        [self finishInteractiveTransition];
    } else {
        [self cancelInteractiveTransition];
    }
    self.currentBouncingState = BouncingStateNone;
    self.mInteractionInProgress = NO;
    self.scrollViewDecelerating = NO;
    self.canBouncing = NO;
    self.currentBouncingAmong = 0;
    self.lastYOffset = 0;
}

- (BOOL)interactionInProgress {
    return self.mInteractionInProgress;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat currentYOffset = scrollView.contentOffset.y;
    
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
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            // imposible case, will not happen, check dragging event instead
            break;
        }
        default:
            break;
    }
    self.lastYOffset = currentYOffset;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate) {
        
    } else {
        [self checkEndStateOffsetChangedOfScrollView:scrollView];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // Case: when user is not boucing, they release thier finger then scroll view scroll to top with bouncing
    // We need to do a hack to detect change of scroll view offset
//    NSLog(@"start decel %f", scrollView.contentOffset.y);
//    self.scrollViewDecelerating = YES;
//    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Scroll view completely stop!
//    NSLog(@"end decel %f", scrollView.contentOffset.y);
//    self.lastYOffset = scrollView.contentOffset.y;
//    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
//    [self checkEndStateOffsetChangedOfScrollView:scrollView];
//    self.scrollViewDecelerating = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([@"contentOffset" compare:keyPath] == NSOrderedSame) {
        UIScrollView * scrollView = object;
        
        BOOL bouncingTop = scrollView.contentOffset.y < 0;
        BOOL bouncingBottom = scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.size.height);
        if (bouncingTop) {
            self.currentBouncingAmong = scrollView.contentOffset.y;
            if (!self.mInteractionInProgress) {
                // On scroll view offset changing and we just want to check state, not start action
                [self startBouncingAction:self.actionBouncingTop];
            }
        } else if (bouncingBottom){
            self.currentBouncingAmong = scrollView.contentOffset.y;
            if (!self.mInteractionInProgress) {
                // On scroll view offset changing and we just want to check state, not start action
                [self startBouncingAction:self.actionBouncingTop];
            }
        }
        
        if (bouncingTop || bouncingBottom) {
            self.canBouncing = fabs(self.currentBouncingAmong) >= self.bouncingThreadhold;
            CGFloat process = fabs(self.currentBouncingAmong) / self.fullHeightForProcess;
            [self updateInteractiveTransition:process];
        }
    }
}

#pragma mark - State change checker

- (void)checkCurrentStateOfScrollView:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y - self.lastYOffset == 0) {
        self.currentScrollDirection = ScrollDrirectionStill;
    } else if (scrollView.contentOffset.y - self.lastYOffset < 0) {
        self.currentScrollDirection = ScrollDrirectionUp;
    } else if (scrollView.contentOffset.y - self.lastYOffset > 0){
        self.currentScrollDirection = ScrollDrirectionDown;
    }
    
    BOOL bouncingTop = scrollView.contentOffset.y < 0
                        || (self.currentBouncingAmong < 0 && self.currentScrollDirection == ScrollDrirectionDown);
    BOOL bouncingBottom = scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.bounds.size.height)
                        || (self.currentBouncingAmong > 0 && self.currentScrollDirection == ScrollDrirectionUp);
    
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
            self.currentBouncingAmong += scrollView.contentOffset.y;
            [scrollView setContentOffset:CGPointMake(0, 0)];
        } else if (self.currentBouncingState == BouncingStateBottom){
            CGFloat val = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.bounds.size.height);
            self.currentBouncingAmong += val;
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height)];
        }
        
        self.canBouncing = fabs(self.currentBouncingAmong) >= self.bouncingThreadhold;
        
        CGFloat process = fabs(self.currentBouncingAmong) / self.fullHeightForProcess;
        [self updateInteractiveTransition:process];
    }
}

- (void)checkEndStateOffsetChangedOfScrollView:(UIScrollView *)scrollView {
    if (self.mInteractionInProgress) {
        [self endInteractiveWithSuccess:self.canBouncing];
    } else {
        self.currentBouncingState = BouncingStateNone;
    }
}

@end
