//
//  UXMessage.h
//  MessengerUX
//
//  Created by CPU11815 on 4/4/17.
//  Copyright © 2017 CPU11815. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UXNodeModel.h"
#import "UXOwner.h"

@interface UXMessage : UXCellNodeObject

@property (nonatomic) NSString * ID;
@property (nonatomic) UXOwner * owner;
@property (nonatomic) NSTimeInterval time;
@property (nonatomic) BOOL commingMessage;

@end
