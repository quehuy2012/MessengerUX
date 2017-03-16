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
@property (nonatomic) CGFloat fullHeightForProcess;
@property (nonatomic) NSUInteger bouncingThreadhold;

@property (nonatomic) CGFloat beforeScrollTableViewOffset;
@property (nonatomic) CGFloat currentPanAmount;

@end

@implementation ScrollViewInteractiveActions

- (instancetype)init {
    self = [super init];
    if (self) {
        self.viewController = nil;
        self.scrollView = nil;
        self.canBouncing = NO;
        self.currentPanAmount = 0;
        self.bouncingThreadhold = 300;
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
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        self.scrollView.delegate = self;
        self.scrollView.decelerationRate = 1.2;
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
    
    if (!self.mInteractionInProgress) {
        return;
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

#pragma mark - UIPanGestureCallBack

- (void)panGestureCallback:(UIPanGestureRecognizer *)gesture {
    CGPoint velocityPoint = [gesture velocityInView:self.viewController.view];
    CGPoint translationPoint = [gesture translationInView:self.viewController.view];
    
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([@"contentOffset" compare:keyPath] == NSOrderedSame && self.interactiveWhenDecelerating) {

        UIScrollView * scrollView = object;
        
        BOOL bouncingTop = scrollView.contentOffset.y < 0;
        BOOL bouncingBottom = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.bounds.size.height) > 0;
        
        if (bouncingTop && !self.mInteractionInProgress) {
            self.currentBouncingState = BouncingStateTop;
            [self startBouncingAction:self.actionBouncingTop];
        } else if (bouncingBottom && !self.mInteractionInProgress) {
            self.currentBouncingState = BouncingStateBottom;
            [self startBouncingAction:self.actionBouncingBottom];
        }
        
        CGFloat process = 0;
        
        if (bouncingTop) {
            process = -scrollView.contentOffset.y / self.bouncingThreadhold;
            [self updateInteractiveTransition:process];
            
        } else if (bouncingBottom) {
            process = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.bounds.size.height)) / self.bouncingThreadhold;
            [self updateInteractiveTransition:process];
        }
    }
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

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    
    
    NSLog(@"vel %f tar %f rate %f cur %f", velocity.y, targetContentOffset->y, scrollView.decelerationRate, scrollView.contentOffset.y);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self checkEndStateOffsetChangedOfScrollView:scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    // Case: when user is not boucing, they release thier finger then scroll view scroll to top with bouncing
    // We need to do a hack to detect change of scroll view offset
    self.scrollViewDecelerating = YES;
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Scroll view completely stop!
    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self checkEndStateOffsetChangedOfScrollView:scrollView];
    self.scrollViewDecelerating = NO;
}

#pragma mark - State change checker

- (void)checkCurrentStateOfScrollView:(UIScrollView *)scrollView {
    BOOL bouncingTop = self.beforeScrollTableViewOffset - self.currentPanAmount < 0;
    BOOL bouncingBottom = self.beforeScrollTableViewOffset + (-self.currentPanAmount) > (scrollView.contentSize.height - scrollView.bounds.size.height);
    
    if (self.currentBouncingState != BouncingStateNone) {
        CGFloat amountTop = self.beforeScrollTableViewOffset - self.currentPanAmount;
        CGFloat amountBottom = self.beforeScrollTableViewOffset + (-self.currentPanAmount) - (scrollView.contentSize.height - scrollView.bounds.size.height);
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
            [scrollView setContentOffset:CGPointMake(0, 0)];
        } else if (self.currentBouncingState == BouncingStateBottom){
            [scrollView setContentOffset:CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height)];
        }
        
        self.canBouncing = fabs(self.currentPanAmount) >= self.bouncingThreadhold;
        CGFloat process = fabs(self.currentPanAmount) / self.fullHeightForProcess;
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
