//
//  ConversationViewController.m
//  MessengerUX
//
//  Created by Dam Vu Duy on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "ConversationViewController.h"
#import "UXConversationFeed.h"

#import "UIView+AutoLayout.h"

#import "UXTextMessageCell.h"
#import "UXSingleImageMessageCell.h"
#import "UXTitleMessageCell.h"
#import "UXMessagerCellConfigure.h"

@interface ConversationViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic) UXConversationFeed * dataFeed;
@property (nonatomic) ASTableNode * tableNode;

@end

@implementation ConversationViewController

+ (instancetype)viewController {
    ConversationViewController * ret = [[ConversationViewController alloc] init];
    return ret;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        ASTableNode * tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        self.tableNode = tableNode;
        self.tableNode.delegate = self;
        self.tableNode.dataSource = self;
        self.tableNode.inverted = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    
    self.navigationItem.title = @"Chat";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataFeed = [[UXConversationFeed alloc] init];
    
    // init view
    
    UIView * textInputHolder = [[UIView alloc] init];
    textInputHolder.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textInputHolder];
    [textInputHolder atHeight:64];
    [textInputHolder atLeadingWith:self.view value:0];
    [textInputHolder atTrailingWith:self.view value:0];
    [textInputHolder atBottomingWith:self.view value:0];
    
    {
        UIView * sendButton = [[UIView alloc] init];
        sendButton.backgroundColor = [UIColor colorWithRed:1.0/255.0 green:147.0/255.0 blue:238.0/255.0 alpha:1.0];
        [textInputHolder addSubview:sendButton];
        [sendButton atHeight:48];
        [sendButton atWidth:64];
        [sendButton atCenterVerticalInParent];
        [sendButton atTrailingWith:textInputHolder value:-8];
        sendButton.layer.cornerRadius = 24;
        
        UILabel * sendText = [[UILabel alloc] init];
        sendText.attributedText = [[NSAttributedString alloc] initWithString:@"Send"
                                                                  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                                                                                                               NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [sendButton addSubview:sendText];
        [sendText atCenterInParent];
        
        UIView * textInputBack = [[UIView alloc] init];
        textInputBack.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        [textInputHolder addSubview:textInputBack];
        [textInputBack atHeight:48];
        [textInputBack atCenterVerticalInParent];
        [textInputBack atLeadingWith:textInputHolder value:8];
        [textInputBack atRightMarginTo:sendButton value:-8];
        textInputBack.layer.cornerRadius = 24;
        
        UILabel * inputText = [[UILabel alloc] init];
        inputText.attributedText = [[NSAttributedString alloc] initWithString:@"Enter message..."
                                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                                                                                                               NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]}];
        [textInputBack addSubview:inputText];
        [inputText atCenterVerticalInParent];
        [inputText atLeadingWith:textInputBack value:16];
    }
    
    
    [self.view addSubview:self.tableNode.view];
    [self.tableNode.view atTopingWith:self.view value:0];
    [self.tableNode.view atTrailingWith:self.view value:0];
    [self.tableNode.view atLeadingWith:self.view value:0];
    [self.tableNode.view atBottomMarginTo:textInputHolder value:0];
    
    self.tableNode.view.allowsSelection = NO;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.tableNode.view setEditing:YES animated:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onPressBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem * editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onPressEdit)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)onPressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPressEdit {
    static BOOL isEdit = false;
    isEdit = !isEdit;
    [self.tableNode.view setEditing:isEdit animated:YES];
}

#pragma mark - Data handler

- (void)refreshFeed {
    [self loadPageWithContext:nil];
}

- (void)loadPageWithContext:(ASBatchContext *)context {
    
    __weak typeof(self) weakSelf = self;
    [self.dataFeed getNextDataPageWithCompletion:^(NSArray<UXSentence *> *datas) {
        [self.dataFeed insertNewPage:datas withCompletion:^(NSUInteger fromIndex, NSUInteger toIndex) {
            
            [weakSelf insertNewPageFromIndex:fromIndex toIndex:toIndex];
            if (context) {
                [context completeBatchFetching:YES];
            }
        }];
    }];
}

- (void)insertNewPageFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger section = 0;
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for (NSInteger row = fromIndex; row < toIndex + 1; row++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
            [indexPaths addObject:path];
        }
        [weakSelf.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    });
}

#pragma mark - ASTableDataSource

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return [self.dataFeed getDataArray].count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    UXSentence * sentence = [self.dataFeed getDataArray][indexPath.row];
    
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        UXMessagerCellConfigure * configure = [[UXMessagerCellConfigure alloc] init];
        
        if (indexPath.row % 9 == 0) {
            
            UXTitleMessageCell * titleCell = [[UXTitleMessageCell alloc] initWithConfigure:configure title:@"Section"];
            
            return titleCell;
            
        } else if (indexPath.row == 5) {
            UXSingleImageMessageCell * imageCell = [[UXSingleImageMessageCell alloc] initWithConfigure:configure
                                                                                           isIncomming:YES
                                                                                              andOwner:sentence.owner
                                                                                          contentImage:[UIImage imageNamed:@"cameraThumb"]];
            
            [imageCell setTopText:@"cameraThumb"];
            
            return imageCell;
            
        } else if (indexPath.row == 17) {
            
            UXSingleImageMessageCell * imageCell = [[UXSingleImageMessageCell alloc] initWithConfigure:configure
                                                                                           isIncomming:NO
                                                                                              andOwner:sentence.owner
                                                                                          contentImage:[UIImage imageNamed:@"tempImg"]];
            
            [imageCell setBottomText:@"tempImg"];
            
            return imageCell;
            
        } else {
            BOOL dummyIncomming = indexPath.row % 2 == 0 || indexPath.row % 13 == 0;
            
            UXTextMessageCell * textMessage = [[UXTextMessageCell alloc] initWithConfigure:configure
                                                                               isIncomming:dummyIncomming
                                                                                  andOwner:sentence.owner
                                                                               contentText:sentence.content];
            
            if (sentence.owner.name) {
                [textMessage setTopText:sentence.owner.name];
            }
            if (sentence.ID && indexPath.row % 3 == 0) {
                [textMessage setBottomText:sentence.ID];
            }
            
            return textMessage;
        }
    };
    return cellNodeBlock;
}

#pragma mark - ASTableDelegate

// Receive a message that the tableView is near the end of its data set and more data should be fetched if necessary.
- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    [context beginBatchFetching];
    [self loadPageWithContext:context];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak typeof(self) weakself = self;
        [self.tableNode performBatchUpdates:^{
            [weakself removeMessageAtIndex:indexPath.row];
            NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
            [self.tableNode deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        } completion:nil];
    }
}

- (void)removeMessageAtIndex:(NSInteger)index {
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
//}

@end
