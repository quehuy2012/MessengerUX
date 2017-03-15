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

@interface HomeViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NITableViewModel *model;
@property (nonatomic) NITableViewActions *action;

@property (nonatomic) TableViewInteractiveActions * interactiveActions;

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
    
    [self initTableView];
    
    [self initTableViewInteractiveAction];
}

- (void)initTableView {
    UIImage *image = [UIImage imageNamed:@"personImage"];
    NSMutableArray *arr = [NSMutableArray new];
    
    for (char c = 'A'; c <= 'Z'; c++) {
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
    self.interactiveActions = [[TableViewInteractiveActions alloc] initForViewController:self];
    
    CameraViewController * cameraVC = [CameraViewController viewController];
    
    StackTrainsitionAnimator * cameraPresentAnimator = [StackTrainsitionAnimator animationWithOption:AnimateOptionToDown
                                                                                 forPresentionOption:PresentingOptionWillShow];
    SwipeInterativeObject * bottomPresentAction = [[SwipeInterativeObject alloc] initPresentViewController:cameraVC fromViewController:self withAnimation:cameraPresentAnimator];
    [self.interactiveActions setTopBoucingAction:bottomPresentAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.interactiveActions scrollViewDidScroll:scrollView];
}

@end
