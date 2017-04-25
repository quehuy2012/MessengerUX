//
//  ScrollTransitionAnimator.h
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "TransitionAnimator.h"

@interface ScrollTransitionAnimator : TransitionAnimator

+ (instancetype)animationWithOption:(AnimateOption)animOption forPresentionOption:(PresentingOption)presentingOption;

@end
