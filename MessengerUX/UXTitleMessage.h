//
//  UXTitleMessage.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import "UXMessage.h"

@interface UXTitleMessage : UXMessage

@property (nonatomic) NSString * title;

- (instancetype)initWithTitle:(NSString *)title;

@end
