//
//  UXSentence+DummyComming.m
//  MessengerUX
//
//  Created by CPU11815 on 3/23/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXSentence+DummyComming.h"

@implementation UXSentence (DummyComming)

- (BOOL)commingMessage {
    return self.ID.integerValue % 2 == 0 || self.ID.integerValue % 13 == 0;
}

@end
