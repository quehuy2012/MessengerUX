//
//  UXCellCatalog.m
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXCellCatalog.h"

@interface UXTitleCellNode ()

@property (nonatomic) ASTextNode * mainTitle;

@end

@implementation UXTitleCellNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mainTitle = [[ASTextNode alloc] init];
        self.mainTitle.backgroundColor = [UIColor clearColor];
        self.mainTitle.style.flexShrink = 1.0;
        self.mainTitle.truncationMode = NSLineBreakByTruncatingTail;
        self.mainTitle.maximumNumberOfLines = 1;
        [self addSubnode:self.mainTitle];
        
        self.style.height = ASDimensionMake(44);
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(8, 8, 8, 8) child:self.mainTitle];
}

- (void)shouldUpdateCellNodeWithObject:(id)object {
    UXCellNodeObject * nodeObject = object;
    if (self.mainTitle && object) {
        NSString * title = nodeObject.userInfo;
        self.mainTitle.attributedText = [[NSAttributedString alloc] initWithString:title
                                                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                                                                     NSForegroundColorAttributeName: [UIColor blackColor]}];
    }
}

@end

@interface UXTitleWithImageCellNode ()

@property (nonatomic) ASImageNode * thumbNode;

@end

@implementation UXTitleWithImageCellNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.thumbNode = [[ASImageNode alloc] init];
        self.thumbNode.layerBacked = YES;
        self.thumbNode.style.maxSize = CGSizeMake(34, 34);
        self.thumbNode.backgroundColor = [UIColor clearColor];
        self.thumbNode.image = [UIImage imageNamed:@"personImage"];
        [self addSubnode:self.thumbNode];
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(8, 8, 8, 8)
                                                  child:[ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                                                                spacing:8
                                                                                         justifyContent:ASStackLayoutJustifyContentStart
                                                                                             alignItems:ASStackLayoutAlignItemsStart
                                                                                               children:@[self.thumbNode
                                                                                                          , [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionStart
                                                                                                                                                                  verticalPosition:ASRelativeLayoutSpecPositionCenter
                                                                                                                                                                      sizingOption:ASRelativeLayoutSpecSizingOptionDefault
                                                                                                                                                                             child:self.mainTitle]]]];
}

@end

@interface UXLoadingCellNode ()

@property (nonatomic) ASDisplayNode * indicatorNode;

@end

@implementation UXLoadingCellNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.indicatorNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView * _Nonnull{
            
            UIActivityIndicatorView * indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            return indicator;
        }];
        
        self.indicatorNode.backgroundColor = [UIColor greenColor];
        self.indicatorNode.style.height = ASDimensionMake(44);
        
        [self addSubnode:self.indicatorNode];
    }
    
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal
                                                   spacing:0
                                            justifyContent:ASStackLayoutJustifyContentCenter
                                                alignItems:ASStackLayoutAlignItemsCenter
                                                  children:@[self.indicatorNode]];
}

- (void)didEnterVisibleState {
    [super didEnterVisibleState];
    [((UIActivityIndicatorView *)self.indicatorNode.view) startAnimating];
}

- (void)didExitVisibleState {
    [super didExitVisibleState];
    [((UIActivityIndicatorView *)self.indicatorNode.view) stopAnimating];
}

- (void)shouldUpdateCellNodeWithObject:(id)object {
    // do nothing
}

@end






