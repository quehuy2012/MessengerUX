//
//  SwipeInterativeObject.h
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransitionAnimator;
@class SwipeInteractiveActions;

@interface SwipeInterativeObject : NSObject

@property (nonatomic) SwipeInteractiveActions * interative;

- (instancetype)initPresentViewController:(UIViewController *)presentViewController
                       fromViewController:(UIViewController *)viewController
                            withAnimation:(TransitionAnimator *)animator;

- (instancetype)initDismisViewController:(UIViewController *)dismissViewController
                           withAnimation:(TransitionAnimator *)animator;

- (void)excuteAction;

@end
