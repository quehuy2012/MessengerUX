//
//  UXTitleCellNode.m
//  MessengerUX
//
//  Created by CPU11815 on 4/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXTitleCellNode.h"

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
    if (self.mainTitle && object && [object isKindOfClass:[NSString class]]) {
        NSString * title = object;
        self.mainTitle.attributedText = [[NSAttributedString alloc] initWithString:title
                                                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                                                                     NSForegroundColorAttributeName: [UIColor blackColor]}];
    }
}

@end
