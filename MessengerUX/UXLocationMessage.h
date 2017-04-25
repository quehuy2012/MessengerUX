//
//  UXLocationMessage.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessage.h"

@interface UXLocationMessage : UXMessage

@property (nonatomic) double longtitude;
@property (nonatomic) double latitude;

- (instancetype)initWithLatitude:(double)latitude andLongtide:(double)longtitude date:(NSTimeInterval)time isComming:(BOOL)isComming owner:(UXOwner *)owner;

@end
