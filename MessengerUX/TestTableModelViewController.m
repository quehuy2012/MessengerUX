//
//  TestTableModelViewController.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "TestTableModelViewController.h"
#import "UIView+AutoLayout.h"
#import "UXNodeModel.h"

@interface TestTableModelViewController ()

@property (nonatomic) ASTableNode * tableNode;
@property (nonatomic) UXMutableTableNodeModel * models;
@property (nonatomic) UXCellFactory * factory;

@end

@implementation TestTableModelViewController

+ (instancetype)viewController {
    TestTableModelViewController * ret = [[TestTableModelViewController alloc] init];
    return ret;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self initModel];
        
        self.tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        self.tableNode.dataSource = self.models;
    }
    return self;
}

- (void)initModel {
    NSMutableArray * datas = [NSMutableArray array];
    for (int i = 0; i < 50; i++) {
        if (i % 5 == 0) {
            [datas addObject:[NSString stringWithFormat:@"%d SECTION VERRY LONG", i]];
        }
        [datas addObject:[[UXCellNodeObject alloc] initWithCellNodeClass:[UXTitleWithImageCellNode class] userInfo:[NSString stringWithFormat:@"Ahihi %d", i]]];
    }
    
    self.factory = [[UXCellFactory alloc] init];
    
    self.models = [[UXMutableTableNodeModel alloc] initWithSectionedArray:datas delegate:self.factory];
    
    [self.models setSectionIndexType:UXTableNodeModelSectionIndexDynamic showsSearch:YES showsSummary:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"Setup Table Model"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupView];
}

- (void)setupView {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableNode.view];
    [self.tableNode.view atTopMarginTo:(UIView *)self.topLayoutGuide value:0];
    [self.tableNode.view atTrailingWith:self.view value:0];
    [self.tableNode.view atLeadingWith:self.view value:0];
    [self.tableNode.view atBottomMarginTo:(UIView *)self.bottomLayoutGuide value:0];
    
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
    
    [self.tableNode reloadData];
}

@end
