//
//  UXImageMessage.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessage.h"

@interface UXImageMessage : UXMessage

@property (nonatomic) NSURL * imageURL;
@property (nonatomic) UIImage * image;
@property (nonatomic) CGFloat ratio;

- (instancetype)initWithImage:(UIImage *)image date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner;

- (instancetype)initWithImageURL:(NSURL *)imageURL withRatio:(CGFloat)ratio date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner;

@end
