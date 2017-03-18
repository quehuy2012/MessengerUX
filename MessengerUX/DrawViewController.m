//
//  DrawViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "DrawViewController.h"
#import "InterativeTranslation.h"

#import "UIView+AutoLayout.h"

@interface DrawViewController ()

@property (nonatomic) SwipeInteractiveActions * swipeActions;

@end

@implementation DrawViewController

+ (instancetype)viewController {
    DrawViewController * retsult = [[DrawViewController alloc] init];
    return retsult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drawThumb"]];
    [self.view addSubview:imageView];
    
    [imageView atLeadingWith:self.view value:0];
    [imageView atTrailingWith:self.view value:0];
    [imageView atTopingWith:self.view value:0];
    [imageView atBottomingWith:self.view value:0];
    
    [self addSwipeNavigation];
}

- (void)addSwipeNavigation {
    
    self.swipeActions = [[SwipeInteractiveActions alloc] initWithController:self];
    
    ScrollTransitionAnimator * drawDismissAnimator = [ScrollTransitionAnimator animationWithOption:AnimateOptionToRight
                                                                               forPresentionOption:PresentingOptionWillHide];
    SwipeInterativeObject * rightPresentAction = [[SwipeInterativeObject alloc] initDismisViewController:self
                                                                                           withAnimation:drawDismissAnimator];
    
    [self.swipeActions setRightAction:rightPresentAction];
}

@end
