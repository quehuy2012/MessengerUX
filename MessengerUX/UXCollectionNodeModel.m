//
//  UXContainerNodeModel.m
//  MessengerUX
//
//  Created by CPU11815 on 4/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXCollectionNodeModel.h"
#import "UXCollectionNodeModel+Private.h"
#import "UXCellCatalog.h"

@implementation UXCollectionNodeModel

#pragma mark - Creating Collection Node Models

- (id)initWithDelegate:(id<UXCollectionNodeModelDelegate>)delegate {
    if ((self = [super init])) {
        self.delegate = delegate;
        
        [self _resetCompiledData];
    }
    return self;
}

- (id)initWithListArray:(NSArray *)listArray delegate:(id<UXCollectionNodeModelDelegate>)delegate {
    if ((self = [self initWithDelegate:delegate])) {
        [self _compileDataWithListArray:listArray];
    }
    return self;
}


- (id)initWithSectionedArray:(NSArray *)sectionedArray delegate:(id<UXCollectionNodeModelDelegate>)delegate {
    if ((self = [self initWithDelegate:delegate])) {
        [self _compileDataWithSectionedArray:sectionedArray];
    }
    return self;
}

- (id)init {
    return [self initWithDelegate:nil];
}

- (void)_resetCompiledData {
    [self _setSectionsWithArray:nil];
    self.sectionIndexTitles = nil;
    self.sectionPrefixToSectionIndex = nil;
    self.showLoadingIndicatorAtLast  = NO;
}

- (void)_compileDataWithListArray:(NSArray *)listArray {
    [self _resetCompiledData];
    
    if (nil != listArray) {
        UXCollectionNodeModelSection* section = [UXCollectionNodeModelSection section];
        section.rows = listArray;
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
        BOOL isSectionFooter = [object isKindOfClass:[UXCollectionNodeModelFooter class]];
        
        NSString* nextSectionHeaderTitle = nil;
        
        if (isSection) {
            nextSectionHeaderTitle = object;
            
        } else if (isSectionFooter) {
            UXCollectionNodeModelFooter* footer = object;
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
                UXCollectionNodeModelSection* section = [UXCollectionNodeModelSection section];
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
        UXCollectionNodeModelSection* section = [UXCollectionNodeModelSection section];
        section.headerTitle = currentSectionHeaderTitle;
        section.footerTitle = currentSectionFooterTitle;
        section.rows = currentSectionRows;
        [sections addObject:section];
    }
    currentSectionRows = nil;
    
    // Update the compiled information for this data source.
    [self _setSectionsWithArray:sections];
}

- (void)_setSectionsWithArray:(NSArray *)sectionsArray {
    self.sections = sectionsArray;
}

#pragma mark - ASCollectionDataSource

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    
    if ((NSUInteger)section < self.sections.count) {
        
        if (section == self.sections.count - 1 && self.showLoadingIndicatorAtLast) {
            return [[[self.sections objectAtIndex:section] rows] count] + 1;
        }
        
        return [[[self.sections objectAtIndex:section] rows] count];
        
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionNode:(ASCollectionNode *)collectionNode {
    
    return self.sections.count;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];
    
    return [self.delegate collectionNodeModel:self
                        cellForCollectionNode:collectionNode
                                  atIndexPath:indexPath
                                   withObject:object];
}

- (ASCellNode *)collectionNode:(ASCollectionNode *)collectionNode nodeForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:
         @selector(collectionNodeModel:collectionNode:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        
        return [self.delegate collectionNodeModel:self
                                   collectionNode:collectionNode
                viewForSupplementaryElementOfKind:kind
                                      atIndexPath:indexPath];
    }
    return nil;
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
    
    if ((NSUInteger)section < self.sections.count) {
        NSArray* rows = [[self.sections objectAtIndex:section] rows];
        
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

- (NSString *)description {
    NSMutableString* result = [[super description] mutableCopy];
    [result appendString:@" sections: \n"];
    for (UXCollectionNodeModelSection *section in _sections) {
        [result appendFormat:@"section headerTitle: %@ footerTitle: %@\n", section.headerTitle, section.footerTitle];
        [result appendFormat:@"section rows: %@\n", section.rows];
    }
    
    [result appendFormat:@"sectionIndexTitles: %@", _sectionIndexTitles];
    return result;
}


@end


@implementation UXCollectionNodeModelSection

+ (id)section {
    return [[self alloc] init];
}

@end


@implementation UXCollectionNodeModelFooter

+ (UXCollectionNodeModelFooter *)footerWithTitle:(NSString *)title {
    return [[self alloc] initWithTitle:title];
}

- (id)initWithTitle:(NSString *)title {
    if ((self = [super init])) {
        self.title = title;
    }
    return self;
}

@end









