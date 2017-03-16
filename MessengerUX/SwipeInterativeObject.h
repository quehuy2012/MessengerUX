//
//  SwipeInterativeObject.h
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeInterativeObject : NSObject

@property (nonatomic) UIPercentDrivenInteractiveTransition * interative;

- (instancetype)initPresentViewController:(UIViewController *)presentViewController
                       fromViewController:(UIViewController *)viewController
                            withAnimation:(id<UIViewControllerAnimatedTransitioning>)animator;

- (instancetype)initDismisViewController:(UIViewController *)dismissViewController
                           withAnimation:(id<UIViewControllerAnimatedTransitioning>)animator;

- (void)excuteAction;

@end
