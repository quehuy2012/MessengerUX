//
//  UXMessageCell+Private.h
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface UXMessageCell (Private)

@property (nonatomic) ASTextNode * topTextNode;
@property (nonatomic) ASTextNode * bottomTextNode;
@property (nonatomic) ASImageNode * avatarNode;
@property (nonatomic) ASDisplayNode * messageBackgroundNode;

@end
