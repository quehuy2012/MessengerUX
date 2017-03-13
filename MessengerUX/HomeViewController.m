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

@interface HomeViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NITableViewModel *model;
@property (nonatomic) NITableViewActions *action;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.action = [[NITableViewActions alloc] initWithTarget:self];
    NSArray *arr = @[[_action attachToObject:[NITitleCellObject objectWithTitle:@"Hi,"] tapBlock:nil],
                     [_action attachToObject:[NITitleCellObject objectWithTitle:@"What"] tapBlock:nil],
                     [_action attachToObject:[NITitleCellObject objectWithTitle:@"is"] tapBlock:nil],
                     [_action attachToObject:[NITitleCellObject objectWithTitle:@"your"] tapBlock:nil],
                     [_action attachToObject:[NITitleCellObject objectWithTitle:@"name"] tapBlock:nil],
                     [_action attachToObject:[NITitleCellObject objectWithTitle:@"?"] tapBlock:nil]];
    
    self.model = [[NITableViewModel alloc] initWithListArray:arr delegate:(id)[NICellFactory class]];
    self.model.delegate = (id)[NICellFactory class];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [_action forwardingTo:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (instancetype)viewControllerWithName:(NSString *)name {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    HomeViewController * tab = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    tab.tabBarItem.title = name;
    tab.tabBarItem.image = [UIImage imageNamed:@"homeTabIconNormal"];
    tab.tabBarItem.selectedImage = [UIImage imageNamed:@"homeTabIconSelected"];
    return tab;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
