//
//  UXLoadingCellNode.m
//  MessengerUX
//
//  Created by CPU11815 on 4/3/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXLoadingCellNode.h"

@interface UXLoadingCellNode ()

@property (nonatomic) ASDisplayNode *activityIndicatorNode;

@end

@implementation UXLoadingCellNode

- (instancetype)init {
    if (self = [super init]) {
        
        self.activityIndicatorNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView *{
            
            UIActivityIndicatorView * vv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [vv startAnimating];
            return vv;
        }];
        
        self.style.height = ASDimensionMake(80);
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASCenterLayoutSpec centerLayoutSpecWithCenteringOptions:ASCenterLayoutSpecCenteringXY sizingOptions:ASCenterLayoutSpecSizingOptionMinimumXY child:self.activityIndicatorNode];
}

@end
