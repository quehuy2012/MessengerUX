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
    
    NSArray *arr = @[[NISubtitleCellObject objectWithTitle:@"Person A" subtitle:@"@person_a" image:[UIImage imageNamed:@"personImage"]],
                     [NISubtitleCellObject objectWithTitle:@"Person B" subtitle:@"@person_b" image:[UIImage imageNamed:@"personImage"]],
                     [NISubtitleCellObject objectWithTitle:@"Person C" subtitle:@"@person_c" image:[UIImage imageNamed:@"personImage"]],
                     [NISubtitleCellObject objectWithTitle:@"Person D" subtitle:@"@person_d" image:[UIImage imageNamed:@"personImage"]]];
    
    self.action = [[NITableViewActions alloc] initWithTarget:self];
    
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
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"People" bundle:nil];
    PeopleViewController * tab = [storyboard instantiateViewControllerWithIdentifier:@"PeopleViewController"];
    
    tab.tabBarItem.title = name;
    tab.tabBarItem.image = [UIImage imageNamed:@"peopleTabIconNormal"];
    tab.tabBarItem.selectedImage = [UIImage imageNamed:@"peopleTabIconSelected"];
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
