//
//  UXMessageBackgroundStyle.h
//  MessengerUX
//
//  Created by CPU11815 on 3/27/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "AsyncDisplayKit/AsyncDisplayKit.h"

@interface UXMessageBackgroundStyle : NSObject

@property (nonatomic) NSUInteger cornerRadius;

- (ASControlNode *)getMessageBackground;

@end
