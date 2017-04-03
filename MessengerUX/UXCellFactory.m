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

- (instancetype)init {
    self = [super init];
    if (self) {
        // nothing more
    }
    return self;
}

+ (ASCellNodeBlock)collectionNodeModel:(UXCollectionNodeModel *)collectionNodeModel
                 cellForCollectionView:(ASCollectionNode *)collectionNode
                           atIndexPath:(NSIndexPath *)indexPath
                            withObject:(id)object {
    if ([object conformsToProtocol:@protocol(UXCellNodeObject)]) {
        return [((id<UXCellNodeObject>)object) cellNodeBlock];
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
    
    if ([object conformsToProtocol:@protocol(UXCellNodeObject)]) {
        return [((id<UXCellNodeObject>)object) cellNodeBlock];
    } else {
        return ^ASCellNode *() {
            return [[ASCellNode alloc] init];
        };
    }
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

- (ASCellNodeBlock)cellNodeBlock{
    
    ASCellNode *(^cellNodeBlock)() = ^ASCellNode *() {
        
        if ([self.cellNodeClass isSubclassOfClass:[ASCellNode class]]) {
            id ret = [[self.cellNodeClass alloc] init];
            
            if ([ret conformsToProtocol:@protocol(UXCellNode)]) {
                [((id<UXCellNode>)ret) shouldUpdateCellNodeWithObject:self.userInfo];
            }
            
            return (ASCellNode *)ret;
        }
        
        return [[ASCellNode alloc] init];
    };
    
    return cellNodeBlock;
}

@end

