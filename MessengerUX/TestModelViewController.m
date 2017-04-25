//
//  TestModelViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 4/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "TestModelViewController.h"
#import "UIView+AutoLayout.h"
#import "UXNodeModel.h"

@interface TestModelViewController () <ASCollectionDelegate>

@property (nonatomic) ASCollectionNode * collectionNode;
@property (nonatomic) UICollectionViewFlowLayout * collectionLayout;
@property (nonatomic) UXMutableCollectionNodeModel * models;
@property (nonatomic) UXCellFactory * factory;

@end

@implementation TestModelViewController

+ (instancetype)viewController {
    TestModelViewController * ret = [[TestModelViewController alloc] init];
    return ret;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self initModel];
        
        self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:self.collectionLayout];
        self.collectionNode.delegate = self;
        self.collectionNode.dataSource = self.models;
        [self.collectionLayout invalidateLayout];
    }
    return self;
}

- (void)initModel {
    NSMutableArray * datas = [NSMutableArray array];
    for (int i = 0; i < 50; i++) {
        if (i % 5 == 0) {
            [datas addObject:@"SECTION VERRY LONG"];
        }
        [datas addObject:[[UXCellNodeObject alloc] initWithCellNodeClass:[UXTitleCellNode class] userInfo:[NSString stringWithFormat:@"Ahihi %d", i]]];
    }
    
    self.factory = [[UXCellFactory alloc] init];
    
    self.models = [[UXMutableCollectionNodeModel alloc] initWithSectionedArray:datas delegate:self.factory];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Test Nimbus like"];
    
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupView];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionNode.view];
    [self.collectionNode.view atTopMarginTo:(UIView *)self.topLayoutGuide value:0];
    [self.collectionNode.view atTrailingWith:self.view value:0];
    [self.collectionNode.view atLeadingWith:self.view value:0];
    [self.collectionNode.view atBottomMarginTo:(UIView *)self.bottomLayoutGuide value:0];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onPressBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)onPressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)add {
    [self.models addObject:[[UXCellNodeObject alloc] initWithCellNodeClass:[UXTitleCellNode class] userInfo:@"Add in"]];
    
    [self.models addSectionWithTitle:@"NEW SECTION"];
    
    [self.models addObject:[[UXCellNodeObject alloc] initWithCellNodeClass:[UXTitleCellNode class] userInfo:@"Add in section"]
                 toSection:1];
    
    [self.collectionNode reloadData];
}

#pragma mark - ASCollectionDelegate

- (ASSizeRange)collectionNode:(ASCollectionNode *)collectionNode constrainedSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // This is a hacking trick that force cell width full fill to the width of collectionNode
    return ASSizeRangeMake(CGSizeMake(collectionNode.frame.size.width, 0), CGSizeMake(collectionNode.frame.size.width, INFINITY));
}

@end
