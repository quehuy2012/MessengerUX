//
//  ConversationViewController.m
//  MessengerUX
//
//  Created by Dam Vu Duy on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#include <stdlib.h>

#import "ConversationViewController.h"
#import "UIView+AutoLayout.h"

#import "UXNodeModel.h"
#import "UXMessageTimeLine.h"

#import "UXConversationFeed.h"

#import "UXHeadBatchFetching.h"

static const NSTimeInterval kCellLongPressInterval = 0.7;


@interface ConversationViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic) UXConversationFeed * dataFeed;
@property (nonatomic) ASTableNode * tableNode;
@property (nonatomic) UXMutableTableNodeModel * models;
@property (nonatomic) UXCellFactory * factory;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (atomic) BOOL stillNeedStressTest;

@property (nonatomic) CGFloat lastOffset;
@property (nonatomic) ASScrollDirection scrollDirection;

@property (atomic) NSUInteger shiftIndex;
@property (atomic) NSUInteger maxAvaiableItem;

@end

@implementation ConversationViewController

+ (instancetype)viewController {
    ConversationViewController * ret = [[ConversationViewController alloc] init];
    return ret;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    
    self.lastOffset = 0;
    
    self.maxAvaiableItem = 100;
    self.shiftIndex = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.stillNeedStressTest = NO;
}

- (void)initModel {
    
    self.dataFeed = [[UXConversationFeed alloc] init];
    self.factory = [[UXCellFactory alloc] init];
    self.models = [[UXMutableTableNodeModel alloc] initWithListArray:[self.dataFeed getDataArray]  delegate:self.factory];
    self.models.showLoadingIndicatorAtLast = YES;
}

- (void)initView {
    
    self.navigationItem.title = @"Chat";
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self initModel];
    
    [UXMessageCellConfigure setGlobalConfigure:[[UXMessagerCellConfigure alloc] init]];
    
    ASTableNode * tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
    self.tableNode = tableNode;
    self.tableNode.delegate = self;
    self.tableNode.dataSource = self.models;
    self.tableNode.inverted = YES;
    
    self.stillNeedStressTest = NO;
    
    // init view
    
    UIView * textInputHolder = [[UIView alloc] init];
    textInputHolder.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textInputHolder];
    [textInputHolder atHeight:48];
    [textInputHolder atLeadingWith:self.view value:0];
    [textInputHolder atTrailingWith:self.view value:0];
    [textInputHolder atBottomMarginTo:(UIView *)self.bottomLayoutGuide value:0];
    
    {
        UIImageView * sendButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatSendIcon"]];
        sendButton.contentMode = UIViewContentModeScaleAspectFit;
        [textInputHolder addSubview:sendButton];
        [sendButton atHeight:36];
        [sendButton atWidth:36];
        [sendButton atCenterVerticalInParent];
        [sendButton atTrailingWith:textInputHolder value:-8];
        sendButton.layer.cornerRadius = 18;
        
        UIImageView * moreButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chatMoreIcon"]];
        moreButton.contentMode = UIViewContentModeScaleAspectFit;
        [textInputHolder addSubview:moreButton];
        [moreButton atHeight:36];
        [moreButton atWidth:36];
        [moreButton atCenterVerticalInParent];
        [moreButton atLeadingWith:textInputHolder value:8];
        moreButton.layer.cornerRadius = 18;
        
        UIView * textInputBack = [[UIView alloc] init];
        textInputBack.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        textInputBack.layer.borderWidth = 1;
        textInputBack.layer.borderColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor;
        [textInputHolder addSubview:textInputBack];
        [textInputBack atHeight:36];
        [textInputBack atCenterVerticalInParent];
        [textInputBack atLeftMarginTo:moreButton value:8];
        [textInputBack atRightMarginTo:sendButton value:-8];
        textInputBack.layer.cornerRadius = 18;
        
        UILabel * inputText = [[UILabel alloc] init];
        inputText.attributedText = [[NSAttributedString alloc] initWithString:@"Enter message..."
                                                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0],
                                                                                                               NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]}];
        [textInputBack addSubview:inputText];
        [inputText atCenterVerticalInParent];
        [inputText atLeadingWith:textInputBack value:16];
    }
    
    
    [self.view addSubview:self.tableNode.view];
    [self.tableNode.view atTopMarginTo:(UIView *)self.topLayoutGuide value:0];
    [self.tableNode.view atTrailingWith:self.view value:0];
    [self.tableNode.view atLeadingWith:self.view value:0];
    [self.tableNode.view atBottomMarginTo:textInputHolder value:0];
    
    // Add long press gesture
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    gesture.minimumPressDuration = kCellLongPressInterval;
    [self.tableNode.view addGestureRecognizer:gesture];
    
    self.tableNode.view.allowsSelection = NO;
    self.tableNode.view.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableNode.view.leadingScreensForBatching = 3.0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem * backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(onPressBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
//    UIBarButtonItem * editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onPressEdit)];
    UIBarButtonItem * stressTest = [[UIBarButtonItem alloc] initWithTitle:@"Stress" style:UIBarButtonItemStylePlain target:self action:@selector(updateNode)];
    self.navigationItem.rightBarButtonItems = @[stressTest];
}

- (void)onPressBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onPressEdit {
    static BOOL isEdit = false;
    isEdit = !isEdit;
    [self.tableNode.view setEditing:isEdit animated:YES];
}

- (void)updateNode {
    
    self.stillNeedStressTest = !self.stillNeedStressTest;
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_queue_t customQueue = dispatch_queue_create("queueueueueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(customQueue, ^{
       
        for (int i = 0; i < 100000; i++) {
            
            [NSThread sleepForTimeInterval:0.3];
            
            if (!weakSelf.stillNeedStressTest) {
                break;
            }
            
            NSUInteger maxNum = [self.dataFeed getDataArray].count;
            
            int r = arc4random_uniform((uint32_t)maxNum);
            
            NSIndexPath * index = [NSIndexPath indexPathForRow:r inSection:0];
            
            UXOwner * owner = [[UXOwner alloc] init];
            owner.name = @"new";
            owner.avatar = [UIImage imageNamed:@"groupImage"];
            
            UXMessage * message = [[UXTextMessage alloc] initWithContent:@"Updated content in range"
                                                        date:[NSDate timeIntervalSinceReferenceDate]
                                                   isComming:r%5 == 0
                                                       owner:owner];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weakSelf.dataFeed replaceIndex:r withData:message];
                [weakSelf.models replaceObjectAtIndexPath:index withObject:message];
                [weakSelf.tableNode reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
            });
            
        }
        
    });
}

#pragma mark - Data handler

- (void)refreshFeed {
    [self loadPageWithContext:nil];
}

- (void)loadPageWithContext:(ASBatchContext *)context {
    
    __weak typeof(self) weakSelf = self;
    [self.dataFeed getNextDataPageWithCompletion:^(NSArray<UXMessage *> *datas) {
        [self.dataFeed insertNewPage:datas withCompletion:^(NSUInteger fromIndex, NSUInteger toIndex) {
            
            [weakSelf.models addObjectsFromArray:datas];
            
            BOOL needUpdateHeadAndTail = [weakSelf.dataFeed getDataArray].count - weakSelf.shiftIndex > weakSelf.maxAvaiableItem;
            
            if (needUpdateHeadAndTail) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.tableNode performBatchUpdates:^{
                        
                        // Insert tail
                        {
                            NSInteger section = 0;
                            NSMutableArray *indexPaths = [NSMutableArray array];
                            
                            for (NSInteger row = fromIndex; row < toIndex + 1; row++) {
                                NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
                                [indexPaths addObject:path];
                            }
                            [weakSelf.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                        }
                        
                        // Remove head
                        {
                            
                            
                            
                            NSInteger section = 0;
                            NSMutableArray *indexPaths = [NSMutableArray array];
                            
                            for (NSInteger row = fromIndex; row < toIndex + 1; row++) {
                                NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
                                [indexPaths addObject:path];
                            }
                            
                            [weakSelf.tableNode deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                        }
                        
                    } completion:nil];
                    
                });
            } else {
                [weakSelf insertNewItemsFromIndex:fromIndex toIndex:toIndex];
            }
            
            
            
            
            
            
            
            
            
            
            
            for (int i = 0; i < 20; i++) {
                [weakSelf.models removeObjectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            [weakSelf removeItemsFromIndex:0 toIndex:20];
            
            weakSelf.shiftIndex += 20;
            
            
            
            
            
            
            
            
            if (context) {
                [context completeBatchFetching:YES];
            }
        }];
    }];
}

- (void)loadHeadDataWithCurrentIndex {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray * allData = [weakSelf.dataFeed getDataArray];
        
        NSUInteger tail = weakSelf.shiftIndex > 20 ? weakSelf.shiftIndex - 20 : 0;
        
        NSIndexSet * indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(tail, weakSelf.shiftIndex - tail)];
        
        NSArray * insertArray = [allData objectsAtIndexes:indexes];
        
        for (int i = (int)insertArray.count - 1; i >= 0; i--) {
            id object = insertArray[i];
            [weakSelf.models insertObject:object atRow:0 inSection:0];
        }
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSInteger row = 0; row < (int)insertArray.count; row++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
            [indexPaths addObject:path];
        }
        
        [weakSelf.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    });
}

- (void)insertNewItemsFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    
    __weak typeof(self) weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSInteger section = 0;
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for (NSInteger row = fromIndex; row < toIndex + 1; row++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
            [indexPaths addObject:path];
        }
        [weakSelf.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    });
}

- (void)removeItemsFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    
    __weak typeof(self) weakSelf = self;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSInteger section = 0;
        NSMutableArray *indexPaths = [NSMutableArray array];
        
        for (NSInteger row = fromIndex; row < toIndex + 1; row++) {
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
            [indexPaths addObject:path];
        }
        
        [weakSelf.tableNode deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    });
    
}

#pragma mark - Supporting head fetch for table node

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat delta = self.lastOffset - scrollView.contentOffset.y;
    
    if (delta > 0) {
        self.scrollDirection = self.tableNode.inverted ? ASScrollDirectionUp : ASScrollDirectionDown;
    } else if (delta < 0) {
        self.scrollDirection = self.tableNode.inverted ? ASScrollDirectionDown : ASScrollDirectionUp;
    } else {
        self.scrollDirection = ASScrollDirectionNone;
    }
    
    [self checkForHeadBatchFetching:scrollView];
    
    self.lastOffset = scrollView.contentOffset.y;
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (targetContentOffset != NULL) {
        [self beginHeadBatchFetchingIfNeededWithContentOffset:*targetContentOffset scrollView:scrollView];
    }
}

- (void)checkForHeadBatchFetching:(UIScrollView *)scrollView {
    
    // Dragging will be handled in scrollViewWillEndDragging:withVelocity:targetContentOffset:
    if (scrollView.isDragging || scrollView.isTracking) {
        return;
    }
    
    [self beginHeadBatchFetchingIfNeededWithContentOffset:scrollView.contentOffset scrollView:scrollView];
}

- (void)beginHeadBatchFetchingIfNeededWithContentOffset:(CGPoint)contentOffset scrollView:(UIScrollView *)scrollView {
    if (UXDisplayShouldHeadFetchBatchForScrollView((UIScrollView<ASBatchFetchingScrollView> *)scrollView
                                                   , self.scrollDirection
                                                   , ASScrollDirectionVerticalDirections
                                                   , contentOffset)) {
        [self beginHeadBatchFetching];
    }
}

- (void)beginHeadBatchFetching {
    ASBatchContext * context = [((UIScrollView<ASBatchFetchingScrollView> *)self.tableNode.view) batchContext];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [context beginBatchFetching];
        
        NSLog(@"Head fetch");
        
        [weakSelf loadHeadDataWithCurrentIndex];
        
        [context completeBatchFetching:YES];
    });
}

#pragma mark - ASTableDelegate

- (BOOL)shouldBatchFetchForTableNode:(ASTableNode *)tableNode {
    return YES;
}

// Receive a message that the tableView is near the end of its data set and more data should be fetched if necessary.
- (void)tableNode:(ASTableNode *)tableNode willBeginBatchFetchWithContext:(ASBatchContext *)context {
    
    NSLog(@"Tail fetch");
    
    [context beginBatchFetching];
    
    [self loadPageWithContext:context];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ASCellNode * cell = [self.tableNode nodeForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[UXTitleMessageCell class]]) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        __weak typeof(self) weakself = self;
        [self.tableNode performBatchUpdates:^{
            
            // Remove section if needed
            NSIndexPath *cellIndex = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            ASCellNode * cell = [weakself.tableNode nodeForRowAtIndexPath:cellIndex];
            if (cell && [cell isKindOfClass:[UXTitleMessageCell class]]) {
                [weakself removeMessageAtIndexPath:cellIndex];
            }
            
            [weakself removeMessageAtIndexPath:indexPath];
            
        } completion:nil];
    }
}

- (void)removeMessageAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakself = self;
    [self.tableNode performBatchUpdates:^{
        
        UXMessageCell *cell = [weakself.tableNode nodeForRowAtIndexPath:indexPath];
        
        if (cell) {
            BOOL isComming = cell.isIncomming;
            [self.dataFeed deleteDataAtIndex:indexPath.row];
            [self.models removeObjectAtIndexPath:indexPath];
            NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
            UITableViewRowAnimation animation = isComming ? UITableViewRowAnimationLeft : UITableViewRowAnimationRight;
            [self.tableNode deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        }
    } completion:nil];
    
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    CGPoint point = [gestureRecognizer locationInView:self.tableNode.view];
    NSIndexPath *indexPath = [self.tableNode indexPathForRowAtPoint:point];
    
    if (indexPath && [self tableView:self.tableNode.view canEditRowAtIndexPath:indexPath]) {
        
        UXMessageCell * cell = [self.tableNode nodeForRowAtIndexPath:indexPath];
        CGPoint cellPoint = [gestureRecognizer locationInView:cell.view];
        
        switch (gestureRecognizer.state) {
            case UIGestureRecognizerStateBegan: {
                if (CGRectContainsPoint(cell.editableFrame, cellPoint)) {
                    [self showEditingMenuAtPoint:point];
                    self.selectedIndexPath = indexPath;
                }
                break;
            }
            default:
                break;
        }
    }
}

- (void)showEditingMenuAtPoint:(CGPoint)point {
//    NSLog(@"Show menu");
    CGRect targetRectangle = CGRectMake(point.x, point.y, 0, 0);
    [[UIMenuController sharedMenuController] setTargetRect:targetRectangle
                                                    inView:self.tableNode.view];
    
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Delete"
                                                      action:@selector(deleteAction:)];
    
    [[UIMenuController sharedMenuController] setMenuItems:@[menuItem]];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    BOOL result = NO;
    if(@selector(copy:) == action ||
       @selector(deleteAction:) == action) {
        result = YES;
    }
    return result;
}

- (void)deleteAction:(id)sender {
    if (self.selectedIndexPath) {
        [self removeMessageAtIndexPath:self.selectedIndexPath];
    }
    self.selectedIndexPath = nil;
}

- (void)copy:(id)sender {
    NSLog(@"Method is not implemented");
}

#pragma mark - Memory monitor

- (void)dealloc {
    NSLog(@"Dealloc View Controller");
}

@end
