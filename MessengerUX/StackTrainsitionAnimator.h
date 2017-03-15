//
//  StackTrainsitionAnimator.h
//  MessengerUX
//
//  Created by CPU11815 on 3/10/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionAnimator.h"


@interface StackTrainsitionAnimator : TransitionAnimator

+ (instancetype)animationWithOption:(AnimateOption)animOption forPresentionOption:(PresentingOption)presentingOption;

@end
