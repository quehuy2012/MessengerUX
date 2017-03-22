//
//  ConversationViewController.m
//  MessengerUX
//
//  Created by Dam Vu Duy on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ConversationViewController.h"
#import "ConversationFeed.h"

@interface ConversationViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic) ConversationFeed * dataFeed;

@end

@implementation ConversationViewController

- (instancetype)init {
    ASTableNode * tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self = [super initWithNode:tableNode];
    if (self) {
        self.tableNode.delegate = self;
        self.tableNode.dataSource = self;
    }
    return self;
}

- (ASTableNode *)tableNode {
    return self.node;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASTableDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [self.dataFeed getDataArray].count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    Sentence * sentence = [self.dataFeed getDataArray][indexPath.row];
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
//        PhotoCellNode *cellNode = [[PhotoCellNode alloc] initWithPhoto:photoModel];
//        cellNode.delegate = self;
//        return cellNode;
        return nil;
    };
    return cellNodeBlock;
}

@end
