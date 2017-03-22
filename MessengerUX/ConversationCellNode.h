//
//  ConversationCellNode.h
//  MessengerUX
//
//  Created by Dam Vu Duy on 3/22/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class Sentence;
@class Speaker;

@interface ConversationCellNode : ASCellNode

- (instancetype)initWithSentence:(Sentence *)sentence;

@end
