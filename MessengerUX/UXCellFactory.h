//
//  UXCellFactory.h
//  MessengerUX
//
//  Created by CPU11815 on 4/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "UXCollectionNodeModel.h"
#import "UXTableNodeModel.h"
#import "UXMutableTableNodeModel.h"

@interface UXCellFactory : NSObject <UXCollectionNodeModelDelegate, UXTableNodeModelDelegate>

#pragma mark - UXCollectionNodeModelDelegate

+ (ASCellNodeBlock)collectionNodeModel:(UXCollectionNodeModel *)collectionNodeModel
                 cellForCollectionView:(ASCollectionNode *)collectionNode
                           atIndexPath:(NSIndexPath *)indexPath
                            withObject:(id)object;

- (ASCellNodeBlock)collectionNodeModel: (UXCollectionNodeModel *)collectionNodeModel
                 cellForCollectionNode: (ASCollectionNode *)collectionNode
                           atIndexPath: (NSIndexPath *)indexPath
                            withObject: (id)object;

#pragma mark - UXMutableTableNodeModelDelegate

+ (ASCellNodeBlock)tableNodeModel: (UXTableNodeModel *)tableNodeModel
                 cellForTableNode: (ASTableNode *)tableNode
                      atIndexPath: (NSIndexPath *)indexPath
                       withObject: (id)object;

- (ASCellNodeBlock)tableNodeModel: (UXTableNodeModel *)tableNodeModel
                 cellForTableNode: (ASTableNode *)tableNode
                      atIndexPath: (NSIndexPath *)indexPath
                       withObject: (id)object;

@end

@protocol UXCellNodeObject <NSObject>
@required

- (ASCellNodeBlock)cellNodeBlockWithObject:(id)object;

@end

@protocol UXCellNode <NSObject>

@required

- (void)shouldUpdateCellNodeWithObject:(id)object;

@end

@interface UXCellNodeObject : NSObject <UXCellNodeObject>

@property (nonatomic) id userInfo;
@property (nonatomic) Class cellNodeClass;

- (instancetype)initWithCellNodeClass:(Class)cellNodeClass userInfo:(id)userInfo;

+ (instancetype)objectWithCellNodeClass:(Class)cellNodeClass userInfo:(id)userInfo;

@end
