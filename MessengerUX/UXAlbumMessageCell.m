//
//  UXAlbumMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 3/28/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXAlbumMessageCell.h"
#import "UXMessageCellConfigure.h"

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

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner {
    self = [super initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        self.nodePerRow = 3;
        self.spaceBetweenNode = 4;
        self.albumNodes = [@[] mutableCopy];
    }
    
    return self;
}

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentImage:(NSArray<UIImage *> *)images {
    self = [self initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        self.usingURL = NO;
        self.albumDatas = images;
        
        [self calculateNumOfRow];
        
        // init allbumNodes
        
        for (UIImage * img in self.albumDatas) {
            ASImageNode * imageNode = [[ASImageNode alloc] init];
            imageNode.style.height = ASDimensionMake(self.albumNodeDimention);
            imageNode.style.width = ASDimensionMake(self.albumNodeDimention);
            imageNode.clipsToBounds = YES;
            imageNode.image = img;
            [imageNode addTarget:self action:@selector(imageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
            [self addSubnode:imageNode];
            [self.albumNodes addObject:imageNode];
        }
    }
    
    return self;
}

- (instancetype)initWithConfigure:(UXMessageCellConfigure *)configure isIncomming:(BOOL)incomming andOwner:(UXSpeaker *)owner contentImageURL:(NSArray<NSURL *> *)imageURLs {
    self = [self initWithConfigure:configure isIncomming:incomming andOwner:owner];
    if (self) {
        self.usingURL = YES;
        self.albumDatas = imageURLs;
        
        [self calculateNumOfRow];
        
        for (NSURL * url in self.albumDatas) {
            ASNetworkImageNode * imageNode = [[ASNetworkImageNode alloc] init];
            imageNode.style.height = ASDimensionMake(self.albumNodeDimention);
            imageNode.style.width = ASDimensionMake(self.albumNodeDimention);
            imageNode.clipsToBounds = YES;
            imageNode.URL = url;
            [imageNode addTarget:self action:@selector(imageClicked:) forControlEvents:ASControlNodeEventTouchUpInside];
            [self addSubnode:imageNode];
            [self.albumNodes addObject:imageNode];
        }
    }
    
    return self;
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
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, self.configure.insets.left*2, 0, self.configure.insets.right*2)
                                               child:self.topTextNode];
        [stackedMessageChilds addObject:topTextInset];
    }
    
    [stackedMessageChilds addObject:mainWithSubFunctionStack];
    
    if (self.showTextAsBottom) {
        ASInsetLayoutSpec * bottomTextInset =
        [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(0, self.configure.insets.left*2, 0, self.configure.insets.right*2)
                                               child:self.bottomTextNode];
        [stackedMessageChilds addObject:bottomTextInset];
    }
    
    ASStackLayoutAlignItems supportAlignItem = ASStackLayoutAlignItemsStart;
    if (!self.isIncomming) {
        supportAlignItem = ASStackLayoutAlignItemsEnd;
    }
    
    ASStackLayoutSpec * stackedMessage =
    [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                            spacing:0
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
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:self.configure.insets child:mainContent];
    
}

- (NSUInteger)albumNodeDimention {
    return (self.configure.maxWidthOfCell - ((self.nodePerRow - 1) * self.spaceBetweenNode)) / self.nodePerRow;
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

#pragma mark - Action

- (void)imageClicked:(ASControlNode *)imageNode {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:albumImageClicked:)]) {
        [self.delegate messageCell:self albumImageClicked:imageNode];
    }
}

@end