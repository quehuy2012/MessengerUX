//
//  UXMutableTableNodeModel.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMutableTableNodeModel.h"
#import "UXTableNodeModel+Private.h"
#import "UXMutableTableNodeModel+Private.h"

@interface UXMutableTableNodeModel ()

@property (nonatomic) dispatch_queue_t interalSerialQueue;

@end

@implementation UXMutableTableNodeModel

@synthesize delegate;

#pragma mark - Public

- (id)initWithDelegate:(id<UXMutableTableNodeModelDelegate>)delegate {
    self = [super initWithDelegate:(id<UXTableNodeModelDelegate>)delegate];
    if (self) {
        [self initQueue];
    }
    
    return self;
}

- (id)initWithListArray:(NSArray *)listArray delegate:(id<UXMutableTableNodeModelDelegate>)delegate {
    self = [super initWithListArray:listArray delegate:delegate];
    if (self) {
        [self initQueue];
    }
    
    return self;
}

- (id)initWithSectionedArray:(NSArray *)sectionedArray delegate:(id<UXMutableTableNodeModelDelegate>)delegate {
    self = [super initWithSectionedArray:sectionedArray delegate:delegate];
    if (self) {
        [self initQueue];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initQueue];
    }
    
    return self;
}

- (void)initQueue {
    static int queueNum = 0;
    NSString * queueName = [NSString stringWithFormat:@"queueModel#%d", queueNum++];
    self.interalSerialQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
}

- (NSArray *)addObject:(id)object {
    
    __block UXTableNodeModelSection* section = nil;
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        section = weakSelf.sections.count == 0 ? [weakSelf _appendSection] : weakSelf.sections.lastObject;
        [section.mutableRows addObject:object];
    });
    
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                       inSection:self.sections.count - 1]];
}

- (NSArray *)addObject:(id)object toSection:(NSUInteger)sectionIndex {
    
    __block UXTableNodeModelSection* section = nil;
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        NSAssert(sectionIndex >= 0 && sectionIndex < weakSelf.sections.count, @"toSection");
        UXTableNodeModelSection *section = [weakSelf.sections objectAtIndex:sectionIndex];
        [section.mutableRows addObject:object];
    });
    
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                       inSection:sectionIndex]];
}

- (NSArray *)addObjectsFromArray:(NSArray *)array {
    
    NSMutableArray* indices = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        for (id object in array) {
            [indices addObject:[[weakSelf addObject:object] objectAtIndex:0]];
        }
    });
    
    return indices;
}

- (NSArray *)insertObject:(id)object atRow:(NSUInteger)row inSection:(NSUInteger)sectionIndex {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        NSAssert(sectionIndex >= 0 && sectionIndex < weakSelf.sections.count, @"atRow");
        UXTableNodeModelSection *section = [weakSelf.sections objectAtIndex:sectionIndex];
        [section.mutableRows insertObject:object atIndex:row];
    });
    
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
}

- (NSArray *)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    
    __block NSArray * ret = nil;
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        NSAssert(indexPath.section < (NSInteger)weakSelf.sections.count, @"removeObjectAtIndexPath");
        if (indexPath.section < (NSInteger)weakSelf.sections.count) {
            UXTableNodeModelSection* section = [weakSelf.sections objectAtIndex:indexPath.section];
            
            NSAssert(indexPath.row < (NSInteger)section.mutableRows.count, @"removeObjectAtIndexPath");
            if (indexPath.row < (NSInteger)section.mutableRows.count) {
                [section.mutableRows removeObjectAtIndex:indexPath.row];
                ret = [NSArray arrayWithObject:indexPath];
            }
        }
    });
    
    return ret;
}

- (NSArray *)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    
    __block NSArray * ret = nil;
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        NSAssert(indexPath.section < (NSInteger)weakSelf.sections.count, @"removeObjectAtIndexPath");
        if (indexPath.section < (NSInteger)weakSelf.sections.count) {
            UXTableNodeModelSection* section = [weakSelf.sections objectAtIndex:indexPath.section];
            
            NSAssert(indexPath.row < (NSInteger)section.mutableRows.count, @"removeObjectAtIndexPath");
            if (indexPath.row < (NSInteger)section.mutableRows.count) {
                [section.mutableRows replaceObjectAtIndex:indexPath.row withObject:object];
                ret = [NSArray arrayWithObject:indexPath];
            }
        }
    });
    
    return ret;
}

- (NSIndexSet *)addSectionWithTitle:(NSString *)title {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        UXTableNodeModelSection* section = [weakSelf _appendSection];
        section.headerTitle = title;
    });
    
    return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
}

- (NSIndexSet *)insertSectionWithTitle:(NSString *)title atIndex:(NSUInteger)index {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        UXTableNodeModelSection* section = [weakSelf _insertSectionAtIndex:index];
        section.headerTitle = title;
    });
    
    return [NSIndexSet indexSetWithIndex:index];
}

- (NSIndexSet *)removeSectionAtIndex:(NSUInteger)index {
    
    dispatch_sync(self.interalSerialQueue, ^{
        NSAssert(index >= 0 && index < self.sections.count, @"removeSectionAtIndex");
        [self.sections removeObjectAtIndex:index];
    });
    
    return [NSIndexSet indexSetWithIndex:index];
}

- (void)updateSectionIndex {
    [self _compileSectionIndex];
}

#pragma mark - Private


- (UXTableNodeModelSection *)_appendSection {
    if (nil == self.sections) {
        [self _setSectionsWithArray:[NSMutableArray array]];
    }
    UXTableNodeModelSection* section = nil;
    section = [[UXTableNodeModelSection alloc] init];
    section.rows = [NSMutableArray array];
    [self.sections addObject:section];
    return section;
}

- (UXTableNodeModelSection *)_insertSectionAtIndex:(NSUInteger)index {
    if (nil == self.sections) {
        [self _setSectionsWithArray:[NSMutableArray array]];
    }
    UXTableNodeModelSection* section = nil;
    section = [[UXTableNodeModelSection alloc] init];
    section.rows = [NSMutableArray array];
    NSAssert(index >= 0 && index <= self.sections.count, @"_insertSectionAtIndex");
    [self.sections insertObject:section atIndex:index];
    return section;
}

- (void)_setSectionsWithArray:(NSArray *)sectionsArray {
    if ([sectionsArray isKindOfClass:[NSMutableArray class]]) {
        self.sections = (NSMutableArray *)sectionsArray;
    } else {
        self.sections = [sectionsArray mutableCopy];
    }
}

#pragma mark - UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableNodeModel:canEditObject:atIndexPath:inTableView:)]) {
        id object = [self objectAtIndexPath:indexPath];
        return [self.delegate tableNodeModel:self canEditObject:object atIndexPath:indexPath inTableView:tableView];
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BOOL shouldDelete = YES;
        if ([self.delegate respondsToSelector:@selector(tableNodeModel:shouldDeleteObject:atIndexPath:inTableView:)]) {
            shouldDelete = [self.delegate tableNodeModel:self shouldDeleteObject:object atIndexPath:indexPath inTableView:tableView];
        }
        if (shouldDelete) {
            NSArray *indexPaths = [self removeObjectAtIndexPath:indexPath];
            UITableViewRowAnimation animation = UITableViewRowAnimationAutomatic;
            if ([self.delegate respondsToSelector:@selector(tableNodeModel:deleteRowAnimationForObject:atIndexPath:inTableView:)]) {
                animation = [self.delegate tableNodeModel:self deleteRowAnimationForObject:object atIndexPath:indexPath inTableView:tableView];
            }
            [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableNodeModel:canMoveObject:atIndexPath:inTableView:)]) {
        id object = [self objectAtIndexPath:indexPath];
        return [self.delegate tableNodeModel:self canMoveObject:object atIndexPath:indexPath inTableView:tableView];
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id object = [self objectAtIndexPath:sourceIndexPath];
    BOOL shouldMove = YES;
    if ([self.delegate respondsToSelector:@selector(tableNodeModel:shouldMoveObject:atIndexPath:toIndexPath:inTableView:)]) {
        shouldMove = [self.delegate tableNodeModel:self shouldMoveObject:object atIndexPath:sourceIndexPath toIndexPath:destinationIndexPath inTableView:tableView];
    }
    if (shouldMove) {
        [self removeObjectAtIndexPath:sourceIndexPath];
        [self insertObject:object atRow:destinationIndexPath.row inSection:destinationIndexPath.section];
    }
}


@end

@implementation UXTableNodeModelSection (Mutable)


- (NSMutableArray *)mutableRows {
    NSAssert([self.rows isKindOfClass:[NSMutableArray class]] || nil == self.rows, @"mutableRows");
    
    self.rows = nil == self.rows ? [NSMutableArray array] : self.rows;
    return (NSMutableArray *)self.rows;
}

@end










