//
//  UXLocationMessageCell.m
//  MessengerUX
//
//  Created by CPU11815 on 4/11/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXLocationMessageCell.h"
#import "UXMessageCellConfigure.h"
#import "UXMessageBackgroundStyle.h"
#import "UXLocationMessage.h"

@interface UXLocationMessageCell ()

@property (nonatomic) ASMapNode * mapNode;
@property (nonatomic) NSUInteger mapPadding;

@end

@implementation UXLocationMessageCell

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mapPadding = 4;
    }
    
    return self;
}

- (void)shouldUpdateCellNodeWithObject:(id)object {
    [super shouldUpdateCellNodeWithObject:object];
    if ([object isKindOfClass:[UXLocationMessage class]]) {
        UXLocationMessage * locMessage = object;
        
        self.mapNode = [[ASMapNode alloc] init];
        self.mapNode.style.preferredSize = CGSizeMake([UXMessageCellConfigure getGlobalConfigure].maxWidthOfCell, [UXMessageCellConfigure getGlobalConfigure].maxWidthOfCell * 0.66);
        self.mapNode.cornerRadius = [[UXMessageCellConfigure getGlobalConfigure] getMessageBackgroundStyle].cornerRadius;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(locMessage.latitude, locMessage.longtitude);
        self.mapNode.region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = coord;
        
        self.mapNode.annotations = @[annotation];
        
        [self addSubnode:self.mapNode];
    }
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASInsetLayoutSpec * imageInset =
    [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(self.mapPadding, self.mapPadding, self.mapPadding, self.mapPadding)
                                           child:self.mapNode];
    
    ASBackgroundLayoutSpec * imageWithBackground =
    [ASBackgroundLayoutSpec backgroundLayoutSpecWithChild:imageInset background:self.messageBackgroundNode];
    
    NSArray * mainChild = nil;
    if (self.showSubFunction) {
        if (self.isIncomming) {
            mainChild = @[imageWithBackground, self.subFuntionNode];
        } else {
            mainChild = @[self.subFuntionNode, imageWithBackground];
        }
    } else {
        mainChild = @[imageWithBackground];
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

- (void)clearContents {
    [super clearContents];
    
    [self.mapNode clearContents];
    [self clearLayerContentOfLayer:self.mapNode.layer];
}

@end
