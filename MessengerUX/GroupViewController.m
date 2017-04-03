//
//  GroupViewController.m
//  MessengerUX
//
//  Created by CPU11808 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "GroupViewController.h"
#import <NITableViewModel.h>
#import <NITableViewActions.h>
#import <NICellCatalog.h>
#import <NICellFactory.h>

#import "TestModelViewController.h"

@interface GroupViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NITableViewModel *model;
@property (nonatomic) NITableViewActions *action;

@end

@implementation GroupViewController

+ (instancetype)viewControllerWithName:(NSString *)name {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    GroupViewController * tab = [storyboard instantiateViewControllerWithIdentifier:@"GroupViewController"];
    
    tab.tabBarItem.title = name;
    tab.tabBarItem.image = [UIImage imageNamed:@"groupTabIconNormal"];
    tab.tabBarItem.selectedImage = [UIImage imageNamed:@"groupTabIconSelected"];
    return tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)initTableView {
 
    UIImage *image = [UIImage imageNamed:@"groupImage"];
    NSMutableArray *arr = [NSMutableArray new];
    
    for (char c = 'A'; c <= 'Z'; c++) {
        NSString *name = [NSString stringWithFormat:@"Group %c", c];
        NSString *profileID = [NSString stringWithFormat:@"@group_%c", c];
        
        NISubtitleCellObject *cellObject = [[NISubtitleCellObject alloc] initWithTitle:name subtitle:profileID image:image];

        [arr addObject:cellObject];
    }
    
    self.model = [[NITableViewModel alloc] initWithListArray:arr delegate:(id)[NICellFactory class]];
    self.tableView.dataSource = self.model;
    
    self.tableView.delegate = self;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TestModelViewController * testVC = [TestModelViewController viewController];
    UINavigationController * testNav = [[UINavigationController alloc] initWithRootViewController:testVC];
    [self presentViewController:testNav animated:YES completion:nil];
}

@end
