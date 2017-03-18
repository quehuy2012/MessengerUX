//
//  GalleryViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "GalleryViewController.h"
#import "InterativeTranslation.h"

#import "UIView+AutoLayout.h"

@interface GalleryViewController ()

@property (nonatomic) SwipeInteractiveActions * swipeActions;

@end

@implementation GalleryViewController

+ (instancetype)viewController {
    GalleryViewController * retsult = [[GalleryViewController alloc] init];
    return retsult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"galleryThumb"]];
    [self.view addSubview:imageView];
    
    [imageView atLeadingWith:self.view value:0];
    [imageView atTrailingWith:self.view value:0];
    [imageView atTopingWith:self.view value:0];
    [imageView atBottomingWith:self.view value:0];
    
    [self addSwipeNavigation];
}

- (void)addSwipeNavigation {
    
    self.swipeActions = [[SwipeInteractiveActions alloc] initWithController:self];
    
    ScrollTransitionAnimator * galleryDismissAnimator = [ScrollTransitionAnimator animationWithOption:AnimateOptionToLeft
                                                                                  forPresentionOption:PresentingOptionWillHide];
    
    SwipeInterativeObject * leftPresentAction = [[SwipeInterativeObject alloc] initDismisViewController:self
                                                                                          withAnimation:galleryDismissAnimator];
    [self.swipeActions setLeftAction:leftPresentAction];
}

@end
