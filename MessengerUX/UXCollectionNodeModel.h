//
//  UXContainerNodeModel.h
//  MessengerUX
//
//  Created by CPU11815 on 4/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@protocol UXCollectionNodeModelDelegate;

@interface UXCollectionNodeModel : NSObject <ASCollectionDataSource>

#pragma mark - Creating Collection Node Models

- (id)initWithDelegate:(id<UXCollectionNodeModelDelegate>)delegate;
- (id)initWithListArray:(NSArray *)listArray delegate:(id<UXCollectionNodeModelDelegate>)delegate;
// Each NSString in the array starts a new section. Any other object is a new row (with exception of certain model-specific objects).
- (id)initWithSectionedArray:(NSArray *)sectionedArray delegate:(id<UXCollectionNodeModelDelegate>)delegate;

#pragma mark - Accessing Objects

- (NSIndexPath *)indexPathForObject:(id)object;

#pragma mark - Creating Collection Node Cells

@property (nonatomic, weak) id<UXCollectionNodeModelDelegate> delegate;

@property (nonatomic) BOOL showLoadingIndicatorAtLast; // Default: NO

@end


@protocol UXCollectionNodeModelDelegate <NSObject>

@required

/**
 * Fetches a table view cell node at a given index path with a given object.
 *
 * The implementation of this method will generally use object to customize the cell node.
 */
- (ASCellNodeBlock)collectionNodeModel: (UXCollectionNodeModel *)collectionNodeModel
                   cellForCollectionNode: (ASCollectionNode *)collectionNode
                        atIndexPath: (NSIndexPath *)indexPath
                         withObject: (id)object;

@optional

/**
 * Fetches a supplementary collection view element at a given indexPath.
 *
 * The value of the kind property and indexPath are implementation-dependent
 * based on the type of UICollectionViewLayout being used.
 */
- (ASCellNode *)collectionNodeModel:(UXCollectionNodeModel *)collectionNodeModel
                                   collectionNode:(ASCollectionNode *)collectionNode
                viewForSupplementaryElementOfKind:(NSString *)kind
                                      atIndexPath:(NSIndexPath *)indexPath;

@end

@interface UXCollectionNodeModelFooter : NSObject

+ (id)footerWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title;

@property (nonatomic, copy) NSString* title;

@end



















