//
//  UXTableNodeModel.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXTableNodeModel.h"
#import "UXTableNodeModel+Private.h"
#import "UXCellCatalog.h"

@implementation UXTableNodeModel

- (id)initWithDelegate:(id<UXTableNodeModelDelegate>)delegate {
    if ((self = [super init])) {
        self.delegate = delegate;
        
        _sectionIndexType = UXTableNodeModelSectionIndexNone;
        _sectionIndexShowsSearch = NO;
        _sectionIndexShowsSummary = NO;
        
        _showLoadingIndicatorAtLast = NO;
        
        [self _resetCompiledData];
    }
    return self;
}

- (id)initWithListArray:(NSArray *)listArray delegate:(id<UXTableNodeModelDelegate>)delegate {
    if ((self = [self initWithDelegate:delegate])) {
        [self _compileDataWithListArray:listArray];
    }
    return self;
}

- (id)initWithSectionedArray:(NSArray *)sectionedArray delegate:(id<UXTableNodeModelDelegate>)delegate {
    if ((self = [self initWithDelegate:delegate])) {
        [self _compileDataWithSectionedArray:sectionedArray];
    }
    return self;
}

- (id)init {
    return [self initWithDelegate:nil];
}

#pragma mark - Compiling Data

- (void)_resetCompiledData {
    [self _setSectionsWithArray:nil];
    self.sectionIndexTitles = nil;
    self.sectionPrefixToSectionIndex = nil;
}

- (void)_compileDataWithListArray:(NSArray *)listArray {
    [self _resetCompiledData];
    
    if (nil != listArray) {
        UXTableNodeModelSection* section = [UXTableNodeModelSection section];
        section.rows = [listArray mutableCopy];
        [self _setSectionsWithArray:@[ section ]];
    }
}

- (void)_compileDataWithSectionedArray:(NSArray *)sectionedArray {
    [self _resetCompiledData];
    
    NSMutableArray* sections = [NSMutableArray array];
    
    NSString* currentSectionHeaderTitle = nil;
    NSString* currentSectionFooterTitle = nil;
    NSMutableArray* currentSectionRows = nil;
    
    for (id object in sectionedArray) {
        BOOL isSection = [object isKindOfClass:[NSString class]];
        BOOL isSectionFooter = [object isKindOfClass:[UXTableNodeModelFooter class]];
        
        NSString* nextSectionHeaderTitle = nil;
        
        if (isSection) {
            nextSectionHeaderTitle = object;
            
        } else if (isSectionFooter) {
            UXTableNodeModelFooter* footer = object;
            currentSectionFooterTitle = footer.title;
            
        } else {
            if (nil == currentSectionRows) {
                currentSectionRows = [[NSMutableArray alloc] init];
            }
            [currentSectionRows addObject:object];
        }
        
        // A section footer or title has been encountered,
        if (nil != nextSectionHeaderTitle || nil != currentSectionFooterTitle) {
            if (nil != currentSectionHeaderTitle
                || nil != currentSectionFooterTitle
                || nil != currentSectionRows) {
                UXTableNodeModelSection* section = [UXTableNodeModelSection section];
                section.headerTitle = currentSectionHeaderTitle;
                section.footerTitle = currentSectionFooterTitle;
                section.rows = currentSectionRows;
                [sections addObject:section];
            }
            
            currentSectionRows = nil;
            currentSectionHeaderTitle = nextSectionHeaderTitle;
            currentSectionFooterTitle = nil;
        }
    }
    
    // Commit any unfinished sections.
    if ([currentSectionRows count] > 0 || nil != currentSectionHeaderTitle) {
        UXTableNodeModelSection* section = [UXTableNodeModelSection section];
        section.headerTitle = currentSectionHeaderTitle;
        section.footerTitle = currentSectionFooterTitle;
        section.rows = currentSectionRows;
        [sections addObject:section];
    }
    currentSectionRows = nil;
    
    // Update the compiled information for this data source.
    [self _setSectionsWithArray:sections];
}

- (void)_compileSectionIndex {
    _sectionIndexTitles = nil;
    
    // Prime the section index and the map
    NSMutableArray* titles = nil;
    NSMutableDictionary* sectionPrefixToSectionIndex = nil;
    if (UXTableNodeModelSectionIndexNone != _sectionIndexType) {
        titles = [NSMutableArray array];
        sectionPrefixToSectionIndex = [NSMutableDictionary dictionary];
        
        // The search symbol is always first in the index.
        if (_sectionIndexShowsSearch) {
            [titles addObject:UITableViewIndexSearch];
        }
    }
    
    // A dynamic index shows the first letter of every section in the index in whatever order the
    // sections are ordered (this may not be alphabetical).
    if (UXTableNodeModelSectionIndexDynamic == _sectionIndexType) {
        for (UXTableNodeModelSection* section in _sections) {
            NSString* headerTitle = section.headerTitle;
            if ([headerTitle length] > 0) {
                NSString* prefix = [headerTitle substringToIndex:1];
                [titles addObject:prefix];
            }
        }
        
    } else if (UXTableNodeModelSectionIndexAlphabetical == _sectionIndexType) {
        // Use the localized indexed collation to create the index. In English, this will always be
        // the entire alphabet.
        NSArray* sectionIndexTitles = [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
        
        // The localized indexed collection sometimes includes a # for summaries, but we might
        // not want to show a summary in the index, so prune it out. It's not guaranteed that
        // a # will actually be included in the section index titles, so we always attempt to
        // remove it for consistency's sake and then add it back down below if it is requested.
        for (NSString* letter in sectionIndexTitles) {
            if (![letter isEqualToString:@"#"]) {
                [titles addObject:letter];
            }
        }
    }
    
    // Add the section summary symbol if it was requested.
    if (_sectionIndexShowsSummary) {
        [titles addObject:@"#"];
    }
    
    // Build the prefix => section index map.
    if (UXTableNodeModelSectionIndexNone != _sectionIndexType) {
        
        // Map all of the sections to indices.
        NSInteger sectionIndex = 0;
        for (UXTableNodeModelSection* section in _sections) {
            NSString* headerTitle = section.headerTitle;
            if ([headerTitle length] > 0) {
                NSString* prefix = [headerTitle substringToIndex:1];
                if (nil == [sectionPrefixToSectionIndex objectForKey:prefix]) {
                    [sectionPrefixToSectionIndex setObject:[NSNumber numberWithInteger:sectionIndex] forKey:prefix];
                }
            }
            ++sectionIndex;
        }
        
        // Map the unmapped section titles to the next closest earlier section.
        NSInteger lastIndex = 0;
        for (NSString* title in titles) {
            NSString* prefix = [title substringToIndex:1];
            if (nil != [sectionPrefixToSectionIndex objectForKey:prefix]) {
                lastIndex = [[sectionPrefixToSectionIndex objectForKey:prefix] intValue];
                
            } else {
                [sectionPrefixToSectionIndex setObject:[NSNumber numberWithInteger:lastIndex] forKey:prefix];
            }
        }
    }
    
    self.sectionIndexTitles = titles;
    self.sectionPrefixToSectionIndex = sectionPrefixToSectionIndex;
}

- (void)_setSectionsWithArray:(NSArray *)sectionsArray {
    self.sections = sectionsArray;
}

#pragma mark - ASTableDataSource

- (NSInteger)numberOfSectionsInTableNode:(ASTableNode *)tableNode {
    return self.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSAssert((section >= 0 && (NSUInteger)section < self.sections.count) || 0 == self.sections.count, @"titleForHeaderInSection");
    
    if (section >= 0 && (NSUInteger)section < self.sections.count) {
        return [[self.sections objectAtIndex:section] headerTitle];
        
    } else {
        return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSAssert((section >= 0 && (NSUInteger)section < self.sections.count) || 0 == self.sections.count, @"titleForFooterInSection");
    
    if (section >= 0 && (NSUInteger)section < self.sections.count) {
        return [[self.sections objectAtIndex:section] footerTitle];
        
    } else {
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is a static model; nothing can be edited.
    return NO;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView.tableHeaderView) {
        if (index == 0 && [self.sectionIndexTitles count] > 0
            && [self.sectionIndexTitles objectAtIndex:0] == UITableViewIndexSearch)  {
            // This is a hack to get the table header to appear when the user touches the
            // first row in the section index.  By default, it shows the first row, which is
            // not usually what you want.
            [tableView scrollRectToVisible:tableView.tableHeaderView.bounds animated:NO];
            return -1;
        }
    }
    
    NSString* letter = [title substringToIndex:1];
    NSNumber* sectionIndex = [self.sectionPrefixToSectionIndex objectForKey:letter];
    return (nil != sectionIndex) ? [sectionIndex intValue] : -1;
}

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    NSAssert((NSUInteger)section < self.sections.count || 0 == self.sections.count, @"numberOfRowsInSection");
    
    if ((NSUInteger)section < self.sections.count) {
        
        if (section == self.sections.count - 1 && self.showLoadingIndicatorAtLast) {
            return [[[self.sections objectAtIndex:section] rows] count] + 1;
        }
        
        return [[[self.sections objectAtIndex:section] rows] count];
        
    } else {
        return 0;
    }
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {

    id object = [self objectAtIndexPath:indexPath];
    
    return [self.delegate tableNodeModel:self
                        cellForTableNode:tableNode
                             atIndexPath:indexPath
                              withObject:object];
}

#pragma mark - Public


- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    if (nil == indexPath) {
        return nil;
    }
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    if (section == self.sections.count - 1
        && indexPath.row == [[self.sections[self.sections.count - 1] rows] count]
        && self.showLoadingIndicatorAtLast) {
        return [[UXCellNodeObject alloc] initWithCellNodeClass:[UXLoadingCellNode class] userInfo:@"ABC"];;
    }
    
    id object = nil;
    
    NSAssert((NSUInteger)section < self.sections.count, @"objectAtIndexPath");
    
    if ((NSUInteger)section < self.sections.count) {
        NSArray* rows = [[self.sections objectAtIndex:section] rows];
        
        NSAssert((NSUInteger)row < rows.count, @"objectAtIndexPath");
        if ((NSUInteger)row < rows.count) {
            object = [rows objectAtIndex:row];
        }
    }
    
    return object;
}

- (NSIndexPath *)indexPathForObject:(id)object {
    if (nil == object) {
        return nil;
    }
    
    NSArray *sections = self.sections;
    for (NSUInteger sectionIndex = 0; sectionIndex < [sections count]; sectionIndex++) {
        NSArray* rows = [[sections objectAtIndex:sectionIndex] rows];
        for (NSUInteger rowIndex = 0; rowIndex < [rows count]; rowIndex++) {
            if ([object isEqual:[rows objectAtIndex:rowIndex]]) {
                return [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
            }
        }
    }
    
    return nil;
}

- (void)setSectionIndexType:(UXTableNodeModelSectionIndex)sectionIndexType showsSearch:(BOOL)showsSearch showsSummary:(BOOL)showsSummary {
    if (_sectionIndexType != sectionIndexType
        || _sectionIndexShowsSearch != showsSearch
        || _sectionIndexShowsSummary != showsSummary) {
        _sectionIndexType = sectionIndexType;
        _sectionIndexShowsSearch = showsSearch;
        _sectionIndexShowsSummary = showsSummary;
        
        [self _compileSectionIndex];
    }
}

@end

@implementation UXTableNodeModelFooter


+ (UXTableNodeModelFooter *)footerWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (id)initWithTitle:(NSString *)title {
    if ((self = [super init])) {
        self.title = title;
    }
    return self;
}

@end


@implementation UXTableNodeModelSection

+ (id)section {
    return [[self alloc] init];
}

@end
















