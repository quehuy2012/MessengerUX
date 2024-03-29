//
//  PeopleViewController.m
//  MessengerUX
//
//  Created by CPU11808 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "PeopleViewController.h"
#import <NITableViewModel.h>
#import <NITableViewActions.h>
#import <NICellCatalog.h>
#import <NICellFactory.h>

#import "TestTableModelViewController.h"

@interface PeopleViewController () <UITableViewDelegate>

@property (nonatomic) NITableViewModel *model;
@property (nonatomic) NITableViewActions *action;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PeopleViewController

+ (instancetype)viewControllerWithName:(NSString *)name {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"People" bundle:nil];
    PeopleViewController * tab = [storyboard instantiateViewControllerWithIdentifier:@"PeopleViewController"];
    
    tab.tabBarItem.title = name;
    tab.tabBarItem.image = [UIImage imageNamed:@"peopleTabIconNormal"];
    tab.tabBarItem.selectedImage = [UIImage imageNamed:@"peopleTabIconSelected"];
    return tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView {
 
    UIImage *image = [UIImage imageNamed:@"personImage"];
    NSMutableArray *arr = [NSMutableArray new];

    for (char c = 'A'; c <= 'Z'; c++) {
        NSString *name = [NSString stringWithFormat:@"Person %c", c];
        NSString *profileID = [NSString stringWithFormat:@"@person_%c", c];
        
        NISubtitleCellObject *cellObject = [[NISubtitleCellObject alloc] initWithTitle:name subtitle:profileID image:image];
     
        [arr addObject:cellObject];
    }
    
    self.model = [[NITableViewModel alloc] initWithListArray:arr delegate:(id)[NICellFactory class]];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    TestTableModelViewController * testVC = [TestTableModelViewController viewController];
    UINavigationController * testNav = [[UINavigationController alloc] initWithRootViewController:testVC];
    [self presentViewController:testNav animated:YES completion:nil];
}

@end
