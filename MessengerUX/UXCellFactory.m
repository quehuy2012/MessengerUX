//
//  UXCellFactory.m
//  MessengerUX
//
//  Created by CPU11815 on 4/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXCellFactory.h"

@interface UXCellFactory ()

@end

@implementation UXCellFactory

#pragma mark - UXCollectionNodeModelDelegate

+ (ASCellNodeBlock)collectionNodeModel:(UXCollectionNodeModel *)collectionNodeModel
                 cellForCollectionView:(ASCollectionNode *)collectionNode
                           atIndexPath:(NSIndexPath *)indexPath
                            withObject:(id)object {
    if ([object conformsToProtocol:@protocol(UXCellNodeObject)]) {
        return [((id<UXCellNodeObject>)object) cellNodeBlockWithObject:object];
    } else {
        return ^ASCellNode *() {
            return [[ASCellNode alloc] init];
        };
    }
}

- (ASCellNodeBlock)collectionNodeModel: (UXCollectionNodeModel *)collectionNodeModel
                 cellForCollectionNode: (ASCollectionNode *)collectionNode
                           atIndexPath: (NSIndexPath *)indexPath
                            withObject: (id)object {
    
    return [[self class] collectionNodeModel:collectionNodeModel
                       cellForCollectionView:collectionNode
                                 atIndexPath:indexPath
                                  withObject:object];
}

#pragma mark - UXMutableTableNodeModelDelegate

+ (ASCellNodeBlock)tableNodeModel: (UXTableNodeModel *)tableNodeModel
                 cellForTableNode: (ASTableNode *)tableNode
                      atIndexPath: (NSIndexPath *)indexPath
                       withObject: (id)object {
    if ([object conformsToProtocol:@protocol(UXCellNodeObject)]) {
        return [((id<UXCellNodeObject>)object) cellNodeBlockWithObject:object];
    } else {
        return ^ASCellNode *() {
            return [[ASCellNode alloc] init];
        };
    }
}

- (ASCellNodeBlock)tableNodeModel: (UXTableNodeModel *)tableNodeModel
                 cellForTableNode: (ASTableNode *)tableNode
                      atIndexPath: (NSIndexPath *)indexPath
                       withObject: (id)object {
    return [[self class] tableNodeModel:tableNodeModel
                       cellForTableNode:tableNode
                            atIndexPath:indexPath
                             withObject:object];
}

@end

@implementation UXCellNodeObject

- (instancetype)initWithCellNodeClass:(Class)cellNodeClass userInfo:(id)userInfo {
    self = [super init];
    if (self) {
        self.cellNodeClass = cellNodeClass;
        self.userInfo = userInfo;
    }
    return self;
}

+ (instancetype)objectWithCellNodeClass:(Class)cellNodeClass userInfo:(id)userInfo {
    return [[UXCellNodeObject alloc] initWithCellNodeClass:cellNodeClass userInfo:userInfo];
}

- (ASCellNodeBlock)cellNodeBlockWithObject:(id)object{
    
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        
        if ([self.cellNodeClass isSubclassOfClass:[ASCellNode class]]) {
            id ret = [[self.cellNodeClass alloc] init];
            
            if ([ret conformsToProtocol:@protocol(UXCellNode)]) {
                [((id<UXCellNode>)ret) shouldUpdateCellNodeWithObject:object];
            }
            
            return (ASCellNode *)ret;
        }
        
        return [[ASCellNode alloc] init];
    };
    
    return cellNodeBlock;
}

@end

