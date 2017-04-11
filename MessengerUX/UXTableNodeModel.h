//
//  UXTableNodeModel.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@protocol UXTableNodeModelDelegate;

typedef NS_ENUM(NSUInteger, UXTableNodeModelSectionIndex) {
    UXTableNodeModelSectionIndexNone = 0, // Displays no section index.
    UXTableNodeModelSectionIndexDynamic, // Generates a section index from the first letters of the section titles.
    UXTableNodeModelSectionIndexAlphabetical
};

@interface UXTableNodeModel : NSObject <ASTableDataSource>

// Designated initializer.
- (id)initWithDelegate:(id<UXTableNodeModelDelegate>)delegate;
- (id)initWithListArray:(NSArray *)sectionedArray delegate:(id<UXTableNodeModelDelegate>)delegate;
// Each NSString in the array starts a new section. Any other object is a new row (with exception of certain model-specific objects).
- (id)initWithSectionedArray:(NSArray *)sectionedArray delegate:(id<UXTableNodeModelDelegate>)delegate;

#pragma mark - Accessing Objects

// This method is not appropriate for performance critical codepaths.
- (NSIndexPath *)indexPathForObject:(id)object;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Configuration

// Immediately compiles the section index.
- (void)setSectionIndexType:(UXTableNodeModelSectionIndex)sectionIndexType showsSearch:(BOOL)showsSearch showsSummary:(BOOL)showsSummary;

@property (nonatomic, readonly, assign) UXTableNodeModelSectionIndex sectionIndexType; // Default: UXTableNodeModelSectionIndexNone
@property (nonatomic, readonly, assign) BOOL sectionIndexShowsSearch; // Default: NO
@property (nonatomic, readonly, assign) BOOL sectionIndexShowsSummary; // Default: NO

@property (nonatomic) BOOL showLoadingIndicatorAtLast; // Default: NO

#pragma mark - Creating Table View Node Cells

@property (nonatomic, weak) id<UXTableNodeModelDelegate> delegate;

@end

@protocol UXTableNodeModelDelegate <NSObject>

@required

- (ASCellNodeBlock)tableNodeModel: (UXTableNodeModel *)tableNodeModel
                   cellForTableNode: (ASTableNode *)tableNode
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object;

@end

@interface UXTableNodeModelFooter : NSObject

+ (id)footerWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title;

@property (nonatomic, copy) NSString* title;

@end




