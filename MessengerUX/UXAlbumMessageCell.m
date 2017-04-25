//
//  UXAlbumMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 3/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXAlbumMessageCell.h"
#import "UXMessageCellConfigure.h"
#import "UXAlbumMessage.h"
#import "UXNetworkImageNode.h"

@interface UXAlbumMessageCell ()

@property (nonatomic) NSArray * albumDatas;
@property (nonatomic) NSMutableArray<ASDisplayNode *> * albumNodes;
@property (nonatomic) BOOL usingURL;

@property (nonatomic) NSUInteger nodePerRow;
@property (nonatomic) NSUInteger numOfRow;
@property (nonatomic) NSUInteger spaceBetweenNode;
@property (nonatomic) NSUInteger albumNodeDimention;

@end

@implementation UXAlbumMessageCell

@synthesize delegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.nodePerRow = 3;
        self.spaceBetweenNode = 4;
        self.albumNodes = [@[] mutableCopy];
    }
    
    return self;
}

- (void)shouldUpdateCellNodeWithObject:(id)object {
    [super shouldUpdateCellNodeWithObject:object];
    if ([object isKindOfClass:[UXAlbumMessage class]]) {
        UXAlbumMessage * albumMessage = object;
        
        if (albumMessage.images != nil) {
            self.usingURL = NO;
            self.albumDatas = albumMessage.images;
            
            [self calculateNumOfRow];
            
            for (UIImage * img in self.albumDatas) {
                ASImageNode * imageNode = [[ASImageNode alloc] init];
                imageNode.style.height = ASDimensionMake(self.albumNodeDimention);
                imageNode.style.width = ASDimensionMake(self.albumNodeDimention);
                imageNode.clipsToBounds = YES;
                imageNode.layerBacked = YES;
                imageNode.cornerRadius = 8;
                imageNode.image = img;
                [imageNode addTarget:self action:@selector(imageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
                [self addSubnode:imageNode];
                [self.albumNodes addObject:imageNode];
            }
            
        } else {
            self.usingURL = YES;
            self.albumDatas = albumMessage.imageURLs;
            
            [self calculateNumOfRow];
            
            for (NSURL * url in self.albumDatas) {
                UXNetworkImageNode * imageNode = [[UXNetworkImageNode alloc] init];
                imageNode.style.height = ASDimensionMake(self.albumNodeDimention);
                imageNode.style.width = ASDimensionMake(self.albumNodeDimention);
                imageNode.clipsToBounds = YES;
                imageNode.layerBacked = YES;
                imageNode.cornerRadius = 8;
                imageNode.URL = url;
                [imageNode addTarget:self action:@selector(imageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
                [self addSubnode:imageNode];
                [self.albumNodes addObject:imageNode];
            }
        }
        
        [self setShowSubFunction:YES];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    
    NSMutableArray * rowSpecChilds = [@[] mutableCopy];
    
    for (int row = 0; row < self.numOfRow; row++) {
        
        NSMutableArray * specChilds = [@[] mutableCopy];
        for (int i = 0; i < self.nodePerRow; i++) {
            NSUInteger index = row*self.nodePerRow + i;
            if (index < self.albumNodes.count) {
                [specChilds addObject:self.albumNodes[index]];
            }
        }
        ASStackLayoutSpec * spec =
        [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                spacing:self.spaceBetweenNode
                                         justifyContent:ASStackLayoutJustifyContentStart
                                             alignItems:ASStackLayoutAlignItemsStart
                                               children:specChilds];
        
        [rowSpecChilds addObject:spec];
    }
    
    ASStackLayoutSpec * albumNodeStack =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                            spacing:self.spaceBetweenNode
                                     justifyContent:ASStackLayoutJustifyContentStart
                                         alignItems:ASStackLayoutAlignItemsStart
                                           children:rowSpecChilds];
    
    NSArray * mainChild = nil;
    if (self.showSubFunction) {
        if (self.isIncomming) {
            mainChild = @[albumNodeStack, self.subFuntionNode];
        } else {
            mainChild = @[self.subFuntionNode, albumNodeStack];
        }
    } else {
        mainChild = @[albumNodeStack];
    }
    
    ASStackLayoutSpec * mainWithSubFunctionStack =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                            spacing:16
                                     justifyContent:ASStackLayoutJustifyContentCenter
                                         alignItems:ASStackLayoutAlignItemsCenter
                                           children:mainChild];
    
    NSMutableArray * stackedMessageChilds = [@[] mutableCopy];
    if (self.showTextAsTop) {
        ASInsetLayoutSpec * topTextInset =
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, [UXMessageCellConfigure getGlobalConfigure].insets.left*2, 0, [UXMessageCellConfigure getGlobalConfigure].insets.right*2)
                                               child:self.topTextNode];
        [stackedMessageChilds addObject:topTextInset];
    }
    
    [stackedMessageChilds addObject:mainWithSubFunctionStack];
    
    if (self.showTextAsBottom) {
        ASInsetLayoutSpec * bottomTextInset =
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, [UXMessageCellConfigure getGlobalConfigure].insets.left*2, 0, [UXMessageCellConfigure getGlobalConfigure].insets.right*2)
                                               child:self.bottomTextNode];
        [stackedMessageChilds addObject:bottomTextInset];
    }
    
    ASStackLayoutAlignItems supportAlignItem = ASStackLayoutAlignItemsStart;
    if (!self.isIncomming) {
        supportAlignItem = ASStackLayoutAlignItemsEnd;
    }
    
    ASStackLayoutSpec * stackedMessage =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                            spacing:4
                                     justifyContent:ASStackLayoutJustifyContentCenter
                                         alignItems:supportAlignItem
                                           children:stackedMessageChilds];
    
    NSArray * mainChilds = nil;
    ASStackLayoutJustifyContent mainLayoutJustify = ASStackLayoutJustifyContentStart;
    if (self.isIncomming) {
        mainChilds = @[self.avatarNode, stackedMessage];
    } else {
        mainChilds = @[stackedMessage, self.avatarNode];
        mainLayoutJustify = ASStackLayoutJustifyContentEnd;
    }
    
    ASStackLayoutSpec * mainContent =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                            spacing:8
                                     justifyContent:mainLayoutJustify
                                         alignItems:ASStackLayoutAlignItemsEnd
                                           children:mainChilds];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:[UXMessageCellConfigure getGlobalConfigure].insets child:mainContent];
    
}

- (NSUInteger)albumNodeDimention {
    return ([UXMessageCellConfigure getGlobalConfigure].maxWidthOfCell - ((self.nodePerRow - 1) * self.spaceBetweenNode)) / self.nodePerRow;
}

- (BOOL)imageUsingURL {
    return self.usingURL;
}

- (void)calculateNumOfRow {
    if (self.albumDatas.count % self.nodePerRow == 0) {
        self.numOfRow = self.albumDatas.count / self.nodePerRow;
    } else {
        self.numOfRow = (self.albumDatas.count / self.nodePerRow) + 1;
    }
}

- (CGRect)editableFrame {
    if (self.albumDatas && self.albumDatas.count > 0) {
        
        NSUInteger width = self.albumNodeDimention * self.nodePerRow + (self.nodePerRow - 1) * self.spaceBetweenNode;
        NSUInteger height = self.albumNodeDimention * self.numOfRow + (self.numOfRow - 1) * self.spaceBetweenNode;
        
        return CGRectMake(self.albumNodes[0].frame.origin.x, self.albumNodes[0].frame.origin.y, width, height);
    } else {
        return CGRectZero;
    }
}

#pragma mark - Action

- (void)imageClicked:(ASControlNode *)imageNode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:albumImageClicked:)]) {
        [self.delegate messageCell:self albumImageClicked:imageNode];
    }
}

- (void)beginHighlight {
    [self setHighlighted:YES];
}

- (void)endHighlight {
    [self setHighlighted:NO];
}

#pragma mark - Memory managment

- (void)clearContents {
    [super clearContents];
    
    for (ASDisplayNode * imgNode in self.albumNodes) {
        [imgNode clearContents];
        [self clearLayerContentOfLayer:imgNode.layer];
    }
    
}

@end
