//
//  GroupViewController.m
//  MessengerUX
//
//  Created by CPU11808 on 3/13/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "GroupViewController.h"
#import <NICollectionViewModel.h>
#import <NICollectionViewActions.h>
#import <NICollectionViewCellFactory.h>
#import "Group.h"

@interface GroupViewController () <UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NICollectionViewModel *model;
@property (strong, nonatomic) NICollectionViewActions *actions;

@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *groupImage = [UIImage imageNamed:@"groupTabIconSelected"];
    NSArray *arr = @[[[Group alloc] initWithImage:groupImage],
                     [[Group alloc] initWithImage:groupImage],
                     [[Group alloc] initWithImage:groupImage],
                     [[Group alloc] initWithImage:groupImage]];
    
    self.model = [[NICollectionViewModel alloc] initWithListArray:arr delegate:(id)[NICollectionViewCellFactory class]];
//    self.actions = [[NICollectionViewActions alloc] initWithTarget:self];
    
    self.collectionView.dataSource = self.model;
//    self.collectionView.delegate = [self.actions ]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)viewControllerWithName:(NSString *)name {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Group" bundle:nil];
    GroupViewController * tab = [storyboard instantiateViewControllerWithIdentifier:@"GroupViewController"];
    
    tab.tabBarItem.title = name;
    tab.tabBarItem.image = [UIImage imageNamed:@"groupTabIconNormal"];
    tab.tabBarItem.selectedImage = [UIImage imageNamed:@"groupTabIconSelected"];
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
