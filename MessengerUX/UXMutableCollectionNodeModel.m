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

@implementation UXMutableCollectionNodeModel

- (NSArray *)addObject:(id)object {
    UXCollectionNodeModelSection* section = self.sections.count == 0 ? [self _appendSection] : self.sections.lastObject;
    [section.mutableRows addObject:object];
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                       inSection:self.sections.count - 1]];
}

- (NSArray *)addObject:(id)object toSection:(NSUInteger)sectionIndex {
    UXCollectionNodeModelSection *section = [self.sections objectAtIndex:sectionIndex];
    [section.mutableRows addObject:object];
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:section.mutableRows.count - 1
                                                       inSection:sectionIndex]];
}

- (NSArray *)addObjectsFromArray:(NSArray *)array {
    NSMutableArray* indices = [NSMutableArray array];
    for (id object in array) {
        [indices addObject:[[self addObject:object] objectAtIndex:0]];
    }
    return indices;
}

- (NSArray *)insertObject:(id)object atRow:(NSUInteger)row inSection:(NSUInteger)sectionIndex {
    NSAssert(sectionIndex >= 0 && sectionIndex < self.sections.count, @"insertObject");
    UXCollectionNodeModelSection *section = [self.sections objectAtIndex:sectionIndex];
    [section.mutableRows insertObject:object atIndex:row];
    return [NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
}

- (NSArray *)removeObjectAtIndexPath:(NSIndexPath *)indexPath {
    NSAssert(indexPath.section < (NSInteger)self.sections.count, @"removeObjectAtIndexPath");
    if (indexPath.section >= (NSInteger)self.sections.count) {
        return nil;
    }
    UXCollectionNodeModelSection* section = [self.sections objectAtIndex:indexPath.section];
    NSAssert(indexPath.row < (NSInteger)section.mutableRows.count, @"removeObjectAtIndexPath");
    if (indexPath.row >= (NSInteger)section.mutableRows.count) {
        return nil;
    }
    [section.mutableRows removeObjectAtIndex:indexPath.row];
    return [NSArray arrayWithObject:indexPath];
}

- (NSArray *)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    NSAssert(indexPath.section < (NSInteger)self.sections.count, @"removeObjectAtIndexPath");
    if (indexPath.section >= (NSInteger)self.sections.count) {
        return nil;
    }
    UXCollectionNodeModelSection* section = [self.sections objectAtIndex:indexPath.section];
    NSAssert(indexPath.row < (NSInteger)section.mutableRows.count, @"removeObjectAtIndexPath");
    if (indexPath.row >= (NSInteger)section.mutableRows.count) {
        return nil;
    }
    [section.mutableRows replaceObjectAtIndex:indexPath.row withObject:object];
    return [NSArray arrayWithObject:indexPath];
}

- (NSIndexSet *)addSectionWithTitle:(NSString *)title {
    UXCollectionNodeModelSection* section = [self _appendSection];
    section.headerTitle = title;
    return [NSIndexSet indexSetWithIndex:self.sections.count - 1];
}

- (NSIndexSet *)insertSectionWithTitle:(NSString *)title atIndex:(NSUInteger)index {
    UXCollectionNodeModelSection* section = [self _insertSectionAtIndex:index];
    section.headerTitle = title;
    return [NSIndexSet indexSetWithIndex:index];
}

- (NSIndexSet *)removeSectionAtIndex:(NSUInteger)index {
    NSAssert(index >= 0 && index < self.sections.count, @"removeSectionAtIndex");
    [self.sections removeObjectAtIndex:index];
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
