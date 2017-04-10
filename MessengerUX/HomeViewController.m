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
#import "ConversationViewController.h"

@interface HomeViewController () <UITableViewDelegate, ScrollViewInteractiveActionsDelegate, UITableViewDelegate>

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
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self initTableView];
    
    [self initTableViewInteractiveAction];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
    
    self.tableView.delegate = self;
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

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.interactiveActions scrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.interactiveActions scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.interactiveActions scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.interactiveActions scrollViewWillBeginDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.interactiveActions scrollViewDidEndDecelerating:scrollView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    ConversationViewController * chatVC = [ConversationViewController viewController];
    UINavigationController * chatNav = [[UINavigationController alloc] initWithRootViewController:chatVC];
    [self presentViewController:chatNav animated:YES completion:nil];
    chatNav = nil;
    chatVC = nil;
}

#pragma mark - ScrollViewInteractiveActionsDelegate

- (BOOL)scrollViewInteractiveActions:(ScrollViewInteractiveActions *)interactiveActions startAction:(SwipeInterativeObject *)action {
    return YES;
}

- (void)scrollViewInteractiveActions:(ScrollViewInteractiveActions *)interactiveActions transferingAction:(SwipeInterativeObject *)action withProcess:(CGFloat)process {
    
    if (process > 0.3) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    } else if ([UIApplication sharedApplication].isStatusBarHidden){
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
}

- (void)scrollViewInteractiveActions:(ScrollViewInteractiveActions *)interactiveActions endAction:(SwipeInterativeObject *)action success:(BOOL)success {
    
}

@end
