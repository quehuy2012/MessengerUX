//
//  UXMutableTableNodeModel.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXTableNodeModel.h"

@protocol UXMutableTableNodeModelDelegate <NSObject, UXTableNodeModelDelegate>

@optional

/**
 * Asks the receiver whether the object at the given index path should be editable.
 *
 * If this method is not implemented, the default response is assumed to be NO.
 */
- (BOOL)tableNodeModel: (UXTableNodeModel *)tableNodeModel
         canEditObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           inTableView:(UITableView *)tableView;

/**
 * Asks the receiver whether the object at the given index path should be moveable.
 *
 * If this method is not implemented, the default response is assumed to be NO.
 */
- (BOOL)tableNodeModel: (UXTableNodeModel *)tableNodeModel
         canMoveObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           inTableView:(UITableView *)tableView;

/**
 * Asks the receiver whether the given object should be moved.
 *
 * If this method is not implemented, the default response is assumed to be YES.
 *
 * Returning NO will stop the model from handling the move logic.
 */
- (BOOL)tableNodeModel: (UXTableNodeModel *)tableNodeModel
      shouldMoveObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           toIndexPath:(NSIndexPath *)toIndexPath
           inTableView:(UITableView *)tableView;

/**
 * Asks the receiver what animation should be used when deleting the object at the given index path.
 *
 * If this method is not implemented, the default response is assumed to be
 * UITableViewRowAnimationAutomatic.
 */
- (UITableViewRowAnimation)tableNodeModel: (UXTableNodeModel *)tableNodeModel
              deleteRowAnimationForObject:(id)object
                              atIndexPath:(NSIndexPath *)indexPath
                              inTableView:(UITableView *)tableView;

/**
 * Asks the receiver whether the given object should be deleted.
 *
 * If this method is not implemented, the default response is assumed to be YES.
 *
 * Returning NO will stop the model from handling the deletion logic. This is a good opportunity for
 * you to show a UIAlertView or similar feedback prompt to the user before initiating the deletion
 * yourself.
 */
- (BOOL)tableNodeModel: (UXTableNodeModel *)tableNodeModel
    shouldDeleteObject:(id)object
           atIndexPath:(NSIndexPath *)indexPath
           inTableView:(UITableView *)tableView;

@end

@interface UXMutableTableNodeModel : UXTableNodeModel

- (NSArray *)addObject:(id)object;
- (NSArray *)addObject:(id)object toSection:(NSUInteger)section;
- (NSArray *)addObjectsFromArray:(NSArray *)array;
- (NSArray *)insertObject:(id)object atRow:(NSUInteger)row inSection:(NSUInteger)section;
- (NSArray *)removeObjectAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

- (NSIndexSet *)addSectionWithTitle:(NSString *)title;
- (NSIndexSet *)insertSectionWithTitle:(NSString *)title atIndex:(NSUInteger)index;
- (NSIndexSet *)removeSectionAtIndex:(NSUInteger)index;

- (void)updateSectionIndex;

@property (nonatomic, weak) id<UXMutableTableNodeModelDelegate> delegate;

@end
