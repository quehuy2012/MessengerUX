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
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    
//    self.action = [[NITableViewActions alloc] initWithTarget:self];
    
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
