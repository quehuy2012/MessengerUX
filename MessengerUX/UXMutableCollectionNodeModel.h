//
//  UXMutableCollectionNodeModel.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXCollectionNodeModel.h"

@interface UXMutableCollectionNodeModel : UXCollectionNodeModel

- (NSArray *)addObject:(id)object;
- (NSArray *)addObject:(id)object toSection:(NSUInteger)section;
- (NSArray *)addObjectsFromArray:(NSArray *)array;
- (NSArray *)insertObject:(id)object atRow:(NSUInteger)row inSection:(NSUInteger)section;
- (NSArray *)removeObjectAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

- (NSIndexSet *)addSectionWithTitle:(NSString *)title;
- (NSIndexSet *)insertSectionWithTitle:(NSString *)title atIndex:(NSUInteger)index;
- (NSIndexSet *)removeSectionAtIndex:(NSUInteger)index;

@end
