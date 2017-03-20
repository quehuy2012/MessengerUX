//
//  HomeViewController.m
//  MessengerUX
//
//  Created by CPU11808 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "HomeViewController.h"
#import <NITableViewModel.h>
#import <NITableViewActions.h>
#import <NICellFactory.h>
#import <NICellCatalog.h>
#import "InterativeTranslation.h"
#import "CameraViewController.h"

@interface HomeViewController () <UITableViewDelegate, ScrollViewInteractiveActionsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NITableViewModel *model;
@property (nonatomic) NITableViewActions *action;

@property (nonatomic) ScrollViewInteractiveActions * interactiveActions;

@end

@implementation HomeViewController

+ (instancetype)viewControllerWithName:(NSString *)name {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    HomeViewController * tab = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    tab.tabBarItem.title = name;
    tab.tabBarItem.image = [UIImage imageNamed:@"homeTabIconNormal"];
    tab.tabBarItem.selectedImage = [UIImage imageNamed:@"homeTabIconSelected"];
    return tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initTableView];
    
    [self initTableViewInteractiveAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)initTableView {
    UIImage *image = [UIImage imageNamed:@"personImage"];
    NSMutableArray *arr = [NSMutableArray new];
    
    for (char c = '0'; c <= 'Z'; c++) {
        NSString *name = [NSString stringWithFormat:@"Person %c", c];
        NSString *profileID = [NSString stringWithFormat:@"@text_%c", c];
        
        NISubtitleCellObject *cellObject = [[NISubtitleCellObject alloc] initWithTitle:name subtitle:profileID image:image];

        [arr addObject:cellObject];
    }
    
    self.model = [[NITableViewModel alloc] initWithListArray:arr delegate:(id)[NICellFactory class]];
    self.tableView.dataSource = self.model;
    
}

- (void)initTableViewInteractiveAction {
    self.interactiveActions = [[ScrollViewInteractiveActions alloc] initForViewController:self andScrollView:self.tableView];
    
    CameraViewController * cameraVC = [CameraViewController viewController];
    
    StackTrainsitionAnimator * cameraPresentAnimator = [StackTrainsitionAnimator animationWithOption:AnimateOptionToDown
                                                                                 forPresentionOption:PresentingOptionWillShow];
    SwipeInterativeObject * bottomPresentAction = [[SwipeInterativeObject alloc] initPresentViewController:cameraVC fromViewController:self withAnimation:cameraPresentAnimator];
    [self.interactiveActions setTopBouncingAction:bottomPresentAction];
    
    
    CameraViewController * cameraVC2 = [CameraViewController viewController];
    StackTrainsitionAnimator * cameraPresentAnimator2 = [StackTrainsitionAnimator animationWithOption:AnimateOptionToUp
                                                                                  forPresentionOption:PresentingOptionWillShow];
    SwipeInterativeObject * bottomPresentAction2 = [[SwipeInterativeObject alloc] initPresentViewController:cameraVC2 fromViewController:self withAnimation:cameraPresentAnimator2];
    [self.interactiveActions setBottomBouncingAction:bottomPresentAction2];
    
    self.interactiveActions.interactiveWhenDecelerating = YES;
    
    self.interactiveActions.delegate = self;
}

#pragma mark - ScrollViewInteractiveActionsDelegate

- (BOOL)scrollViewInteractiveActions:(ScrollViewInteractiveActions *)interactiveActions startAction:(SwipeInterativeObject *)action {
    return YES;
}

- (void)scrollViewInteractiveActions:(ScrollViewInteractiveActions *)interactiveActions transferingAction:(SwipeInterativeObject *)action withProcess:(CGFloat)process {
    
    if (process > 0.4) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    } else if ([UIApplication sharedApplication].isStatusBarHidden){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
}

- (void)scrollViewInteractiveActions:(ScrollViewInteractiveActions *)interactiveActions endAction:(SwipeInterativeObject *)action success:(BOOL)success {
    
}

@end
