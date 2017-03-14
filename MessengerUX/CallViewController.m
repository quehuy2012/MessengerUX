//
//  CallViewController.m
//  MessengerUX
//
//  Created by CPU11808 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "CallViewController.h"
#import <NITableViewModel.h>
#import <NITableViewActions.h>
#import <NICellFactory.h>
#import "Call.h"

@interface CallViewController () <UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NITableViewModel *model;
@property (strong, nonatomic) NITableViewActions *actions;

@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *image = [UIImage imageNamed:@"callTabIconNormal"];
    
    NSArray *arr = @[[[Call alloc] initWithImage:image],
                     [[Call alloc] initWithImage:image],
                     [[Call alloc] initWithImage:image],
                     [[Call alloc] initWithImage:image]];
    
    self.model = [[NITableViewModel alloc] initWithListArray:arr delegate:(id)[NICellFactory class]];
    self.tableView.dataSource = self.model;
    
    self.actions = [[NITableViewActions alloc] init];
    self.tableView.delegate = [self.actions forwardingTo:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)viewControllerWithName:(NSString *)name {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Call" bundle:nil];
    CallViewController * tab = [storyboard instantiateViewControllerWithIdentifier:@"CallViewController"];
    
    tab.tabBarItem.title = name;
    tab.tabBarItem.image = [UIImage imageNamed:@"callTabIconNormal"];
    tab.tabBarItem.selectedImage = [UIImage imageNamed:@"callTabIconSelected"];
    return tab;
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
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
