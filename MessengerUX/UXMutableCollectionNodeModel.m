//
//  UXMutableCollectionNodeModel.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMutableCollectionNodeModel.h"
#import "UXCollectionNodeModel+Private.h"
#import "UXMutableCollectionNodeModel+Private.h"

@interface UXMutableCollectionNodeModel ()

@property (nonatomic) dispatch_queue_t interalSerialQueue;

@end

@implementation UXMutableCollectionNodeModel

- (id)initWithDelegate:(id<UXCollectionNodeModelDelegate>)delegate {
    self = [super initWithDelegate:delegate];
    if (self) {
        [self initQueue];
    }
    
    return self;
}

- (id)initWithListArray:(NSArray *)listArray delegate:(id<UXCollectionNodeModelDelegate>)delegate {
    self = [super initWithListArray:listArray delegate:delegate];
    if (self) {
        [self initQueue];
    }
    
    return self;
}


- (id)initWithSectionedArray:(NSArray *)sectionedArray delegate:(id<UXCollectionNodeModelDelegate>)delegate {
    self = [super initWithSectionedArray:sectionedArray delegate:delegate];
    if (self) {
        [self initQueue];
    }
    
    return self;
}

- (id)init {
    self = [self initWithDelegate:nil];
    if (self) {
        [self initQueue];
    }
    
    return self;
}

- (void)initQueue {
    static int queueNum = 0;
    NSString * queueName = [NSString stringWithFormat:@"queueCollectionModel#%d", queueNum++];
    self.interalSerialQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
}


- (NSArray *)addObject:(id)object {
    
    __block UXCollectionNodeModelSection* section = nil;
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        UXCollectionNodeModelSection* section = weakSelf.sections.count == 0 ? [weakSelf _appendSection] : weakSelf.sections.lastObject;
        [section.mutableRows addObject:object];
    });
    
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                       inSection:self.sections.count - 1]];
}

- (NSArray *)addObject:(id)object toSection:(NSUInteger)sectionIndex {
    
    __block UXCollectionNodeModelSection* section = nil;
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        UXCollectionNodeModelSection *section = [weakSelf.sections objectAtIndex:sectionIndex];
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
        NSAssert(sectionIndex >= 0 && sectionIndex < weakSelf.sections.count, @"insertObject");
        UXCollectionNodeModelSection *section = [weakSelf.sections objectAtIndex:sectionIndex];
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
            UXCollectionNodeModelSection* section = [weakSelf.sections objectAtIndex:indexPath.section];
            
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
            UXCollectionNodeModelSection* section = [weakSelf.sections objectAtIndex:indexPath.section];
            
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
        UXCollectionNodeModelSection* section = [weakSelf _appendSection];
        section.headerTitle = title;
    });
    
    return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
}

- (NSIndexSet *)insertSectionWithTitle:(NSString *)title atIndex:(NSUInteger)index {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        UXCollectionNodeModelSection* section = [weakSelf _insertSectionAtIndex:index];
        section.headerTitle = title;
    });
    
    return [NSIndexSet indexSetWithIndex:index];
}

- (NSIndexSet *)removeSectionAtIndex:(NSUInteger)index {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_sync(self.interalSerialQueue, ^{
        NSAssert(index >= 0 && index < weakSelf.sections.count, @"removeSectionAtIndex");
        [weakSelf.sections removeObjectAtIndex:index];
    });
    
    return [NSIndexSet indexSetWithIndex:index];
}

#pragma mark - Private


- (UXCollectionNodeModelSection *)_appendSection {
    if (nil == self.sections) {
        self.sections = [NSMutableArray array];
    }
    UXCollectionNodeModelSection* section = nil;
    section = [[UXCollectionNodeModelSection alloc] init];
    section.rows = [NSMutableArray array];
    [self.sections addObject:section];
    return section;
}

- (UXCollectionNodeModelSection *)_insertSectionAtIndex:(NSUInteger)index {
    if (nil == self.sections) {
        self.sections = [NSMutableArray array];
    }
    UXCollectionNodeModelSection* section = nil;
    section = [[UXCollectionNodeModelSection alloc] init];
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

@end

@implementation UXCollectionNodeModelSection (Mutable)


- (NSMutableArray *)mutableRows {
    NSAssert([self.rows isKindOfClass:[NSMutableArray class]] || nil == self.rows, @"mutableRows");
    self.rows = nil == self.rows ? [NSMutableArray array] : self.rows;
    return (NSMutableArray *)self.rows;
}

@end
