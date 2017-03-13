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

@interface PeopleViewController () <UITableViewDelegate>

@property (nonatomic) NITableViewModel *model;
@property (nonatomic) NITableViewActions *action;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.action = [[NITableViewActions alloc] initWithTarget:self];
    NSArray *arr = @[[_action attachToObject:[NISubtitleCellObject objectWithTitle:@"Person A" subtitle:@"@persona" image:[UIImage imageNamed:@"personImage"]] tapBlock:nil],
                     [_action attachToObject:[NISubtitleCellObject objectWithTitle:@"Person B" subtitle:@"@personb" image:[UIImage imageNamed:@"personImage"]] tapBlock:nil],
                     [_action attachToObject:[NISubtitleCellObject objectWithTitle:@"Person C" subtitle:@"@personc" image:[UIImage imageNamed:@"personImage"]] tapBlock:nil],
                     [_action attachToObject:[NISubtitleCellObject objectWithTitle:@"Person D" subtitle:@"@persond" image:[UIImage imageNamed:@"personImage"]] tapBlock:nil]];
    
    self.model = [[NITableViewModel alloc] initWithListArray:arr delegate:(id)[NICellFactory class]];
    self.model.delegate = (id)[NICellFactory class];
    
    self.tableView.dataSource = self.model;
    self.tableView.delegate = [_action forwardingTo:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)viewControllerWithName:(NSString *)name andImage:(UIImage *)image {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"People" bundle:nil];
    PeopleViewController * tab = [storyboard instantiateViewControllerWithIdentifier:@"PeopleViewController"];
    
    tab.tabBarItem.title = name;
    tab.tabBarItem.image = image;
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
