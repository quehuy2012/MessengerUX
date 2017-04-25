//
//  UXVideoMessage.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessage.h"

@interface UXVideoMessage : UXMessage

@property (nonatomic) NSURL * videoURL;
@property (nonatomic) CGFloat ratio;

- (instancetype)initWithVideoURL:(NSURL *)videoURL withRatio:(CGFloat)ratio date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner;

@end
